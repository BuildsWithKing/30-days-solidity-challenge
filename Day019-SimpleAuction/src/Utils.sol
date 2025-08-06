// SPDX-License-Identifier: MIT

/// @title Utils (Utility file for SimpleAuction contract). 
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// @date Created: 2nd of August, 2025. 

/** @notice Stores file's utilities including modifier,
    contract state, receive and fallback. 
*/

pragma solidity ^0.8.18; 

import {AuctionTypes} from "./Libraries/AuctionTypes.sol";

/// @dev Thrown when auctioneer (contract deployer) inputs length 
error __SIMPLEAUCTION_INVALID_TIMESTAMP();

/// @dev Thrown when users tries to perform only contract deployer's operation. 
error __SIMPLEAUCTION_UNAUTHORIZED_ACCESS(address auctioneer);

/// @dev Thrown when auctioneer tries to transfer ownership to the zero Address. 
error __SIMPLEAUCTION_INVALID_ADDRESS(address zeroAddress);

/// @dev Thrown when bidders tries to perform operation on contract when not active. 
error __SIMPLEAUCTION_CONTRACT_IS_NOT_ACTIVE();

/// @dev Thrown when Eth transfer by contract deployer fails. 
error __SIMPLEAUCTION_ETH_TRANSFER_FAILED();

contract Utils {

    /// @notice Used AuctionState from AuctionTypes.
    using AuctionTypes for AuctionTypes.AuctionState;

    /// @notice Defines contract state. 
    enum ContractState {
        NotActive,
        Active
    }

    /// @notice contract deployer's address.  
    address internal auctioneer;

    /// @notice Contract state.
    ContractState private state;

    /// @notice Auction states. 
    AuctionTypes.AuctionState internal auctionState;

    /// @notice Emits ContractActivated.  
    event ContractActivated();

    /// @notice Emits InactiveContract. 
    event InActiveContract();

    /// @notice Emit ContractOwnershipTransferred. 
    /// @param auctioneerAddress The curent auctioneer address.
    /// @param newAuctioneerAddress New auctioneer's address. 
    event  ContractOwnershipTransferred(address indexed auctioneerAddress, address indexed newAuctioneerAddress);

    /// @notice Emits EthSent
    /// @param auctioneerAddress Contract deployer's (auctioneer) address.
    /// @param receiverAddress The receiver's address. 
    /// @param ethAmount The amount of ETH sent. 
    event EthSent(address indexed auctioneerAddress, address indexed receiverAddress, uint256 indexed ethAmount);
    
    /// @notice Emits EthReceived
    /// @param senderAddress The Sender address.
    /// @param ethAmount Amount of ETH received. 
    event EthReceived(address indexed senderAddress, uint256 indexed ethAmount);

    /// @dev Restricts access to only contract deployer (auctioneer). 
    modifier onlyAuctioneer() {
        // Revert if caller is not auctioneer. 
        if(msg.sender != auctioneer)
        revert __SIMPLEAUCTION_UNAUTHORIZED_ACCESS(auctioneer);
        _;
    }

    /// @dev Restricts access when contract is not active. 
    modifier isActive() {
        // Revert if contract state is not active. 
        if(state != ContractState.Active)
        revert __SIMPLEAUCTION_CONTRACT_IS_NOT_ACTIVE();
        _;
    }

    /// @notice Returns Contract current state in string.
    /// @return Active or Not Active. 
    function getContractState(
    ) external view returns(string memory) {
        if(state == ContractState.Active) return "Active";
        if(state == ContractState.NotActive) return "Not Active";
        revert("Invalid contract state");
    }

    /// @notice Returns Contract's balance.
    /// @return contract balance. 
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Returns Contract deployer's address.
    /// @return Autioneer's address.
    function getAuctioneer() external view returns(address) {
        return  auctioneer;
    }

    /// @notice Only contract deployer (auctioneer) can transfer ownership. 
    function transferOwnership(
        address _newAuctioneerAddress
    ) external onlyAuctioneer isActive {
        if(_newAuctioneerAddress == address(0)) revert __SIMPLEAUCTION_INVALID_ADDRESS(address(0));
        emit ContractOwnershipTransferred(auctioneer, _newAuctioneerAddress); 
        
        auctioneer = _newAuctioneerAddress; 
    }

    /// @notice Only auctioneer can activate contract. 
    function activateContract() external onlyAuctioneer {
        state = ContractState.Active;

        emit ContractActivated();
    }

    /// @notice Only auctioneer can deactivate contract. 
    function deactivateContract() external onlyAuctioneer {
        state = ContractState.NotActive;

        emit InActiveContract();
    }

    /// @notice Only auctioneer can refund ETH received from bidder who didn't click on bid.  
    /// @param _receiverAddress The ETH receiver address. 
    /// @param _ethAmount Amount of ETH to be credited.
    function withdrawETH(
        address _receiverAddress, 
        uint256 _ethAmount
    ) external onlyAuctioneer isActive {
        
        // Fund receiver Address. 
        (bool success,) = payable(_receiverAddress).call{value: _ethAmount}("");
        if(!success) revert __SIMPLEAUCTION_ETH_TRANSFER_FAILED();

        emit EthSent(auctioneer, _receiverAddress, _ethAmount);
    }

    /// @notice Handles ETH deposit without calldata. 
    receive() external payable { 
        emit EthReceived(msg.sender, msg.value);
    }

    /// @notice Handles ETH deposit with calldata. 
    fallback() external payable {
        emit EthReceived(msg.sender, msg.value);
    }
}