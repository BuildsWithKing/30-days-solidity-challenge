// SPDX-License-Identifier: MIT

// Author: Michealking (@BuildsWithKing)
// Project: WhitelistDapp
// Date Created: July 3, 2025
// Date Improved: July 4, 2025

/* This is a basic whitelist smart contract where users can opt-in to be whitelisted,
    only the owner (deployer) can remove user and the contract tracks if users are whitelisted or not.
*/

error __WHITELISTDAPP_EXISTINGUSER(); //custom error: Reverts the message EXISTINGUSER, if user exist.
error __WHITELISTDAPP_UNAUTHORIZEDACCESS(); // custom error: Reverts the message __WHITELISTDAPP_UNAUTHORIZEDACCESS(), if not the contract deployer

pragma solidity ^0.8.18;

contract WhitelistDapp {
    address private owner; // Contract deployer's address assignment
    uint256 public addressCount; // Records whitelisted address

    mapping(address => bool) private whitelist; // Links address to boolean (true and false)
    address[] private usersAddress; // An array that records usersAddress

    // Sets owner as contract deployer
    constructor() {
        owner = msg.sender;
    }

    // Restricts access, and permits only contract deployer (owner)
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert __WHITELISTDAPP_UNAUTHORIZEDACCESS();
        }
        _;
    }

    // Allows users to join whitelist
    function joinWhitelist() public {
        if (whitelist[msg.sender] == true) revert __WHITELISTDAPP_EXISTINGUSER();
        whitelist[msg.sender] = true;
        addressCount++;
        usersAddress.push(msg.sender);
    }

    // Returns users address if whitelisted, returns false if not whitelisted
    function checkIfWhitelisted() public view returns (bool) {
        return whitelist[msg.sender];
    }

    // Returns an Address if whitelisted, returns false if not whitelisted
    function checkIfUserIsWhitelisted(address _userAddress) public view returns (bool) {
        return whitelist[_userAddress];
    }

    // Allows only owner (contract deployer) to delete whitelisted address
    function deleteAddress(address _userAddress) public onlyOwner {
        delete whitelist[_userAddress];
        unchecked {
            addressCount--;
        }
    }

    // Returns all whitelisted users including addresses deleted by contract deployer
    function getAllWhitelistedUsers() public view onlyOwner returns (address[] memory) {
        return usersAddress;
    }

    // Returns address of the contract deployer
    function getOwner() public view returns (address) {
        return owner;
    }
}
