// SPDX-License-Identifier: MIT

/* This smart contract allows users to store, view, update and delete their personal dreams (goals or aspiriations)
Each dream has a title, a description, and a timestamp of when it was added. Users can also manage their dreams. 
*/

pragma solidity ^0.8.18;

contract DreamVault {
    address private owner; //This stores the contract deployer's address

    //Struct stores multiple variables for easy access
    struct Dream {
        string title;
        string description;
        uint256 addAt;
    }

    uint256 public dreamCount; // records the numbers of dream

    mapping(address => Dream) private userDreams; //links users address to their dream

    address[] private dreamersAddress; //This is an array of dreamers address

    constructor() {
        owner = msg.sender; //The Constructor assigns owner as the contract deployer
    }

    //The modifier restricts special function access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized Access");
        _;
    }

    //This function stores user dream, verifies if the dreamer's title is unique then increments dreamCount
    function storeDream(string memory _title, string memory _description) public {
        if (bytes(userDreams[msg.sender].title).length == 0) {
            dreamersAddress.push(msg.sender);
            dreamCount++;
        }
        userDreams[msg.sender] = Dream(_title, _description, block.timestamp);
    }

    //This function allows dreamer view their stored dream
    function viewMyDream() public view returns (string memory title, string memory description, uint256 timestamp) {
        Dream memory dream = userDreams[msg.sender];
        return (dream.title, dream.description, dream.addAt);
    }

    //This function allows dreamer update their dreams
    function updateDream(string memory _newTitle, string memory _newDescription) public {
        userDreams[msg.sender] = Dream(_newTitle, _newDescription, block.timestamp);
    }

    //This function deletes dreamer stored dream
    function deleteDream() public {
        delete userDreams[msg.sender];
    }

    //This function allows only the owner view dreamer dreams
    function viewDream(address _dreamer) public view onlyOwner returns (string memory title, string memory description, uint256 timestamp) {
        Dream memory dream = userDreams[_dreamer];
        return (dream.title, dream.description, dream.addAt);
    }

    //This function returns the contract deployer's address
    function getOwner() public view returns (address) {
        return owner;
    }
    //This function returns dreamer at an index in the dreamerAddress array, accessible to only the owner

    function getDreamerAtIndex(uint256 _index) public view onlyOwner returns (address) {
        return dreamersAddress[_index];
    }
    //This function returns dreamer at index zero, only the owner can call this function

    function getDreamerAtIndexZero() public view onlyOwner returns (address) {
        return dreamersAddress[0];
    }
    //This function returns all dreamers stored in the dreamersAddress array

    function getAllDreamers() public view onlyOwner returns (address[] memory) {
        return dreamersAddress;
    }
}
