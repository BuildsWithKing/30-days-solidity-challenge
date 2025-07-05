// SPDX-License-Identifier: MIT

// Title: SimpleBank 
// Author: Michealking (@BuildsWithKing)
// Date Created: 4th of July, 2025 

/* This basic smart contract allows users deposit ETH, withdraw ETH, view balance, and track the total bank balance
    allows owner to view all users balance
*/
pragma solidity ^0.8.18;

error __SIMPLEBANK_UNAUTHORIZEDACCESS(); //custom Error: Reverts message "__SIMPLEBANK_UNAUTHORIZEDACCESS"
error __SIMPLEBANK_ETHAMOUNTISTOOLOW(); // custom Error: Reverts message "__SIMPLEBANK_ETHAMOUNTISTOOLOW"
error __SIMPLEBANK_INSUFFICIENTBALANCE(); // custom Error: Reverts message "__SIMPLEBANK_INSUFFICIENTBALANCE"

contract SimpleBank {

    address private owner; // Assigning owner to address data type

    mapping(address => uint256) private usersBalance; // Links users address to amount funded

    event ethDeposited(address indexed depositor, uint256 amount); // Logs ethDeposited on the blockchain
    event ethWithdrawn(address indexed withdrawer,uint256 amount); // Logs ethWithdrawn on the blockchain

    // Sets contract deployer as owner
    constructor() {
        owner = msg.sender;
    }

    // Restrict access to only owner (contract deployer)
    modifier onlyOwner() {
        if(owner != msg.sender) 
        revert __SIMPLEBANK_UNAUTHORIZEDACCESS();
        _;
    }

    // Accept users ETH deposit
    function depositETH() public payable {
        if(msg.value <= 0) revert __SIMPLEBANK_ETHAMOUNTISTOOLOW();
        usersBalance[msg.sender] += msg.value; 
        emit ethDeposited(msg.sender, msg.value);
    }

    // Allows users withdraw ETH deposit
    function withdrawETH(uint256 _ethAmount) public {
        if (usersBalance[msg.sender] < _ethAmount) revert __SIMPLEBANK_INSUFFICIENTBALANCE();
        usersBalance[msg.sender] -=_ethAmount; 
        payable(msg.sender).transfer(_ethAmount);  //Note: .transfer may fail on contracts. [check out `DonationVault.sol` for best withdrawal method{.call()}].
        emit ethWithdrawn(msg.sender, _ethAmount);
    }

    // Returns user bank balance 
    function getMyBalance() public view returns (uint256) {
        return usersBalance[msg.sender];
    }

    // Returns the bank's balance
    function getBankBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Returns user's balance (only Owner can call)
    function getUserBalance(address _userAddress) public view onlyOwner returns (uint256) {
        return usersBalance[_userAddress];
    }

    //  Returns contract deployer's address
    function getOwner() public view returns (address) {
        return owner;
    }
}