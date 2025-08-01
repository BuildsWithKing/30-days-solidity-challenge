// SPDX-License-Identifier: MIT

/// @title Utilis (Utilis contract for StudentRecordSystem). 
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 28th of July, 2025. 

pragma solidity ^0.8.18;

import {AdminManager} from "./AdminManager.sol";

/// @dev Thrown when student tries to perform authority's operation. 
error __STUDENTRECORDSYSTEM_UNAUTHORIZED_ACCESS(address owner_Or_StaffAddress);

/// @dev Thrown when contract deployer(owner) tries to assign zero address as staff address. 
error __STUDENTRECORDSYSTEM_STAFFADDRESS_CANT_BE_ZERO_ADDRESS();

/// @dev Thrown when the contract is not active. 
error __STUDENTRECORDSYSTEM_INACTIVE_CONTRACT();

/// @dev Thrown when ETH transfer fails. 
error __STUDENTRECORDSYSTEM_ETH_TRANSFER_FAILED();

/// @dev Thrown when owner tries to transfer ownership or ETH to the zero Address. 
error __STUDENTRECORDSYSTEM_INVALID_ADDRESS();

contract Utils is AdminManager { // Inheriting AdminManger contract. 

    /// @notice Defines the contract state. 
    enum ContractState {
        NotActive,
        Active
    }

    /// @notice Contract deployer's address. 
   address internal owner;

    /// @notice Assigns variable `state` to enum. 
    ContractState private state;

     /// @notice Emits OwnershipRenounced
    /// @param oldManagerAddress owner's address
    /// @param ownerAddress Zero Address.  
    event ManagementRenounced(address indexed oldManagerAddress, address indexed ownerAddress);
    
    /// @notice Emits ContractActivated.
    /// @param ownerAddress Owner's Address. 
    event ContractActivated(address indexed ownerAddress);

    /// @notice Emits ContractDeactivated.
    /// @param ownerAddress Owner's Address. 
    event ContractDeactivated(address indexed ownerAddress);

    /// @notice Emits EthWithdrawn.
    /// @param ownerAddress Owner's Address.
    /// @param receiverAddress The receiver's address.
    /// @param ethAmount Amount of ETH withdrawn. 
    event EthWithdrawn(address indexed ownerAddress, address indexed receiverAddress, uint256 indexed ethAmount);

    /// @notice Emits OwnershipRenounced
    /// @param ownerAddress owner's address
    /// @param zeroAddress Zero Address.  
    event OwnershipRenounced(address indexed ownerAddress, address indexed zeroAddress);

    /// @notice Emits OwnershipTransferred.
    /// @param ownerAddress Owner's Address
    /// @param newOwnerAddress New owner's address. 
    event OwnershipTransferred(address indexed ownerAddress, address indexed newOwnerAddress);

    /// @notice Emits EthReceived.
    /// @param senderAddress Sender's Address.
    /// @param ethAmount Amount of ETH received. 
    event EthReceived(address indexed senderAddress, uint256 indexed ethAmount);

     /// @dev Restricts access to only contract deployer. 
      modifier onlyOwner() {
        if(msg.sender != owner) revert __STUDENTRECORDSYSTEM_UNAUTHORIZED_ACCESS(owner);
        _;
    }

    /// @dev Enum used to set contract state to not active once deployed. 
    modifier isActive() {
    if(state == ContractState.NotActive) revert __STUDENTRECORDSYSTEM_INACTIVE_CONTRACT();
        _;
    }

    /// @dev Restricts access to only student registrar. 
    modifier isRegistrar() {
        if(msg.sender != studentRegistrar) 
        revert __STUDENTRECORDSYSTEM_UNAUTHORIZED_ACCESS(studentRegistrar);
        _;
    }
    /// @dev Restricts access to only academic manager.
    modifier isAcademicManager() {
        if(msg.sender != academicRecordManager)
        revert __STUDENTRECORDSYSTEM_UNAUTHORIZED_ACCESS(academicRecordManager);
        _;
    }

    /// @dev Restricts access to only grades manager. 
    modifier isGradesManager() {
        if(msg.sender != gradesManager)
        revert __STUDENTRECORDSYSTEM_UNAUTHORIZED_ACCESS(gradesManager);
        _;
    }

    /// @notice Returns ContractState.
    /// @return 0-> NotActive, 1 -> Active
    function isContractActive() public view returns(string memory) {
        if(state == ContractState.NotActive) return "NotActive";
        if(state == ContractState.Active) return "Active";
        return "unknown state";
    }

    /// @notice Returns owner's address.
    /// @return contract deployer's address. 
    function getOwner() public view returns(address) {
        return owner;
    }

    /// @notice Assigns admin manager. 
    /// @param _staffAddress Staff's address. 
    function assignAdminManager(address _staffAddress) external onlyOwner isActive {
        if(_staffAddress == address(0)) revert __STUDENTRECORDSYSTEM_STAFFADDRESS_CANT_BE_ZERO_ADDRESS();
        adminManager = _staffAddress; 

        emit AdminManagerAssigned(_staffAddress);
    }

    /// @notice Only staff members can renounce management.
    function renounceManagement() external onlyStaff isActive {
       if(msg.sender == adminManager){
            adminManager = owner;
       }
       if(msg.sender == academicRecordManager) {
         academicRecordManager = owner;
       }
       if(msg.sender == studentRegistrar) {
       studentRegistrar = owner;
       }
       if(msg.sender == gradesManager) {
        gradesManager = owner;
       }

        emit ManagementRenounced(msg.sender, owner);
    }

     /// @notice Only contract deployer can activate contract 
    function activateContract() external onlyOwner {
      state = ContractState.Active;

      emit ContractActivated(msg.sender);
    }

    /// @notice Only contract deployer can deactivate contract 
    function deactivateContract() external onlyOwner {
         state = ContractState.NotActive;

         emit ContractDeactivated(msg.sender);
    }
    /// @notice Only contract deployer (owner) can withdraw ETH.
    /// @param _receiverAddress The receiver's address.
    /// @param _amount Amount of ETH withdrawn.
    function withdrawETH(address _receiverAddress, uint256 _amount) external onlyOwner {
        if(_receiverAddress == address(0)) revert __STUDENTRECORDSYSTEM_INVALID_ADDRESS();
        (bool success,) = payable(_receiverAddress).call{value: _amount}("");
        if(!success) revert __STUDENTRECORDSYSTEM_ETH_TRANSFER_FAILED();

        emit EthWithdrawn(owner, _receiverAddress, _amount);
    }

    /// @notice Only contract deployer can transfer ownership.
    function transferOwnership(address _newOwnerAddress) external onlyOwner {
        if(_newOwnerAddress == address(0)) revert __STUDENTRECORDSYSTEM_INVALID_ADDRESS();
        emit OwnershipTransferred(owner, _newOwnerAddress);
        
        owner = _newOwnerAddress;
    }

    /// @notice Only contract deployer can renouce ownership.
    function renounceOwnership() external onlyOwner isActive {
        emit OwnershipRenounced(owner, address(0));
       
        owner = address(0);
    }

    /// @notice Handles ETH transfers with no calldata. 
    receive() external payable {
    
        emit EthReceived(msg.sender, msg.value);
    }

    /// @notice Handles ETH with calldata. 
    fallback() external payable { 

        emit EthReceived(msg.sender, msg.value);
    } 
}