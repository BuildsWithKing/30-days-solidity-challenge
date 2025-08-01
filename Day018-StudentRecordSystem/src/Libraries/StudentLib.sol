// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/// @title StudentLib (StudentLib Library for StudentRecordSystem). 
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 29th of July, 2025. 

/// @dev Thrown when id doesn't match any student's id. 
error __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST();

/// @dev Thrown when student's address exist. 
error __STUDENTRECORDSYSTEM_EXISTING_STUDENT_ADDRESS();

/// @notice Imports StudentTypes Library.
import {StudentTypes} from "./StudentTypes.sol";

library StudentLib {

    /// @notice Groups Student info. 
    struct Student {
        string firstName;
        string middleName;
        string lastName;
        uint256 dateOfBirth;
        uint8 studentGender;
        uint8 studentStatus; 
        string department;
        string course;
        string location;
        uint256 mobileNumber;
        address studentAddress;
        string email;
        uint256 timestamp;
    }

    /// @notice Groups student records. 
    struct StudentRecord {
        uint256[] courseScores;
        StudentTypes.Grade[] courseGrades;
        uint256[] performanceScores;
        StudentTypes.Grade[] performanceGrades;
        uint256[] attendanceScores;
        StudentTypes.Grade[] attendanceGrades;
        uint256 timestamp;
    }

    /// @notice Groups mapping for student data, records and validation. 
    struct StudentStorage {

    /// @dev Maps student ID to their personal data. 
    mapping(uint256 => Student) students; 

    /// @dev Maps student ID to their academic records. 
    mapping(uint256 => StudentRecord) studentRecords;

    /// @dev Maps address to student records (alternative access). 
    mapping(address => StudentRecord) studentRecordsByAddress;

    /// @dev Maps address to student personal data. 
    mapping(address => Student) studentsByAddress;

    /// @dev Tracks existence of a student by ID. 
    mapping(uint256 => bool) existingStudent;

    /// @dev Tracks existence of a student by address. 
    mapping(address => bool) existingAddress;  

    }

    /// @notice Returns student's data.
    /// @param _studentId Student's Id.  
    /// @return student's stored data.
    function getStudent(StudentStorage storage student, uint256 _studentId) internal view returns (Student memory) {
        if(!student.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST();
        return student.students[_studentId];
    }

    /// @notice Returns bool (true / false).
    /// @param _studentId Student's Id.
    /// @return true if student exists, false if not. 
    function exist(StudentStorage storage student, uint256 _studentId) internal view returns (bool) {
        return student.existingStudent[_studentId];
    }

    // @notice Returns bool (true / false).
    /// @param _studentAddress Student's address.
    /// @return true if student exists, false if not. 
    function existAddress(StudentStorage storage student, address _studentAddress) internal view returns(bool) {
        return student.existingAddress[_studentAddress];
    }
}