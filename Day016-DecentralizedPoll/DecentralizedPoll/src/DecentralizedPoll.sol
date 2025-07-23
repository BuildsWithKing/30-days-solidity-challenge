// SPDX-License-Identifier: MIT

/// @title DecentralizedPoll - On-chain voting system.
/// @author Michealking (@BuildsWithKing).
/// @date created 13th of July, 2025.

/// @notice Allows anyone to create polls, vote transparently, with on-chain record keeping. 
/// @dev Contract manages poll lifecycle, custom errors optimize gas.

/// @notice See README for examples and Remix testing steps.

pragma solidity ^0.8.18;

/// @dev Thrown when a user tries to perform owner's operation.
error __DECENTRALIZEDPOLL_UNAUTHORIZED_ACCESS(); 

/// @dev Thrown when a user inputs less than two options
error __DECENTRALIZEDPOLL_MINIMUM_OF_TWO_OPTIONS_REQUIRED();

/// @dev Thrown when the contract is not active.
error __DECENTRALIZEDPOLL_INACTIVE_CONTRACT();

/// @dev Thrown when a non-poll creator tries to perform poll creator operation.
error __DECENTRALIZEDPOLL_ACCESS_DENIED();

/// @dev Thrown when user inputs non-existing poll id.
error __DECENTRALIZEDPOLL_NOT_AN_EXISTING_POLL();

/// @dev Thrown when owner tries to delete non-existing poll.
error __DECENTRALIZEDPOLL_NOT_USER_EXISTING_POLL();

/// @dev Thrown when a user tries to reactivate an active poll.
error __DECENTRALIZEDPOLL_POLL_IS_ACTIVE();

/// @dev Thrown when owner tries to end an already ended poll.
error __DECENTRALIZEDPOLL_POLL_ALREADY_ENDED();

/// @dev Thrown when a user tries to revote.
error __DECENTRALIZEDPOLL_USER_HAS_VOTED();

/// @dev Thrown when user tries to vote on an inactive poll.
error __DECENTRALIZEDPOLL_INACTIVE_POLL();

/// @dev Thrown when user inputs wrong option index. 
error __DECENTRALIZEDPOLL_INVALID_OPTION_INDEX();

/// @dev Thrown when owner tries to get poll of a creator with empty poll.
error __DECENTRALIZEDPOLL_NO_EXISTING_POLL();

