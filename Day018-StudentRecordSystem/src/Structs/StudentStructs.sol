// SPDX-License-Identifier: MIT

/// @title StudentStruct (StudentStruct contract for StudentRecordSystem). 
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 30th of July, 2025. 

pragma solidity ^0.8.18;

/// @notice Import StudentTypes library. 
import {StudentTypes} from "../Libraries/StudentTypes.sol";

library StudentStruct {

    /// @notice Groups student's info. 
    struct StudentInput {
        string firstName;
        string middleName;
        string lastName;
        uint256 dateOfBirth;
        StudentTypes.StudentGender studentGender;
        StudentTypes.StudentStatus studentStatus; 
        string department;
        string course;
        string location;
        uint256 mobileNumber;
        address studentAddress;
        string email;
        uint256 timestamp;
    }
    
    /// @notice Groups student's record. 
    struct StudentRecord {
        uint256[] courseScores;
        StudentTypes.Grade[] courseGrades;
        uint256[] performanceScores;
        StudentTypes.Grade[] performanceGrades;
        uint256[] attendanceScores;
        StudentTypes.Grade[] attendanceGrades;
    }

    /// @notice Groups student updated input. 
    struct UpdateStudentInput {
        string newFirstName;
        string newMiddleName;
        string newLastName;
        uint256 newDateOfBirth;
        string newDepartment;
        string newCourse;
        string newLocation;
        uint256 newMobileNumber;
        address newStudentAddress;
        string newEmail;
    } 
}