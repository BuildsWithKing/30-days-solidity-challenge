// SPDX-License-Identifier: MIT

// Title: BasicKYC
// Author: MichealKing(@BuildsWithKing
// Date Created: 4th of July, 2025

/* This is a basic KYC smart contract where users can register with their names and wallet address, Owner can delete users, remove user's verification 
    and can mark user as verified.
    Users can check if they are verified or not, check verification of other users, and delete their details
*/

pragma solidity ^0.8.18;

error __BASICKYC_EXISTINGUSER(); // Custom error: Reverts message `__BASICKYC_EXISTINGUSER`
error __BASICKYC_USERISVERIFIED(); // Custom error: Reverts message `__BASICKYC_USERISVERIFIED`
error __BASICKYC_USERISNOTVERIFIED(); // Custom error: Reverts message `__BASICKYC_USERISNOTVERIFIED`
error __BASICKYC_UNAUTHORIZEDACCESS(); // Custom error: Reverts message `__BASICKYC_UNAUTHORIZEDACCESS`

contract BasicKYC { 

    address private owner; // Owner variable assignment
    uint256 public totalUsers; // Records number of users

    //groups user's data
    struct User{
        string firstName;
        string lastName;
        address userAddress;
    }

    mapping(address => User) usersDetail; // Links user's address to their details
    mapping (address => bool) usersVerification; //Links users address to boolean (true or false)

    event newUserRegistered(string indexed firstName, address userAddress); // Emits newUserRegistered event with firstName and userAddress
    event newAddressVerified(address indexed userAddress); // Emits newAddressVerified event with userAddress
    event userDeleted(address indexed userAddress); // Emits userDeleted event with userAddress
    
    // Sets Owner as Contract Deployer
    constructor () {
        owner = msg.sender;
    }
    // Restrict access to only owner (contract deployer)
    modifier onlyOwner() {
    if (msg.sender != owner) revert __BASICKYC_UNAUTHORIZEDACCESS();
        _;
    }

    // stores user's details
    function register(string memory _firstName, string memory _lastName, address _userAddress) public {
        if(bytes(usersDetail[msg.sender].firstName).length != 0 ) revert __BASICKYC_EXISTINGUSER();
        usersDetail[msg.sender] = User(_firstName,_lastName,_userAddress);
        totalUsers++;
        emit newUserRegistered(_firstName, _userAddress);
    }

    // Returns the caller's registered KYC details
    function getMyDetails() public view returns (string memory, string memory, address) {
    User memory user = usersDetail[msg.sender];
     return (user.firstName, user.lastName, user.userAddress);
    }

    // View another user's KYC details (only callable by the contract owner)
    function getUserDetail(address _userAddress) public view onlyOwner returns (string memory, string memory){
     User memory user = usersDetail[_userAddress];
     return (user.firstName, user.lastName);   
    } 

    // Only owner(contract deployer) can verify users
    function markAsVerified(address _userAddress) public onlyOwner {
        if (usersVerification[_userAddress] == true) revert __BASICKYC_USERISVERIFIED();
        usersVerification[_userAddress] = true;
        emit newAddressVerified (_userAddress);
    }

    // Returns `true` if verified, `false` if not 
    function checkIfVerified() public view returns (bool) { 
        return usersVerification[msg.sender];
    }

    //Returns `true` if address is verified, `false` if not
    function checkIfUserIsVerified(address _userAddress)public view returns (bool) {
        return usersVerification[_userAddress];
    }

    // Owner(contract deployer) can unverify user 
    function removeUserVerification(address _userAddress) public onlyOwner {
        if (usersVerification[_userAddress] == false) revert __BASICKYC_USERISNOTVERIFIED();
        usersVerification[_userAddress] = false;
    }
    // Deletes User (only owner)
    function deleteUser(address _userAddress) public onlyOwner {
       delete usersDetail[_userAddress];
       emit userDeleted(_userAddress);
    }

    // Deletes user their data
    function deleteMyData() public {
        delete usersDetail[msg.sender];
        emit userDeleted(msg.sender);
    }

      //Returns owner (contract deployer's) address
    function getOwner() public view returns (address) {
        return owner;
    }
}