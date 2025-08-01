// SPDX-License-Identifier: MIT

/// @title AcademicRecordManager (AcademicRecordManager contract for StudentRecordSystem).
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 26th of July, 2025. 

pragma solidity ^0.8.18;

/// @notice imports StudentRegistry file. 
import {StudentRegistry} from "./StudentRegistry.sol";

/// @notice Imports utils file. 
import {Utils} from "./Utils.sol";

/// @notice Imports StudentLib (library). 
import {StudentLib} from "./Libraries/StudentLib.sol";

import {StudentTypes} from "./Libraries/StudentTypes.sol";

/// @dev Thrown when academic manager tries to score empty value for students. 
error  __STUDENTRECORDSYSTEM_STUDENT_SCORE_CANT_BE_EMPTY();

/// @dev Thrown when id doesn't match any student's id. 
error __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(uint256 studentId);

/// @notice Import StudentInput and UpdateStudentInput struct. 
import {StudentStruct} from "./Structs/StudentStructs.sol";

contract AcademicRecordManager is StudentRegistry { 

    /// @notice Emits StudentCourseScoreAdded.
    /// @param studentId Student's id.
    /// @param scores Student's course scores. 
    event CourseScoreAdded(uint256 indexed studentId, uint256[] indexed scores);

    /// @notice Emits StudentClassPerformanceScoreAdded.
    /// @param studentId Student's id.
    /// @param scores Student's class performance scores. 
    event PerformanceScoreAdded(uint256 indexed studentId, uint256[] indexed scores);

    /// @notice Emits StudentAttendanceScoreAdded.
    /// @param studentId Student's id.
    /// @param scores Student's attendance scores. 
    event AttendanceScoreAdded(uint256 indexed studentId, uint256[] indexed scores);

    /// @notice Emits AllScoresAdded.
    /// @param studentId Student's id.
    /// @param courseScores Student course scores.
    /// @param performanceScores Student performance scores.
    /// @param attendanceScores Student's attendance scores. 
    event AllScoresAdded(uint256 indexed studentId, uint256[] indexed courseScores, 
    uint256[] indexed performanceScores, uint256[] attendanceScores);

    /// @notice Stores student's scores. 
    /// @param _studentId Student's id. 
    /// @param _scores Student's scores.
    function addCourseScore(uint256 _studentId, uint256[] memory _scores) internal isAcademicManager isActive {
        if(!studentStore.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
        if(_scores.length == 0) revert __STUDENTRECORDSYSTEM_STUDENT_SCORE_CANT_BE_EMPTY();
        StudentLib.StudentRecord storage student = studentStore.studentRecords[_studentId];
        student.courseScores = (_scores);
        student.timestamp = block.timestamp;
        
        emit CourseScoreAdded(_studentId, _scores);
    }

    /// @notice Stores student's class performance score. 
    /// @param _studentId Student's id. 
    /// @param _scores Student's performance score.
    function addClassPerformanceScore(uint256 _studentId, uint256[] memory _scores) internal isAcademicManager isActive {
        if(!studentStore.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
        if(_scores.length == 0) revert __STUDENTRECORDSYSTEM_STUDENT_SCORE_CANT_BE_EMPTY();
        StudentLib.StudentRecord storage student = studentStore.studentRecords[_studentId];
        student.performanceScores = (_scores);
        student.timestamp = block.timestamp;

        emit PerformanceScoreAdded(_studentId, _scores);
    }

    /// @notice Stores student's attendance score.
    /// @param _studentId Student's id. 
    /// @param _scores Student's attendance score.
    function addAttendanceScore(uint256 _studentId, uint256[] memory _scores) internal isAcademicManager isActive {
        if(!studentStore.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
        if(_scores.length == 0) revert __STUDENTRECORDSYSTEM_STUDENT_SCORE_CANT_BE_EMPTY();   
        StudentLib.StudentRecord storage student = studentStore.studentRecords[_studentId];
        student.attendanceScores = _scores;
        student.timestamp = block.timestamp;

        emit AttendanceScoreAdded(_studentId, _scores);
    }

     /// @notice Stores all student's scores.
    /// @param _studentId Student's id. 
    /// @param _courseScores Student's course scores.
    /// @param _performanceScores Student's performance scores.
    /// @param _attendanceScores Student's attendance scores.
    function addAllScore(uint256 _studentId, uint256[] memory _courseScores, uint256[] memory _performanceScores, 
    uint256[] memory _attendanceScores) internal isAcademicManager isActive {
    if(!studentStore.existingStudent[_studentId]) revert __STUDENTRECORDSYSTEM_STUDENT_DOESNT_EXIST(_studentId);
        StudentLib.StudentRecord storage student = studentStore.studentRecords[_studentId];
        student.courseScores = _courseScores;
        student.performanceScores = _performanceScores;
        student.attendanceScores = _attendanceScores;
        student.timestamp = block.timestamp;

        emit AllScoresAdded(_studentId, _courseScores, _performanceScores, _attendanceScores); 
    }
}