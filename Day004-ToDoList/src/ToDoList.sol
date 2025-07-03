// SPDX-License-Identifier: MIT

/* This basic smart contract allows users add, view, update status (completed Notcompleted), and delete task. 
Owner can view all users task 
*/
error EMPTYTASK();

pragma solidity ^0.8.18;

contract ToDoList {
    address private owner; // Contract deployer's address

    // Struct contains Users task (title, status, timestamp)
    struct Task {
        string title;
        bool completed;
        uint256 timestamp;
    }

    // Links users address to their task
    mapping(address => Task[]) private userTasks;

    // Indicates owner as the contract deployer
    constructor() {
        owner = msg.sender;
    }

    // Restricts access, only contract deployer is permitted
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized Access");
        _;
    }

    // Allows users store a new task
    function addTask(string memory _title) public {
        if (bytes(_title).length == 0) revert EMPTYTASK();
        userTasks[msg.sender].push(Task(_title, false, block.timestamp));
    }

    //Returns user's task
    function getMyTask() public view returns (Task[] memory) {
        return userTasks[msg.sender];
    }

    // Marks user's task as completed(true)
    function markAsDone(uint256 _indexNo) public {
        userTasks[msg.sender][_indexNo].completed = true;
    }

    // Updates user's Task, resets the task to it's default status (false)
    function updateTask(uint256 _indexNo, string memory _newTitle) public {
        userTasks[msg.sender][_indexNo] = (Task(_newTitle, false, block.timestamp));
    }

    // Resets user's task at provided index number to zero (results to ghost task present)
    function deleteTask(uint256 _indexNo) public {
        delete userTasks[msg.sender][_indexNo];
    }

    // Deletes all user's task
    function deleteAllTasks() public {
        delete userTasks[msg.sender];
    }

    //Returns task at provided index number
    function getTaskAtIndex(uint256 _indexNo) public view returns (Task memory) {
        return userTasks[msg.sender][_indexNo];
    }

    // Returns user's Task length
    function getTaskCount() public view returns (uint256 taskCount) {
        return userTasks[msg.sender].length;
    }

    // Returns the contract deployers address
    function getOwner() public view returns (address _owner) {
        return owner;
    }
}
