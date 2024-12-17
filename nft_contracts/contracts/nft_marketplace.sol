// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract NFTMarketplaceUpgradeable is Initializable, ReentrancyGuardUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _listingIds;

    struct Listing {
        uint256 listingId;
        address nftContract;
        uint256 tokenId;
        address seller;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    mapping(address => uint256) public proceeds;

    uint256 public minSalePrice;

    event ListingCreated(uint256 listingId, address nftContract, uint256 tokenId, address seller, uint256 price);
    event ListingCancelled(uint256 listingId);
    event ListingSold(uint256 listingId, address buyer);
    event ProceedsWithdrawn(address seller, uint256 amount);
    event MinSalePriceUpdated(uint256 newMinSalePrice);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize(address multiSigAdmin) public initializer {
        __ReentrancyGuard_init();
        __Ownable_init(multiSigAdmin);
        __UUPSUpgradeable_init();
        minSalePrice = 0; // Made with a mind for part 3
    }

    function createListing(address _nftContract, uint256 _tokenId, uint256 _price) external nonReentrant {
        require(_price >= minSalePrice, "Price must be greater than or equal to minimum sale price");
        IERC721Upgradeable nftContract = IERC721Upgradeable(_nftContract);
        require(nftContract.ownerOf(_tokenId) == msg.sender, "You don't own this NFT");
        require(nftContract.isApprovedForAll(msg.sender, address(this)), "NFT not approved for marketplace");

        _listingIds.increment();
        uint256 listingId = _listingIds.current();

        listings[listingId] = Listing(listingId, _nftContract, _tokenId, msg.sender, _price, true);

        emit ListingCreated(listingId, _nftContract, _tokenId, msg.sender, _price);
    }

    function cancelListing(uint256 _listingId) external nonReentrant {
        Listing storage listing = listings[_listingId];
        require(listing.seller == msg.sender, "You're not the seller");
        require(listing.active, "Listing is not active");

        listing.active = false;
        emit ListingCancelled(_listingId);
    }

    function buyNFT(uint256 _listingId) external payable nonReentrant {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Listing is not active");
        require(msg.value >= listing.price, "Insufficient payment");

        listing.active = false;
        proceeds[listing.seller] += msg.value;

        IERC721Upgradeable(listing.nftContract).safeTransferFrom(listing.seller, msg.sender, listing.tokenId);

        emit ListingSold(_listingId, msg.sender);
    }

    function updateListing(uint256 _listingId, uint256 _newPrice) external nonReentrant {
        Listing storage listing = listings[_listingId];
        require(listing.seller == msg.sender, "You're not the seller");
        require(listing.active, "Listing is not active");
        require(_newPrice >= minSalePrice, "Price must be greater than or equal to minimum sale price");

        listing.price = _newPrice;
    }

    function withdrawProceeds() external nonReentrant {
        uint256 amount = proceeds[msg.sender];
        require(amount > 0, "No proceeds to withdraw");

        proceeds[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit ProceedsWithdrawn(msg.sender, amount);
    }

    function getListing(uint256 _listingId) external view returns (Listing memory) {
        return listings[_listingId];
    }

    function setMinSalePrice(uint256 _minSalePrice) external onlyOwner {
        minSalePrice = _minSalePrice;
        emit MinSalePriceUpdated(_minSalePrice);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

