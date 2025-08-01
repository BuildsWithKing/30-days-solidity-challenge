// SPDX-License-Identifier: MIT

/// @title AdminManager (AdminManager contract for StudentRecordSystem).
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 28th of July, 2025. 

pragma solidity ^0.8.18;

/// @dev Thrown when staffs or students tries to perform only admin manager operations. 
error __STUDENTRECORDSYSTEM_UNAUTHORIZED_ACCESS();

/// @dev Thrown when a non-staff member tries to perform staff's operation. 
error __STUDENTRECORDSYSTEM_NOT_A_STAFF_MEMBER();

/// @dev Thrown when admin manager tries to assign zero address as staff address. 
error __STUDENTRECORDSYSTEM_STAFFADDRESS_CANT_BE_ZERO_ADDRESS();

contract AdminManager {

    /// @notice Records admin manager's address. 
    address internal adminManager;

    /// @notice Records academic record manager's address. 
    address internal academicRecordManager;

    /// @notice Records grades Manager's address. 
    address internal gradesManager;

    /// @notice Records Student's registrar address.
    address internal studentRegistrar; 

    /// @notice Emits AdminManagerAssigned.
    /// @param staffAddress Staff's address. 
    event AdminManagerAssigned(address indexed staffAddress);

    /// @notice Emits AcademicRecordManagerAssigned.
    /// @param staffAddress staff's address. 
    event AcademicRecordManagerAssigned(address indexed staffAddress);

    /// @notice Emits GradesManagerAssigned.
    /// @param staffAddress staff's address.
    event GradesManagerAssigned(address indexed staffAddress);

    /// @notice Emits StudentRegistrarAssigned.
    /// @param staffAddress staff's address.
    event StudentRegistrarAssigned(address indexed staffAddress);

   /// @notice Sets contract deployer as admin manager. 
   constructor() {
     adminManager = msg.sender;
    }

    /// @dev Restricts access to only admin manager. 
    modifier isAdminManager() {
        if(msg.sender != adminManager)
        revert __STUDENTRECORDSYSTEM_UNAUTHORIZED_ACCESS();
        _;
    }

    /// @dev Restricts access to only staff members. 
    modifier onlyStaff() {
        if(
            msg.sender != studentRegistrar &&
            msg.sender != academicRecordManager &&
            msg.sender != gradesManager
        ) revert __STUDENTRECORDSYSTEM_NOT_A_STAFF_MEMBER();
        _;
    }

    /// @notice Assigns academic record manager.
    /// @param _staffAddress Staff's address.  
    function assignAcademicRecordManager(address _staffAddress) external isAdminManager {
        if(_staffAddress == address(0)) revert __STUDENTRECORDSYSTEM_STAFFADDRESS_CANT_BE_ZERO_ADDRESS();
        academicRecordManager = _staffAddress; 

        emit AcademicRecordManagerAssigned(_staffAddress);
    }
    
    /// @notice Assigns Grades manager.
    /// @param _staffAddress Staff's address.  
    function assignGradesManager(address _staffAddress) external isAdminManager {
        if(_staffAddress == address(0)) revert __STUDENTRECORDSYSTEM_STAFFADDRESS_CANT_BE_ZERO_ADDRESS();
        gradesManager = _staffAddress;

        emit GradesManagerAssigned(_staffAddress);
    }
    
    /// @notice Assigns student registrar.
    /// @param _staffAddress Staff's address. 
    function assignStudentRegistrar(address _staffAddress) external isAdminManager {
        if(_staffAddress == address(0)) revert __STUDENTRECORDSYSTEM_STAFFADDRESS_CANT_BE_ZERO_ADDRESS();
        studentRegistrar = _staffAddress;

        emit StudentRegistrarAssigned(_staffAddress);
    }

    /// @notice Returns registrar's address.
    /// @return Student registrar's address. 
    function getRegistrar() external view returns(address) {
        return studentRegistrar;
    }

     /// @notice Returns grades Manager's address.
    /// @return Grades Manager's address.
     function getGradesManager() external view returns(address) {
        return gradesManager;
    }

     /// @notice Returns academic record manager's address.
    /// @return Academic record manager's address.
    function getAcademicRecordManager() external view returns(address) {
        return academicRecordManager;
    }

     /// @notice Returns admin manager's address.
    /// @return Admin manager's address.
    function getAdminManager() external view returns(address) {
        return adminManager;
    }

    /// @notice Returns all staff's address. 
    /// @return _adminManager Admin manager's address.
    /// @return _academicManager Academic manager's address.
    /// @return _gradesManager Grades manager's address. 
    /// @return _studentRegistrar Student's registrar address. 
    function getAllStaff() external view returns(address _adminManager, address _academicManager,
    address _gradesManager, address _studentRegistrar) {
        return(adminManager, academicRecordManager, gradesManager, studentRegistrar);
    }
}