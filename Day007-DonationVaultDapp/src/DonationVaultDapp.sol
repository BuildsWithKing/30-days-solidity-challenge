// SPDX-License-Identifier: MIT

// Title: DonationVaultDapp
// Author: Michealking (@BuildsWithKing)
// Date Created: 4th of July, 2025

/* This contract introduces payable functions, handling ETH, balance, and simple accounting logic. 
    A perfect begineer-to-intermediate transition project.
 
    DonationVault is a smart contract where users can send ETH donations, the owner can withdraw and track total funds. 
    Users can view their own contribution history.
 */

 pragma solidity ^0.8.18;

error __DONATIONVAULTDAPP_INSUFFICIENTBALANCE(); // Custom error: Reverts __DONATIONVAULTDAPP_INSUFFICIENTBALANCE
error __DONATIONVAULT_UNAUTHORIZEDACCESS(); // Custom error: __DONATIONVAULT_UNAUTHORIZEDACCESS
error __DONATIONVAULT_ETHAMOUNTISTOOLOW(); // Custom error: __DONATIONVAULT_ETHAMOUNTISTOOLOW
 
 contract DonationVaultDapp {

    address private owner; // Assigning variable owner (contract deployer) to an address

    mapping(address => uint256) private usersDonation; // Links user's deposit to their address

    event newDeposit(uint256 indexed _ethAmount, address _userAddress); // Logs information on the blockchain
    event ownerWithdrewAll(uint256 indexed ethAmount, address ownerAddress); // Logs information on the blockchain

    // Sets owner as the contract deployer
    constructor () {
        owner = msg.sender;
    }

    // Restricts access, permits only owner(contract deployer) 
    modifier onlyOwner () {
        if(msg.sender != owner)
        revert __DONATIONVAULT_UNAUTHORIZEDACCESS();
        _;
    }
    
    // Accepts ETH deposit
    function depositETH() payable public {
        if(msg.value <= 0) revert __DONATIONVAULT_ETHAMOUNTISTOOLOW();
        usersDonation[msg.sender] += msg.value;
        emit newDeposit(msg.value, msg.sender);
    }

    // Owner can withdraw all ETH
    function withdrawAll() public onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert __DONATIONVAULTDAPP_INSUFFICIENTBALANCE();
        (bool success, ) = payable(owner).call{value:balance}(""); // Note: Best withdrawal practice [.call{}]
        require(success, "Withdraw failed");
        emit ownerWithdrewAll(balance, owner);
    }

    // Returns contract's Eth Balance
    function getTotalDeposit() public view onlyOwner returns(uint256) {
       return usersDonation[address(this)];
    }

    // Returns user's deposit history
    function getMyDepositHistory() public view returns (uint256) {
        return usersDonation[msg.sender];
    }

    // Returns contract deployer's address
    function getOwner() public view returns (address) {
        return owner;
    }
 }