
// SPDX-License-Identifier: MIT

pragma solidity >0.8.0;


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}
abstract contract Ownable is Context {
    address private _owner;


    error OwnableUnauthorizedAccount(address account);


    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    
    function owner() public view virtual returns (address) {
        return _owner;
    }

   
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() private  onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract ChequeSystem is Ownable {
    mapping(bytes32 => Cheque) public cheques;
    mapping(bytes32 => bool) public clearedTxns;
    mapping (string => bytes32) public Hash;

    event ChequeGenerated(
        bytes32 indexed chequeHash,
        address sender,
        string receiver,
        uint256 amount,
        uint256 timestamp
    );
    event ChequeCleared(bytes32 indexed chequeHash, address bank);

    struct Cheque {
        address sender;
        string receiver;
        uint256 amount;
        uint256 timestamp;
        bytes digitalSignature;
    }

   
      constructor() Ownable(msg.sender) {}

    function generateCheque(
        string memory receiver,
        uint256 amount,
        uint256 timestamp,
        bytes memory digitalSignature
    ) public {
        require(amount > 0, "Amount must be greater than 0");

        bytes32 hash = keccak256(
            abi.encodePacked(receiver, amount, timestamp, digitalSignature)
        );
        require(
            cheques[hash].sender == address(0),
            "Cheque with same details already exists"
        );

        cheques[hash] = Cheque(
            msg.sender,
            receiver,
            amount,
            timestamp,
            digitalSignature
        );
        emit ChequeGenerated(hash, msg.sender, receiver, amount, timestamp);
        Hash[receiver]=hash;
    }

    function clearCheque(bytes32 chequeHash) public onlyOwner {
        require(
            cheques[chequeHash].sender != address(0),
            "Cheque does not exist"
        );
        require(!clearedTxns[chequeHash], "Cheque already cleared");

        clearedTxns[chequeHash] = true;
        emit ChequeCleared(chequeHash, msg.sender);
    }

    function isChequeCleared(bytes32 chequeHash) public view returns (bool) {
        return clearedTxns[chequeHash];
    }

    function verifyCheque(bytes32 chequeHash)
        public
        view
        returns (
            address,
            string memory,
            uint256,
            uint256,
            bytes memory
        )
    {
        Cheque memory cheque = cheques[chequeHash];
        require(cheque.sender != address(0), "Cheque does not exist");
        return (
            cheque.sender,
            cheque.receiver,
            cheque.amount,
            cheque.timestamp,
            cheque.digitalSignature
        );
    }
}
