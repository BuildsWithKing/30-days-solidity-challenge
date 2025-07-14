// SPDX-License-Identifier: MIT

// Contract is not active by default, Activate Contract once deployed.

/// @title WalletGuard
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// @date Created 12th of July, 2025
/// @notice Acts as a protective layer over user wallets, enables users to whitelist safe addresses, 
/// block unknown interactions, and optionally pause wallet operation if a threat is detected.

pragma solidity ^0.8.18; 

/// @dev Thrown when a user tries to perform an owner-only operation.
error __WALLETGUARD_UNAUTHORIZED_ACCESS(); 

/// @dev Thrown when a zero address tries to register
error __WALLETGUARD_INVALID_ADDRESS();

/// @dev Thrown when a user tries to reregister
error __WALLETGUARD_ALREADY_REGISTERED();

/// @dev Thrown when an unwhitelisted address tries to interact
error __WALLETGUARD_ACCESS_DENIED();

/// @dev Thrown when contract is paused
error __WALLETGUARD_PAUSED_CONTRACT();

/// @dev Thrown when user input an invalid index
error __WALLETGUARD_INVALID_INDEX();

/// @dev Thrown when eth amount is lower or equal 0
error __WALLETGUARD_INVALID_ETH_AMOUNT();

/// @dev Thrown when eth transfer failed
error __WALLETGUARD_TRANSFER_FAILED();

/// @dev Thrown when user tries to stores existing whitelisted address
error __WALLETGUARD_ALREADY_WHITELISTED();

contract WalletGuard {

    /// @notice The deployer of the contract
     address immutable owner; 
    /// @notice Records registered addresses
    uint256 public  addressCount;
    /// @notice Records whitelisted addresses
    uint256 public safeAddressCount;
    /// @notice pause functions
    bool isPaused;

    /// @dev struct to store user details
    struct User {
        string firstName;
        string lastName;
        address userAddress;
        uint256 timestamp;
    }

    /// @dev Maps user address to user details.
    mapping(address => User) internal userData;

    /// @dev Maps user address to whitelisted address.
     mapping(address => address[]) internal whitelistedAddress;

    /// @notice Emitted when a user registers.
    /// @param firstName First name of the user.
    /// @param lastName Last name of the user.
    /// @param userAddress Wallet Address of the user's address.
    event Registered(string indexed firstName, string indexed lastName, address indexed userAddress); 

     /// @notice Emitted when a user stores a safe address.
    /// @param userAddress The user's address
    /// @param safeAddress The whitelisted address
    event NewWhitelistedAddress(address indexed userAddress, address indexed safeAddress);

    /// @notice Emitted when suspicious Eth is received
    /// @param senderAddress The sender's address
    /// @param ethAmount The amount of Eth received
    event SuspiciousETHReceived(address indexed senderAddress, uint256 indexed ethAmount);

    /// @notice Emitted when Eth is sent
    /// @param userAddress The user's address
    /// @param ethAmount The amount of Eth sent
    event SentETH(address indexed userAddress, uint256 ethAmount);

    /// @notice Emitted when contract is active
    event ContractIsActive();
    /// @notice Emitted when contract is not active
    event InActiveContract();

    /// @notice Sets the deployer as the contract owner
    constructor() {
        owner = msg.sender; 
    }

    /// @dev Restricts access to only the contract owner
    modifier onlyOwner() {
    if(owner != msg.sender) revert __WALLETGUARD_UNAUTHORIZED_ACCESS();
        _;
    }
    /// @dev Activate and Deactivate contract
    modifier isActive() {
    if(!isPaused) revert __WALLETGUARD_PAUSED_CONTRACT();
     _;
    }

    /// @notice Registers a new user in the system
    /// @param _firstName The user's first name
    /// @param _lastName The user's last name 
    /// @param _userAddress The user's address
    function register(string memory _firstName, string memory _lastName, address _userAddress) public isActive {
        if(bytes(userData[msg.sender].firstName).length > 0) revert __WALLETGUARD_ALREADY_REGISTERED();
        if(_userAddress == address(0)) revert __WALLETGUARD_INVALID_ADDRESS();
        
        User memory user = User(_firstName, _lastName, _userAddress, block.timestamp);
        userData[msg.sender] = user;
        addressCount++;
        emit Registered(_firstName, _lastName, _userAddress);
    }

    /// @notice Stores user's safe address
    /// @param _safeAddress The user's safe address 
    function whitelistAddress(address _safeAddress) public isActive {
        if(_safeAddress == address(0) || _safeAddress == msg.sender) revert __WALLETGUARD_INVALID_ADDRESS();
        
        address [] storage list = whitelistedAddress[msg.sender];
        for(uint256 i = 0; i < list.length; i++) {
        if(list[i] == _safeAddress) revert __WALLETGUARD_ALREADY_WHITELISTED();

        }
        
        list.push(_safeAddress);
        safeAddressCount++;
        emit NewWhitelistedAddress(msg.sender, _safeAddress);
    }

    /// @notice Returns the caller's whitelisted Address
    /// @return caller's safe addresses
    function getMyWhitelistedAddress() public view isActive returns(address[] memory) {
        return whitelistedAddress[msg.sender];
    }

    /// @notice Updates user's safe address
    /// @param _newSafeAddress The user's safe new address  
    function updateWhitelistedAddress(uint256 _index, address _newSafeAddress) public isActive {
        if(_newSafeAddress == address(0) || _newSafeAddress == msg.sender) revert __WALLETGUARD_INVALID_ADDRESS();
        if(_index >= whitelistedAddress[msg.sender].length) revert __WALLETGUARD_INVALID_INDEX();
       whitelistedAddress[msg.sender][_index] =_newSafeAddress;
        
    }

    /// @notice Only owner can send ETH to whitelisted address
    /// @param _userAddress The user's address
    function sendETHToWhitelisted(address _userAddress) payable public onlyOwner isActive  {
        // Check if _userAddress is in the msg.sender's whitelist array
        address[] memory userWhitelist = whitelistedAddress[msg.sender];
        bool isSafe = false;

        for(uint256 i = 0; i < userWhitelist.length; i++) {
            if(userWhitelist[i] == _userAddress) {
                isSafe = true;
                break;
            }
        }

        if(!isSafe) { 
            emit SuspiciousETHReceived(msg.sender, msg.value);
        revert __WALLETGUARD_ACCESS_DENIED();
        }
        if(msg.value == 0) revert __WALLETGUARD_INVALID_ETH_AMOUNT();
        
        (bool success,) = payable(_userAddress).call{value:msg.value}("");
        if(!success) revert __WALLETGUARD_TRANSFER_FAILED();

        emit SentETH(_userAddress, msg.value);
    }

    /// @notice Returns the contract deployer's address
    /// @return return owner's address
    function getOwner() public view returns (address) {
        return owner;
    }

    /// @notice Owner can activate contract
    function activateContract() external onlyOwner {
        isPaused = true;
        emit ContractIsActive();
    }
    /// @notice Owner can Deactivate contract
    function deactivateContract() external onlyOwner {
        isPaused = false;
        emit InActiveContract();
    } 

    /// @notice Accepts ETH when sent directly to a contract (without calldata).
    receive() payable external {
        // Receives ETH with no calldata
        emit SuspiciousETHReceived(msg.sender, msg.value);
    }

    /// @notice Handles ETH sent with unknown function calldata
    fallback() payable external {
        // Handles ETH with calldata
        emit SuspiciousETHReceived(msg.sender, msg.value);    
    } 
}