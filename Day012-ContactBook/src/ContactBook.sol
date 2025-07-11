// SPDX-License-Identifier: MIT

/// @title ContactBook
/// @author Michealking (@BuildsWithKing)
/// @date created 9th of july, 2025

/// @notice Stores and manages user-submitted contacts 
/// @dev Supports contact add, view, and delete operations

pragma solidity ^0.8.18;

error __CONTACTBOOK_UNAUTHORIZED_ACCESS(); // Reverts message `__CONTACTBOOK_UNAUTHORIZED_ACCESS`
error __CONTACTBOOK_EXISTINGUSER(); // Reverts message `__CONTACTBOOK_EXISTINGUSER`
error __CONTACTBOOK_INVALIDINDEX(); // Reverts message `__CONTACTBOOK_INVALIDINDEX`

contract ContactBook {

    address private owner; // Deployer's address
    uint256 public totalContact; // Records stored contact

    // Groups contact data
    struct Contact {
        string firstName;
        string lastName;
        uint256 mobileNo;
        string emailAddress;
        uint256 timestamp;
    }

    mapping(address => Contact[]) private contactInfo; // User address linked to contact details

    event ContactAdded(string indexed firstName, string lastName, uint256 mobileNo, string emailAddress); // Emitted when a new contact is added
    event ContactDeleted(address indexed userAddress, uint256 indexNo); // Emitted when a new contact is deleted

    // Sets owner as contract deployer 
    constructor () {
        owner = msg.sender;
    }

    // Permits contract deployer only
    modifier onlyOwner() {
    if (owner != msg.sender) revert __CONTACTBOOK_UNAUTHORIZED_ACCESS();
        _;
    }

    // Add contact info
    function addContact(string memory _firstName, string memory _lastName, uint256 _mobileNo, string memory _emailAddress) public {
        Contact[] storage contact = contactInfo[msg.sender];

        for(uint256 i = 0; i < contact.length; i++) {
            if(contact[i].mobileNo == _mobileNo) {
                revert __CONTACTBOOK_EXISTINGUSER(); // Prevents duplicate mobile numbers
            }
        }

        Contact memory newContact = Contact(_firstName, _lastName, _mobileNo, _emailAddress, block.timestamp);
        contact.push(newContact);

        emit ContactAdded(_firstName, _lastName, _mobileNo, _emailAddress);
        totalContact++;
    }

    // Gets contact of a user
    function getMyContacts() public view returns (Contact[] memory) {
        Contact[] memory contact = contactInfo[msg.sender];
        return contact;
    }

    // Gets user's contact count
    function getMyContactCount() public view returns(uint256) {
        return contactInfo[msg.sender].length;
    } 

    // Deletes contact
     function deleteContact(uint256 _contactIndex) public {
        Contact[] storage contact = contactInfo[msg.sender];
        if(_contactIndex >= contact.length) revert __CONTACTBOOK_INVALIDINDEX();

        for(uint256 i = _contactIndex; i < contact.length - 1; i++) {
            contact[i] = contact[i + 1]; // Shifts element left
        } 
        contact.pop(); // Removes the last Duplicate
        emit ContactDeleted(msg.sender, _contactIndex);
    }

    // Gets owner address
    function getOwner() public view returns (address) {
        return owner;
    }

    // Deletes Users contact (only Owner)
    function deleteUserContact(address _userAddress, uint256 _contactIndex) public onlyOwner {
        Contact[] storage contact = contactInfo[_userAddress];
      if(_contactIndex >= contact.length) revert  __CONTACTBOOK_INVALIDINDEX();
      for (uint256 i = _contactIndex; i < contact.length - 1; i++ ){
            contact[i] = contact[i + 1]; // Shift element left
      }
        contact.pop(); // Removes the last Duplicate
    }

    // Only owner can get users contacts
    function getUserContacts(address _userAddress) public onlyOwner view returns (Contact[] memory) {
        return contactInfo[_userAddress];
    }
}