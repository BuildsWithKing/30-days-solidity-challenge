// SPDX-License-Identifier: MIT

/// @title ReferralSystem
/// @author Michealking (@BuildsWithKing)
/// @date created 11th of july, 2025

/// @notice Stores users data, tracks user referrals, rewards them for inviting others and keeps referral history organized per user.  
/// @custom: security-contact buildswithking@gmail.com

pragma solidity ^0.8.18;

/// @dev Thrown when a caller tries to perform an owner-only action without permission.
error __REFERRALSYSTEM_UNAUTHORIZED_ACCESS();

/// @dev Thrown when a user tries to reregister
error __REFERRALSYSTEM_EXISTING_USER(); 

/// @dev Thrown when a user tries to refer self
error __REFERRALSYSTEM_SELF_REFERRAL_FAILED(); 

/// @dev Thrown when a user tries registering with an invalid address
error __REFERRALSYSTEM_INVALID_REFERRAL_ADDRESS();

/// @dev Thrown when owner inputs an invalid eth amount
error __REFERRALSYSTEM_INVALID_ETH_AMOUNT();

/// @dev Thrown when payment to user failed
error __REFERRALSYSTEM_PAYMENT_FAILED(); 

/// @dev Thrown when a user tries to register using a different referral address
error __REFERRALSYSTEM_ALREADY_REFERRED(); 

contract ReferralSystem {

    /// @notice Contract deployer's address (immutable)
    address immutable i_owner; 

    /// @notice Tracks total registered user
    uint256 public totalRegisteredUser;

    /// @notice Tracks contract's total referrals 
    uint256 public totalReferralCount; 
     
    /// @dev Represents a registered user's metadata
    struct User {
        string firstName;
        string lastName;
        string emailAddress;
        uint256 timestamp;
    }

    /// @dev Maps user's address to their data
    mapping(address => User) internal userData;

    /// @dev Maps user's address to their referrals
    mapping(address => address[]) private userReferrals;

    /// @dev Maps user's address to address they were referred by
    mapping(address => address) private referredBy;

    /// @notice Tracks when a user is registered
    mapping(address => bool) public isRegistered;

    /// @notice Emitted when a user registers.
    /// @param firstName The user's first name
    /// @param lastName The user's last name
    /// @param userAddress Wallet address of the registered user.
    event RegisteredUser(string firstName, string lastName, address indexed userAddress);

    /// @notice Emitted when a referral is added.
    /// @param referrerAddress The wallet address of the  referrer.
    /// @param userAddress The user's wallet address.
    event ReferralAdded(address indexed referrerAddress, address indexed userAddress);

    /// @notice Emitted when user updates data
    /// @param firstName The user's first name
    /// @param lastName The user's last name
    event UpdatedData(address indexed userAddress, string firstName, string lastName);

    /// @notice Emitted when contract deployer funds user
    /// @param userAddress The user's address
    /// @param ethAmount ETH amount sent by contract deployer
    event UserFunded(address indexed userAddress, uint256 indexed ethAmount); // Emits UserFunded

    /// @notice Emitted when contract receives ETH with or with no calldata
    /// @param senderAddress The sender's address
    /// @param ethAmount The amount of ETH received
    event ReceivedETH(address indexed senderAddress, uint256 indexed ethAmount); // Emits ReceivedETH

    ///@notice Sets owner as contract deployer
    constructor() {
       i_owner = msg.sender;
    }

    /// @dev Only contract deployer is permitted
    modifier onlyOwner() {
        if(i_owner != msg.sender) revert __REFERRALSYSTEM_UNAUTHORIZED_ACCESS(); 
        _;
    }

    /// @notice Registers a new user in the system
    /// @param _firstName User's first name.
    /// @param _lastName User's last name.
    /// @param _emailAddress User's email address
    function register(string memory _firstName, string memory _lastName, string memory _emailAddress) public {
        if(bytes(userData[msg.sender].emailAddress).length > 0) revert __REFERRALSYSTEM_EXISTING_USER();

        User memory newUser = User(_firstName, _lastName, _emailAddress, block.timestamp);
        userData[msg.sender] = newUser;
        isRegistered[msg.sender] = true;
        totalRegisteredUser++;
        emit RegisteredUser(_firstName, _lastName, msg.sender);
    }

    /// @notice Registers a new user in the system
    /// @param _firstName User's first name.
    /// @param _lastName User's last name.
    /// @param _emailAddress User's email address
    function updateMyData(string memory _firstName, string memory _lastName, string memory _emailAddress) public {
        User memory userNewData = User(_firstName, _lastName, _emailAddress, block.timestamp);
        userData[msg.sender] = userNewData;
        emit UpdatedData(msg.sender, _firstName, _lastName);
    }

    /// @notice Stores user's referrer Address
    /// @param _referrerAddress User's optional referrer Address
    function referralAddressOptional(address _referrerAddress) public {
        if(_referrerAddress == msg.sender) revert __REFERRALSYSTEM_SELF_REFERRAL_FAILED();
        if(_referrerAddress == address(0)) revert __REFERRALSYSTEM_INVALID_REFERRAL_ADDRESS();
        if(referredBy[msg.sender] != address(0)) revert __REFERRALSYSTEM_ALREADY_REFERRED();
        referredBy[msg.sender] = _referrerAddress;
        userReferrals[_referrerAddress].push(msg.sender);
        totalReferralCount++;
        emit ReferralAdded(_referrerAddress, msg.sender);
    }
    
    /// @notice Returns user's data
    /// @return User's data
    function getMyData() public view returns (User memory) {
        return userData[msg.sender];
    }

    /// @notice Returns user's referrer address
    /// @return User's referrer address
    function getReferrer() public view returns(address) {
        return referredBy[msg.sender];
    }

    /// @notice Returns user's total refferals
    /// @return Array of user's total refferals
    function getMyReferrals() public view returns(address[] memory) {
       return userReferrals[msg.sender];
    }
    
    /// @notice Returns user's refferal count
    /// @return User's total referrals (unsigned integer)
    function getMyTotalReferrals() public view returns(uint256) {
        return userReferrals[msg.sender].length;
    } 
    
    /// @notice Returns contract deployer's address
    /// @return owner's address
    function getOwner() public view returns (address) {
        return i_owner;
    }

    /// @notice Only contract deployer can fund user
    /// @param _userAddress User's Address
    function fundUser(address _userAddress) payable external onlyOwner {
        if(msg.value <= 0) revert __REFERRALSYSTEM_INVALID_ETH_AMOUNT();
       (bool success, ) = payable(_userAddress).call{value: msg.value}("");
        if(!success) revert __REFERRALSYSTEM_PAYMENT_FAILED();
        emit UserFunded(_userAddress, msg.value);
    }

    /// @notice Only contract deployer can get users referrals
    /// @return Arrays of user's refferals
    function getUserReferrals(address _userAddress) public view onlyOwner returns(address[] memory) {
        return userReferrals[_userAddress];
    }

    /// @notice Only contract deployer can get users data
    /// @return User's data
    function getUserData(address _userAddress) public view onlyOwner returns(User memory) {
       return userData[_userAddress];
    }

    /// @notice Only owner can get all referral stats
    function getAllReferralStats() public view onlyOwner returns (uint256 totalUser, uint256 totalReferrals) {
        return (totalRegisteredUser, totalReferralCount);
    }

    /// @notice Receives ETH with no calldata
    receive() external payable {
        emit ReceivedETH(msg.sender, msg.value);
    }

    /// @notice Handles ETH sent with calldata
    fallback() external payable {
        emit ReceivedETH(msg.sender, msg.value);
    }
}