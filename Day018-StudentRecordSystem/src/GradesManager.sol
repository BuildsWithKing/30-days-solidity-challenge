// SPDX-License-Identifier: MIT

/// @title GradesManager (GradesManager for StudentRecordSystem). 
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 28th of July, 2025. 

pragma solidity ^0.8.18;

/// @notice Import StudentRegistry file. 
import {StudentRegistry} from "./StudentRegistry.sol";

/// @notice Import Utils file. 
import {Utils} from "./Utils.sol";

/// @notice Import StudentLib (library). 
import{StudentLib} from "./Libraries/StudentLib.sol";

/// @notice Imports StudentTypes Library.
import {StudentTypes} from "./Libraries/StudentTypes.sol";

/// @dev Thrown when gradesmanager tries storing empty grades for student. 
error __STUDENTRECORDSYSTEM_STUDENT_GRADE_CANT_BE_EMPTY();

/// @dev Thrown when id doesn't match any student's id. 
error __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(uint256 studentId);

/// @dev Thrown when student address doesn't exist. 
error __STUDENTRECORDSYSTEM_STUDENT_ADDRESS_DOESNT_EXIST(address studentAddress);

contract GradesManager is Utils, StudentRegistry {

        using StudentLib for StudentLib.StudentStorage;

    /// @notice Emits StudentCoursesGraded.
    /// @param studentId Student's id.
    /// @param studentGrades Student's grades. 
    event StudentCoursesGraded(uint256 indexed studentId, StudentTypes.Grade[] studentGrades);

    /// @notice Emits StudentPerformanceGraded.
    /// @param studentId Student's id.
    /// @param studentGrades Student's grades. 
    event StudentPerformanceGraded(uint256 indexed studentId, StudentTypes.Grade[] studentGrades);

    /// @notice Emits StudentAttendanceGraded.
    /// @param studentId Student's id.
    /// @param studentGrades Student's grades. 
    event StudentAttendanceGraded(uint256 indexed studentId, StudentTypes.Grade[] studentGrades);

    /// @notice Emits AllScoresAdded.
    /// @param studentId Student's id.
    /// @param courseGrades Student course scores.
    /// @param performanceGrades Student performance scores.
    /// @param attendanceGrades Student's attendance scores. 
    event AllGradesAdded(uint256 indexed studentId, StudentTypes.Grade[] courseGrades, 
    StudentTypes.Grade[] performanceGrades, StudentTypes.Grade[] attendanceGrades);

    /// @notice Grades student's course.
    /// @param _studentId Student's id.
    /// @param _grades Student's grade. 
    function gradeCourse(uint256 _studentId, StudentTypes.Grade[] memory _grades) internal isGradesManager isActive {
        if(!studentStore.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
        if(_grades.length <= 0) revert __STUDENTRECORDSYSTEM_STUDENT_GRADE_CANT_BE_EMPTY();
        
        StudentLib.StudentRecord storage record = studentStore.studentRecords[_studentId];
        record.courseGrades = _grades;
        record.timestamp = block.timestamp;

        emit StudentCoursesGraded(_studentId, _grades);
    }

     /// @notice Grades student's performance.
    /// @param _studentId Student's id.
    /// @param _grades Student's grade. 
    function gradePerformance(uint256 _studentId, StudentTypes.Grade[] memory _grades) internal isGradesManager isActive {
        if(!studentStore.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
        if(_grades.length <= 0) revert __STUDENTRECORDSYSTEM_STUDENT_GRADE_CANT_BE_EMPTY();
        
        StudentLib.StudentRecord storage record = studentStore.studentRecords[_studentId];
        record.performanceGrades = _grades;
        record.timestamp = block.timestamp;

        emit StudentPerformanceGraded(_studentId, _grades);
    }

     /// @notice Grades student's attendance.
    /// @param _studentId Student's id.
    /// @param _grades Student's grade. 
    function gradeAttendance(uint256 _studentId, StudentTypes.Grade[] memory _grades) internal isGradesManager isActive {
        if(!studentStore.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
        if(_grades.length <= 0) revert __STUDENTRECORDSYSTEM_STUDENT_GRADE_CANT_BE_EMPTY();
        
        StudentLib.StudentRecord storage record = studentStore.studentRecords[_studentId];
        record.attendanceGrades = _grades;
        record.timestamp = block.timestamp;
       
        emit StudentAttendanceGraded(_studentId, _grades);
    }

    /// @notice Grades all student's grades.
    /// @param _studentId Student's id. 
    /// @param _courseGrades Student's course grades.
    /// @param _performanceGrades Student's performance grades.
    /// @param _attendanceGrades Student's attendance grades.
    function gradeAll(uint256 _studentId, StudentTypes.Grade[] memory _courseGrades, StudentTypes.Grade[] memory _performanceGrades,
    StudentTypes.Grade[] memory _attendanceGrades) internal isGradesManager isActive {
    if(!studentStore.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
    if(_courseGrades.length == 0 || _performanceGrades.length == 0 || _attendanceGrades.length == 0)
    revert __STUDENTRECORDSYSTEM_STUDENT_GRADE_CANT_BE_EMPTY();
        
        StudentLib.StudentRecord storage record = studentStore.studentRecords[_studentId];
        record.courseGrades = _courseGrades;
        record.performanceGrades = _performanceGrades;
        record.attendanceGrades = _attendanceGrades;

     emit AllGradesAdded(_studentId, _courseGrades, _performanceGrades, _attendanceGrades);    
    }
}