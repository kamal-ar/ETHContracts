// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MultiSigWallet {
    event Submission(uint256 indexed transactionId);
    event Confirmation(address indexed sender, uint256 indexed transactionId);
    event Execution(uint256 indexed transactionId);
    event ExecutionFailure(uint256 indexed transactionId);

    address[3] public owners;
    uint256 public required = 2;
    uint256 public transactionCount = 0;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
    }

    mapping(uint256 => Transaction) public transactions;
    mapping(uint256 => mapping(address => bool)) public confirmations;

    modifier onlyOwner() {
        bool isOwner = false;
        for (uint i = 0; i < 3; i++) {
            if (msg.sender == owners[i]) {
                isOwner = true;
                break;
            }
        }
        require(isOwner, "Not an owner");
        _;
    }
    
    modifier transactionExists(uint256 transactionId) {
        require(transactions[transactionId].to != address(0), "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint256 transactionId) {
        require(!transactions[transactionId].executed, "Transaction already executed");
        _;
    }

    modifier notConfirmed(uint256 transactionId) {
        require(!confirmations[transactionId][msg.sender], "Transaction already confirmed");
        _;
    }

    constructor(address[3] memory _owners) {
        for (uint i = 0; i < 3; i++) {
            require(_owners[i] != address(0), "Invalid owner");
            owners[i] = _owners[i];
        }
    }

    function submitTransaction(address _to, uint256 _value, bytes memory _data) public onlyOwner returns (uint256 transactionId)
    {
        transactionId = transactionCount;
        transactions[transactionId] = Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        });
        transactionCount += 1;
        emit Submission(transactionId);
    }

    function confirmTransaction(uint256 transactionId) public onlyOwner transactionExists(transactionId) notExecuted(transactionId) notConfirmed(transactionId)
    {
        confirmations[transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, transactionId);
    }

    function executeTransaction(uint256 transactionId) public onlyOwner transactionExists(transactionId) notExecuted(transactionId)
    {
        require(isConfirmed(transactionId), "Cannot execute transaction: not enough confirmations");
        Transaction storage txn = transactions[transactionId];
        txn.executed = true;
        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        if (success)
            emit Execution(transactionId);
        else {
            emit ExecutionFailure(transactionId);
            txn.executed = false;
        }
    }

    function isConfirmed(uint256 transactionId) public view returns (bool) {
        uint256 count = 0;
        for (uint i = 0; i < 3; i++) {
            if (confirmations[transactionId][owners[i]])
                count += 1;
            if (count == required)
                return true;
        }
        return false;
    }
}