contract DecentralizedPoll {

    /// @notice Contract deployer's address.
    address immutable i_owner;

    /// @notice Used to activate and deactivate the contract.
    bool private active;

    /// @notice Records total poll created.
    uint256 public pollCount; 

    /// @notice Records all poll's id.
    uint256[] private pollIds;

    /// @notice Ensures poll status is either: created, active or ended.
    enum PollStatus {Created, Active, Ended}

    /// @notice Groups poll data.
    struct PollData {
        uint256 pollId;
        string title;
        string description;
        string[] options;
        uint256[] votes;
        PollStatus status;
        uint256 createdAt;
    }

    /// @dev Maps poll id => poll data.
    mapping(uint256 => PollData) public polls;

    /// @dev Maps poll id =>  creator address.
    mapping(uint256 => address) private pollCreator;

    /// @dev Maps poll id => voter => true/false.
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    /// @dev Maps creator address => poll data array.
    mapping(address => PollData[]) private creatorPolls;

    /// @notice Emits PollCreated.
    /// @param creatorAddress Creator's address.
    /// @param pollTitle Poll's title.
    /// @param pollDescription Poll's description.
    event PollCreated(address indexed creatorAddress, string pollTitle, string pollDescription);

    /// @notice Emits UpdatedPoll.
    /// @param userAddress The User's address.
    /// @param pollId The Poll's Id.
    /// @param newPollTitle Poll's new title.
    /// @param newPollDescription Poll's new description.
    event UpdatedPoll(address indexed userAddress, uint256 pollId, string newPollTitle, string newPollDescription);

    /// @notice Emits PollDeleted.
    /// @param userAddress The User's address.
    /// @param pollId The Poll's Id.
    event PollDeleted(address indexed userAddress, uint256 pollId);

    /// @notice Emits Voted.
    /// @param voterAddress The voter's address.
    /// @param pollId The poll id.
    /// @param optionIndex The option index voted.
    event Voted(address indexed voterAddress, uint256 indexed pollId, uint256 indexed optionIndex);
   
    /// @notice Emits PollActivated.
    /// @param pollId The poll id.
    event PollActivated(uint256 indexed pollId);

     /// @notice Emits PollDeactivated.
    /// @param pollId The poll id.
    event PollDeactivated(uint256 indexed pollId);
    
    /// @notice Emits ContractActivated.
    event ContractActivated();

    /// @notice Emits ContractDeactivated.
    event ContractDeactivated();

    /// @notice Sets contract deployer as owner.
    constructor() {
        i_owner = msg.sender;
    }

    /// @dev Restricts access to only the contract deployer.
    modifier onlyOwner() {
        if(msg.sender != i_owner) revert __DECENTRALIZEDPOLL_UNAUTHORIZED_ACCESS();
        _; 
    }

    /// @dev Activates and deactivates the contract.
    modifier isActive() {
    if(!active) revert __DECENTRALIZEDPOLL_INACTIVE_CONTRACT();
        _;
    }

    /// @dev Verifies if poll id exist.
    modifier validPoll(uint256 _pollId) {
        if(polls[_pollId].pollId != _pollId)
        revert __DECENTRALIZEDPOLL_NOT_AN_EXISTING_POLL();
        _;
    }

    /// @notice Users can create poll
    /// @param _title Poll's title
    /// @param _description Poll's description
    /// @param _options Poll's option
    function createPoll(string memory _title, string memory _description, string[] memory _options) public isActive {
        if(_options.length < 2) revert __DECENTRALIZEDPOLL_MINIMUM_OF_TWO_OPTIONS_REQUIRED();
        
        pollCount++;
        uint256 _pollId = pollCount;
        
        PollData storage data = polls[_pollId];
        
         data.pollId = _pollId;
         data.title = _title;
         data.description = _description;
         data.options = _options;
         data.votes = new uint256[](_options.length);
         data.status = PollStatus.Created;
         data.createdAt = block.timestamp;

         creatorPolls[msg.sender].push(data);

         pollCreator[_pollId] = msg.sender; // Track poll creators.

         pollIds.push(_pollId); // This line allows tracking of all polls.
         
        emit PollCreated(msg.sender, _title, _description);
    }
    
    /// @notice Users can update their poll
    /// @param _pollId The poll id.
    /// @param _newTitle Poll's new title.
    /// @param _newDescription Poll's new description.
    /// @param _newOptions  Poll's new option.
    function updatePoll(uint256 _pollId, string memory _newTitle, string memory _newDescription, string[] memory _newOptions) public isActive {
        if(_newOptions.length < 2) revert __DECENTRALIZEDPOLL_MINIMUM_OF_TWO_OPTIONS_REQUIRED();
        if(pollCreator[_pollId] != msg.sender) revert __DECENTRALIZEDPOLL_ACCESS_DENIED();
        PollData storage data = polls[_pollId];

        data.pollId = _pollId;
        data.title = _newTitle;
        data.description = _newDescription;
        data.options = _newOptions;
        data.votes = new uint256[](_newOptions.length);
        data.status = PollStatus.Created;
        data.createdAt = block.timestamp;

        emit UpdatedPoll(msg.sender, _pollId, _newTitle, _newDescription);
    }

    /// @notice Allows users to delete their poll.
    /// @param _pollId The poll id.
    function deletePoll(uint256 _pollId) public isActive {
       if(pollCreator[_pollId] != msg.sender) revert __DECENTRALIZEDPOLL_ACCESS_DENIED();
        delete polls[_pollId];

        unchecked {
            pollCount--;
        }
        // Deletes poll from the pollIds array.
        for (uint i = 0; i < pollIds.length; i++) {
            if(pollIds[i] == _pollId) {
                pollIds[i] = pollIds[pollIds.length - 1]; 
                break;
            }
        } pollIds.pop();

        emit PollDeleted(msg.sender, _pollId);
    }

    /// @notice Allows users to vote.
    /// @param _pollId The poll id.
    /// @param _optionIndex The option index.
    function vote(uint256 _pollId, uint256 _optionIndex) public isActive validPoll(_pollId){
        PollData storage data = polls[_pollId];
        if(data.status != PollStatus.Active) revert __DECENTRALIZEDPOLL_INACTIVE_POLL();
        if(hasVoted[_pollId][msg.sender] == true) revert __DECENTRALIZEDPOLL_USER_HAS_VOTED();
        if(_optionIndex >= data.options.length) revert __DECENTRALIZEDPOLL_INVALID_OPTION_INDEX();

        data.votes[_optionIndex]++;
        hasVoted[_pollId][msg.sender] = true;

        emit Voted(msg.sender, _pollId, _optionIndex);
    }

     /// @notice Returns id options.
    /// @return The poll id options.
    function getPollOptions(uint256 _pollId) public validPoll(_pollId) view returns(string[] memory) {
        return polls[_pollId].options;
    }

    /// @notice Returns caller's polls.
    ///@return caller's polls.
    function getMyPolls() public view returns(PollData[] memory) {
        return creatorPolls[msg.sender];
    }

    /// @notice Returns all polls.
    /// @return All existing polls.
    function getAllPolls() public view returns(uint256[] memory) {
        return pollIds;
    }

    /// @notice Returns poll results.
    /// @return The result for poll id.
    function getPollResults(uint256 _pollId) public validPoll(_pollId) view returns(uint256[] memory) {
        return polls[_pollId].votes;
    }

    /// @notice Returns Creator's address.
    /// @return The address of the poll creator.
    function getPollCreator(uint256 _pollId) public view returns(address) {
        return pollCreator[_pollId];
    }

    /// @notice Returns owner's address. 
    /// @return owner's address.
    function getOwner() public view returns(address) {
        return i_owner;
    }

     /// @notice Poll creator can activate poll.
    /// @param _pollId Poll's id.
    function activatePoll(uint256 _pollId) external isActive validPoll(_pollId) {
        if(pollCreator[_pollId] != msg.sender) revert __DECENTRALIZEDPOLL_ACCESS_DENIED();
        
        PollData storage existingPoll = polls[_pollId];
        if(existingPoll.status == PollStatus.Active) revert __DECENTRALIZEDPOLL_POLL_IS_ACTIVE();
        
        existingPoll.status = PollStatus.Active;

        emit PollActivated(_pollId);
    }

    /// @notice Poll creator can deactivate poll. 
    /// @param _pollId Poll's id.
    function deactivatePoll(uint256 _pollId) external isActive validPoll(_pollId) {
        if(pollCreator[_pollId] != msg.sender) revert __DECENTRALIZEDPOLL_ACCESS_DENIED();

        PollData storage existingPoll = polls[_pollId];
        if(existingPoll.status == PollStatus.Ended) revert __DECENTRALIZEDPOLL_POLL_ALREADY_ENDED();

        existingPoll.status = PollStatus.Ended;

        emit PollDeactivated(_pollId);
    }

    /// @notice Allows owner to delete user's poll.
    /// @param _creatorAddress The creator's Address.
    /// @param _pollId The poll id.
    function deletePoll(address _creatorAddress, uint256 _pollId) external onlyOwner isActive {
       if(pollCreator[_pollId] != _creatorAddress) revert __DECENTRALIZEDPOLL_NOT_USER_EXISTING_POLL();
        delete polls[_pollId];

        unchecked {
            pollCount--;
        }
        // Deletes poll from the pollIds array.
        for (uint i = 0; i < pollIds.length; i++) {
            if(pollIds[i] == _pollId) {
                pollIds[i] = pollIds[pollIds.length - 1]; 
                break;
            }
        } pollIds.pop();

        emit PollDeleted(_creatorAddress, _pollId);
    }

    function getCreatorPolls(address _creatorAddress) external onlyOwner isActive view returns(PollData[] memory){
        return creatorPolls[_creatorAddress];
    }

    /// @notice Activates contract.
    /// @dev Only owner can activate contract.
    function activateContract() external onlyOwner {
        active = true;

        emit ContractActivated();
    }

    /// @notice Deactivate contract.
    /// @dev Only owner can deactivate contract.
    function deactivateContract() external onlyOwner {
        active = false;

        emit ContractDeactivated();
    }
}