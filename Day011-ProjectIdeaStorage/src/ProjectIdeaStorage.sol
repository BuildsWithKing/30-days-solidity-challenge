// SPDX-License-Identifier: MIT

/// @title ProjectIdeaStorage
/// @author Michealking (@BuildsWithKing)
/// @date created 7th of July, 2025

/// @notice This smart contract allows users add, view and optionally delete their startup/project ideas.

pragma solidity ^0.8.18;

error __PROJECTIDEASTORAGE_UNAUTHORIZEDACCESS(); // Custom error: Reverts  `__PROJECTIDEASTORAGE_UNAUTHORIZEDACCESS`
error __PROJECTIDEASTORAGE_INVALIDINDEX(); // Custom error: Reverts `__PROJECTIDEASTORAGE_INVALIDINDEX`

contract ProjectIdeaStorage {

    address private owner; // Assigns owner variable to address data type
    uint256 public totalIdea; // Records total idea

    // Groups user's idea
    struct Idea {
        string title;
        string description;
        uint256 timestamp;
        bool isPublic;
    }

    // Links user's address to their ideas
    mapping(address => Idea[]) private userIdeas;

    event IdeaAdded (string indexed title, string description, address indexed userAddress); // Emits Event IdeaAdded 
    event IdeaDeleted(uint256 indexed _indexNo, address indexed userAddress); // Emits Event IdeaDeleted

    // Sets owner as contract deployer
    constructor() {
        owner = msg.sender;
    }

    // Restricts access to only owner (contract deployer)
    modifier onlyOwner () {
        if(owner != msg.sender) revert __PROJECTIDEASTORAGE_UNAUTHORIZEDACCESS();
        _;
    }

    // Stores user's ideas
    function addIdea(string memory _title, string memory _description, bool _isPublic) public {
        Idea memory idea = Idea(_title, _description, block.timestamp, _isPublic);
        userIdeas[msg.sender].push(idea);
        emit IdeaAdded (_title, _description, msg.sender);
        totalIdea++;
    }
    
    // Gets Caller's Ideas
    function getMyIdeas() public view returns (Idea[] memory) {
        return userIdeas[msg.sender];
    }
    // Gets all Public ideas
    function getUserPublicIdeas(address _userAddress) public view returns (Idea[] memory) {
        Idea[] memory ideas = userIdeas[_userAddress];
        uint256 count;

        // Counts how many ideas are public 
        for (uint256 i = 0; i < ideas.length; i++) {
            if(ideas[i].isPublic) {
                count ++;
            }
        }

        // Now populate result array 
        Idea[] memory result = new Idea[](count);
        uint256 index;
        for (uint256 i = 0; i < ideas.length; i++) {
            if(ideas[i].isPublic) {
                result[index] = ideas[i];
                index++;
            }
        } 
        return result;
    }

    // Deletes idea of caller's index No
    function deleteIdea(uint256 _indexNo) public {
        Idea[] storage idea = userIdeas[msg.sender];
        if(_indexNo >= idea.length) revert __PROJECTIDEASTORAGE_INVALIDINDEX();

        for (uint256 i = _indexNo; i < idea.length - 1; i++) {
            idea[i] = idea[i + 1]; //Shift element left
        }
        idea.pop(); // Removes the last duplicate
        emit IdeaDeleted(_indexNo, msg.sender);
    }

    // Gets owner's (contract deployer) address
    function getOwner() public view returns (address) {
        return owner;
    }

    // Gets user's idea Count
    function getMyIdeaCount() public view returns (uint256) {
       return userIdeas[msg.sender].length;
    }

    // Only owner can delete users idea
    function deleteUserIdea(address _userAddress, uint256 _indexNo) public onlyOwner {
        Idea[] storage idea = userIdeas[_userAddress];

        for(uint i = _indexNo; i < idea.length - 1; i++) {
            idea[i] = idea[i + 1]; // Shift 
        }
        idea.pop();
    }

    // Gets users idea count (only owner can call)
    function getUserIdeaCount(address _userAddress) public onlyOwner view returns (uint256) {
        return userIdeas[_userAddress].length;
    }
}