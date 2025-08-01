// SPDX-License-Identifier: MIT

/// @title StudentRegistry (StudentRegistry contract for StudentRecordSystem). 
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 28th of July, 2025. 

pragma solidity ^0.8.18;

/// @notice Imports utils file.
import {Utils} from "./Utils.sol";

/// @notice Imports StudentLib (library). 
import {StudentLib} from "./Libraries/StudentLib.sol";

/// @notice Imports StudentTypes (library). 
import {StudentTypes} from "./Libraries/StudentTypes.sol";

/// @notice Imports StudentInput and UpdateStudentInput struct. 
import {StudentStruct} from "./Structs/StudentStructs.sol";

/// @dev Thrown when id doesn't match any student's id. 
error __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(uint256 studentId);

/// @dev Thrown when student's address exist. 
error __STUDENTRECORDSYSTEM_EXISTING_STUDENT_ADDRESS(address studentAddress);

/// @dev Thrown when student address doesn't exist. 
error __STUDENTRECORDSYSTEM_STUDENT_ADDRESS_DOESNT_EXIST(address studentAddress);

contract StudentRegistry is Utils { //inheriting utils file (is).  

    /// @notice StudentStorage used, imported from StudentLib. 
    using StudentLib for StudentLib.StudentStorage;

    /// @notice Records numbers of students. 
    uint256 public studentCount; 

    /// @notice Maps all four mapping to one (from studentlib). 
   StudentLib.StudentStorage internal studentStore;

    /// @notice Emits StudentRegistered.
    /// @param firstName Student's first name.
    /// @param lastName Student's last name.
    /// @param department Student's department.
    /// @param course Student's course of study. 
    /// @param studentAddress Student's address. 
    event StudentRegistered(uint256 indexed studentId, string firstName, string lastName, string department, string course, address indexed studentAddress);
     
      /// @notice Emits StudentBioUpdated.
    /// @param studentId Student's id.
    /// @param newFirstName Student's new first name.
    /// @param newLastName Student's new last name.
    event StudentBioUpdated(uint256 indexed studentId, string newFirstName, string newLastName);

      /// @notice Emits StudentContactUpdated. 
    /// @param studentId Student's id.
    /// @param newDepartment Student's new department.
    /// @param newCourse Student's new course of study.
    /// @param studentNewAddress Student's new address.
    event StudentContactUpdated(uint256 indexed studentId, string newDepartment, string newCourse, address indexed studentNewAddress);
   
    /// @notice Emits StudentDeleted.
   /// @param studentId Student's id.
   /// @param studentAddress Student's Address. 
    event StudentDeleted (uint256 indexed studentId, address studentAddress);

    /// @notice Register's student.
    /// @param input Student's input (struct). 
    function register(StudentStruct.StudentInput memory input) internal isActive isRegistrar {
        if(studentStore.existingAddress[input.studentAddress] == true) revert __STUDENTRECORDSYSTEM_EXISTING_STUDENT_ADDRESS(input.studentAddress);

        StudentLib.Student memory newStudent;

        studentCount++;
        uint256 studentId = studentCount;
        
        newStudent.firstName = input.firstName;
        newStudent.middleName = input.middleName;
        newStudent.lastName = input.lastName;
        newStudent.dateOfBirth = input.dateOfBirth;
        newStudent.department = input.department;
        newStudent.course = input.course;
        newStudent.location = input.location;
        newStudent.mobileNumber = input.mobileNumber;
        newStudent.studentAddress = input.studentAddress;
        newStudent.email = input.email;
        newStudent.timestamp = block.timestamp;

        studentStore.existingStudent[studentId] = true; // Student id = true (student id now exist).
        studentStore.existingAddress[input.studentAddress] = true; // Student address = true (student address now exist). 

        studentStore.studentsByAddress[input.studentAddress] = newStudent; // Stores student info to their address. 
        studentStore.students[studentId] = newStudent;

        emit StudentRegistered(studentId, input.firstName, input.lastName, input.department, input.course, input.studentAddress);
    }


    /// @notice Updates student info.
    /// @param _studentId Student's Id. 
    /// @param input Student's input (struct). 
    function updateStudent(uint256 _studentId, StudentStruct.UpdateStudentInput memory input) internal isActive isRegistrar {
        if(!studentStore.existingStudent[_studentId]) revert  __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);

        StudentLib.Student storage student = studentStore.students[_studentId];

        if(input.newStudentAddress != student.studentAddress) {
            if(studentStore.existingAddress[input.newStudentAddress]) revert __STUDENTRECORDSYSTEM_EXISTING_STUDENT_ADDRESS(input.newStudentAddress);

        delete studentStore.studentsByAddress[student.studentAddress]; // Removes old address.
        studentStore.studentsByAddress[input.newStudentAddress] = student; // Assigns new Address to student. 
        student.studentAddress = input.newStudentAddress; // Stores student's new address. 
        }

        // Stores new student's data. 
        student.firstName = input.newFirstName;
        student.middleName = input.newMiddleName;
        student.lastName = input.newLastName;
        student.dateOfBirth = input.newDateOfBirth;
        student.department = input.newDepartment;
        student.course = input.newCourse;
        student.location = input.newLocation;
        student.mobileNumber = input.newMobileNumber;
        student.email = input.newEmail;
        student.timestamp = block.timestamp;

        studentStore.existingAddress[student.studentAddress] = false; // Student's old address no longer exist.
        studentStore.existingAddress[input.newStudentAddress] = true; // Student's new address now exist. 

        emit StudentBioUpdated(_studentId, input.newFirstName, input.newLastName);
        emit StudentContactUpdated(_studentId, input.newDepartment, input.newCourse, input.newStudentAddress);
    }

    /// @notice Deletes student's data.
    /// @param _studentId Student's Id. 
    /// @param _studentAddress Student's Address.
    function deleteStudentData(uint256 _studentId, address _studentAddress) internal isActive isRegistrar {
        if(studentStore.existingStudent[_studentId] != true) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
        if(studentStore.existingAddress[_studentAddress] != true) revert __STUDENTRECORDSYSTEM_STUDENT_ADDRESS_DOESNT_EXIST(_studentAddress);
        delete studentStore.students[_studentId];
        delete studentStore.studentsByAddress[_studentAddress];
        
        studentStore.existingStudent[_studentId] = false; // Student id = false (student id no longer exist).
        studentStore.existingAddress[_studentAddress] = false; // Student address = false (student address no longer exist). 

        emit StudentDeleted(_studentId, _studentAddress);
    }
}