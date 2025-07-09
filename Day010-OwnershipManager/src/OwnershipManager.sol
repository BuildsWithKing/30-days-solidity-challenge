// SPDX-License-Identifier: MIT

// Title: OwnershipManager
// Author: MichealKing (@BuildsWithKing)
// Date Created: 7th of july, 2025

/**
 * @notice This smart contract assigns ownership, allows ownership transfer, 
 * and restricts access to certain function using the only owner pattern.
 *  @dev Useful for DAOs, admin-controlled dApps, and contract security upgrades.
*/

pragma solidity ^0.8.18;

error __OWNERSHIPMANAGER_UNAUTHORIZEDACCESS(); // Custom error: Reverts `__OWNERSHIPMANAGER_UNAUTHORIZEDACCESS`
error __OWNERSHIPMANAGER_INVALIDADDRESS(); // Custom error: Reverts `__OWNERSHIPMANAGER_INVALIDADDRESS`

contract OwnershipManager {

    address private owner; // Sets deployer's address as private

    // Groups owner's data
    struct Data {
        string firstName;
        string lastName;
        uint256 timestamp;
    }

    mapping(address => Data) private ownerData; // Links owner data

    event OwnershipTransferred(address indexed newOwnerAddress); // Emits event ownershipTransferred
    event OwnershipRenounced(address indexed addressZero); // Emits event ownershipRenounced 
    event NewOwnerData(string indexed firstName, string lastName); // Emits event newOwnerData

   // Sets owner as contract deployer
    constructor() {
        owner = msg.sender; 
    }

    // Restrict access to only owner (contract deployer)
    modifier onlyOwner() {
        if(owner != msg.sender) revert __OWNERSHIPMANAGER_UNAUTHORIZEDACCESS();
        _;
    }

    // Only owner can transfer ownership
    function transferOwnership(address _newOwnerAddress) public onlyOwner {
        if(_newOwnerAddress == address(0)) revert __OWNERSHIPMANAGER_INVALIDADDRESS();
        owner = _newOwnerAddress;
        emit OwnershipTransferred(_newOwnerAddress);
    }

    // Renounce contract ownership to the zero address
    function renounceOwnership() public onlyOwner {
        owner = address(0);
        emit OwnershipRenounced(address(0));
    }

    // Only owner can change owner's data
    function changeOwnerData(string memory _firstName, string memory _lastName) public onlyOwner {
        Data memory data = Data(_firstName, _lastName, block.timestamp);
        ownerData[owner] = data;
        emit NewOwnerData(_firstName, _lastName);
    }

    // Gets the current owner's address
    function getOwner() public view returns(address) {
        return owner;
    }

    // Gets the current owner's data
    function getOwnerData() public view returns(string memory, string memory, address, uint256) {
        Data memory data = ownerData[owner];
        return(data.firstName, data.lastName, owner, data.timestamp);
    }

    // Gets the contract summary
    function getContractSummary() public view returns(string memory, string memory, address) {
        Data memory data = ownerData[owner];
        return(data.firstName, data.lastName, owner);
    }
}