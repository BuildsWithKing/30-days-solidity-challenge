// SPDX-License-Identifier: MIT

// Title: VoterVault
// Author: Michealking (@BuildsWithKing)
// Date Created: 5th of July, 2025

/* This is a decentralized voting system where owner can create proposals, Users can register and vote once.
    Votes and proposal are tracked. 
*/

pragma solidity ^0.8.18; 

error __VOTERVAULT_UNAUTHORIZEDACCESS(); // Custom error: Reverts message __VOTERVAULT_UNAUTHORIZEDACCESS
error  __VOTERVAULT_EXISTINGVOTER(); // Custom error: Reverts message  __VOTERVAULT_EXISTINGVOTER
error __VOTERVAULT_VOTERALREADYVOTED(); // Custom error: Reverts message __VOTERVAULT_VOTERALREADYVOTED
error __VOTERVAULT_EXISTINGPROPOSAL(); // Custom error: Reverts message __VOTERVAULT_EXISTINGPROPOSAL
error __VOTERVAULT_NOEXISTINGPROPOSAL(); // Custom error: Reverts message __VOTERVAULT_NOEXISTINGPROPOSAL
error __VOTERVAULT_NOTANEXISTINGVOTER(); // Custom error: Reverts message __VOTERVAULT_NOTANEXISTINGVOTER

contract VoterVault {

    address private owner; // Owner variable assignment 
    uint256 public totalVoters; // Records the number of registered voters
    uint256 public totalProposals; // Records the number of existing proposal

    // Groups voter's data
    struct Voter {
        string firstName;
        string lastName;
        bool hasVoted;
        uint256 timestamp;
    }

    // Groups proposal's data
    struct Proposal {
        string title;
        string description;
        uint256 proposalId;
        uint256 timestamp;
    }
 
    mapping(address => Voter) private voterData; // Links voter's address to their data
    mapping(address => Proposal) private proposalData; // Links user's address to their voted proposal

    event newRegistedVoter(string indexed firstName, string lastName, address userAddress); // Emits event newRegisteredVoter
    event userHasVoted(address indexed userAddress); //Emits event userHasVoted
    event newProposalCreated(string indexed title, string description, uint256 proposalId); // Emits event newProposalCreated


    // Sets owner as contract deployer
    constructor() {
        owner = msg.sender;
    }

   // Restricts access to only owner(contract deployer)
    modifier onlyOwner() {
     if(msg.sender != owner) revert __VOTERVAULT_UNAUTHORIZEDACCESS();
        _;
    }

    // Only Owner(contract deployer) can create proposal
    function createAProposal(string memory _title, string memory _description, uint256 _proposalId) public onlyOwner {
        if(bytes(proposalData[owner].title).length != 0) revert __VOTERVAULT_EXISTINGPROPOSAL();
        proposalData[owner] = Proposal(_title, _description, _proposalId, block.timestamp);
        totalProposals++;
        emit newProposalCreated(_title, _description, _proposalId);
    }

    // Returns bool (true or false); onlyOwner can call
    function getVoterStatus(address _userAddress) public view onlyOwner returns(bool) {
        return (voterData[_userAddress].hasVoted);
    }

    // Stores voter's details 
    function register(string memory _firstName, string memory _lastName) public {
        if (bytes(voterData[msg.sender].firstName).length != 0) revert __VOTERVAULT_EXISTINGVOTER();
            voterData[msg.sender] = Voter(_firstName, _lastName,false,block.timestamp);
            totalVoters++;
            emit newRegistedVoter(_firstName, _lastName, msg.sender);
    }
    // Gets Proposal Details
    function getProposalData(uint256 _proposalId) public view returns(string memory, string memory, uint256) {
        if(bytes(proposalData[owner].title).length == 0) revert __VOTERVAULT_NOEXISTINGPROPOSAL();
        Proposal memory proposal = proposalData[owner];
        return (proposal.title,proposal.description,_proposalId);  
    }

    // Allows voters to vote
    function vote(string memory _title, string memory _description, uint256 _proposalId) public {
        if(bytes(voterData[msg.sender].firstName).length == 0) revert __VOTERVAULT_NOTANEXISTINGVOTER();
        if (voterData[msg.sender].hasVoted == true) revert __VOTERVAULT_VOTERALREADYVOTED();
        if(bytes(proposalData[owner].title).length == 0) revert __VOTERVAULT_NOEXISTINGPROPOSAL();
        voterData[msg.sender].hasVoted = true;       
        proposalData[msg.sender] = Proposal(_title,_description,_proposalId,block.timestamp);
        emit userHasVoted(msg.sender);
    }

    // Returns bool (true or false)
    function getMyStatus() public view returns(bool) {
        return (voterData[msg.sender].hasVoted);
    }

    // Gets owner's (contract deployer) address 
    function getOwner() public view returns (address) {
        return owner;
    }
}   