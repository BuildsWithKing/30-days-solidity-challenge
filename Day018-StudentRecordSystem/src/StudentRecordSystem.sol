// SPDX-License-Identifier: MIT

/// @title StudentRecordSystem (Main contract). 
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 28th of July, 2025. 

pragma solidity ^0.8.18;

/// @notice Imports AdminManager file. 
import {AdminManager} from "./AdminManager.sol";

/// @notice Imports GradesManager file.
import {GradesManager} from "./GradesManager.sol";

/// @notice Imports StudentRegistry file. 
import {StudentRegistry} from "./StudentRegistry.sol";

/// @notice Imports AcademicRegistry file.
import {AcademicRecordManager} from "./AcademicRecordManager.sol";

/// @notice Import Utlis file.
import {Utils} from "./Utils.sol";

/// @notice Imports StudentLib (library). 
import {StudentLib} from "./Libraries/StudentLib.sol";

/// @notice Imports StudentTypes library. 
import {StudentTypes} from "./Libraries/StudentTypes.sol";

/// @notice Imports StudentUtils file. 
import {StudentUtils} from "./Libraries/StudentUtils.sol";

/// @notice Imports Studentstruct library. 
import {StudentStruct} from "./Structs/StudentStructs.sol";

/// @dev Thrown when owner tries to transfer ownership to the zero Address. 
error __STUDENTRECORDSYSTEM_INVALID_ADDRESS();

/// @dev Thrown when staffs or students tries to perform only owner operations. 
error __STUDENTRECORDSYSTEM_UNAUTHORIZED_ACCESS();

contract StudentRecordSystem is AdminManager, Utils, StudentRegistry, AcademicRecordManager, GradesManager {

/// @notice StudentStorage used, imported from StudentLib. 
    using StudentLib for StudentLib.StudentStorage;

    /// @notice Sets contract deployer as owner. 
    constructor() {
        owner = msg.sender;
        academicRecordManager = msg.sender;
        gradesManager = msg.sender;
        studentRegistrar = msg.sender;
    }

    /// @notice Register's student.
    /// @param input Student's input (struct). 
    function registerStudent(StudentStruct.StudentInput memory input) external isRegistrar isActive {
        register(input); // Calls internal register() from StudentRegistry 
    } 

    /// @notice Bulk register students. 
    /// @param inputs Student's input array format.
    function registerMany(StudentStruct.StudentInput[] memory inputs) external isRegistrar isActive {
        for (uint256 i = 0; i < inputs.length; i++) {
            register (inputs[i]);
        }
    }
    
    /// @notice Updates student info.
    /// @param _studentId Student's Id. 
    /// @param input Student's input (struct).
    function updateStudentRecord(uint256 _studentId, StudentStruct.UpdateStudentInput memory input) external isRegistrar isActive {
        updateStudent(_studentId, input); // Calls internal updateStudent() from StudentRegistry. 
    }
    
    /// @notice Deletes student's data.
    /// @param _studentId Student's Id. 
    /// @param _studentAddress Student's Address.
    function deleteStudent(uint256 _studentId, address _studentAddress) external isRegistrar isActive {
        deleteStudentData(_studentId, _studentAddress); // Calls internal deleteStudentData() from StudentRegistry. 
    }
    
    /// @notice Stores student's scores. 
    /// @param _studentId Student's id. 
    /// @param _scores Student's scores.
    function addStudentCourseScores(uint256 _studentId, uint256[] memory _scores) external isAcademicManager isActive { 
        addCourseScore(_studentId, _scores);
    }

     /// @notice Stores student's class performance score. 
    /// @param _studentId Student's id. 
    /// @param _scores Student's performance score.
    function addStudentClassPerformanceScores(uint256 _studentId, uint256[] memory _scores) external isAcademicManager isActive { 
       addClassPerformanceScore(_studentId, _scores);
    }

      /// @notice Stores student's attendance score. 
    /// @param _studentId Student's id. 
    /// @param _scores Student's attendance score.
    function addStudentAttendanceScores(uint256 _studentId, uint256[] memory _scores) external isAcademicManager isActive { 
       addAttendanceScore(_studentId, _scores);
    }

    /// @notice Stores all student's scores.
    /// @param _studentId Student's id. 
    /// @param _courseScores Student's course scores.
    /// @param _performanceScores Student's performance scores.
    /// @param _attendanceScores Student's attendance scores.
    function addStudentScores(uint256 _studentId, uint256[] memory _courseScores, uint256[] memory _performanceScores, 
    uint256[] memory _attendanceScores) external isAcademicManager isActive {   
        addAllScore(_studentId, _courseScores, _performanceScores, _attendanceScores); 
    }

    /// @notice Grades student's course.
    /// @param _studentId Student's id.
    /// @param _grades Student's grade. 
    function gradeStudentCourses(uint256 _studentId, StudentTypes.Grade[] memory _grades) external isGradesManager isActive {
        gradeCourse(_studentId, _grades);
    }

     /// @notice Grades student's performance.
    /// @param _studentId Student's id.
    /// @param _grades Student's grade. 
    function gradeStudentPerformance(uint256 _studentId, StudentTypes.Grade[] memory _grades) external isGradesManager isActive {
       gradePerformance(_studentId, _grades);
    }

    /// @notice Grades student's attendance.
    /// @param _studentId Student's id.
    /// @param _grades Student's grade. 
    function gradeStudentAttendance(uint256 _studentId, StudentTypes.Grade[] memory _grades) external isGradesManager isActive {
        gradeAttendance(_studentId, _grades);
    }

    /// @notice Grades all student's grades.
    /// @param _studentId Student's id. 
    /// @param _courseGrades Student's course grades.
    /// @param _performanceGrades Student's performance grades.
    /// @param _attendanceGrades Student's attendance grades.
    function addStudentGrades(uint256 _studentId, StudentTypes.Grade[] memory _courseGrades, StudentTypes.Grade[] memory _performanceGrades,
    StudentTypes.Grade[] memory _attendanceGrades) external isGradesManager isActive {
        gradeAll(_studentId, _courseGrades, _performanceGrades, _attendanceGrades);   
    }

    /// @notice Returns student's data.
    /// @param _studentId Student's Id.  
    /// @return Student's stored data. 
    function getStudentData(uint256 _studentId) public view returns(StudentLib.Student memory) {
        return studentStore.getStudent(_studentId); // From Lib. 
    }

    /// @notice Returns student's status as unsigned integer (0,1,2,3).
    /// @param _studentId Student's Id.
    /// @return Student's Status ((0) => Active, (1) => Suspended, 2=> Graduated, 3 => Expelled). 
    function getStudentStatus(uint256 _studentId) public view returns(StudentTypes.StudentStatus) {
        return StudentTypes.StudentStatus(studentStore.getStudent(_studentId).studentStatus);
    }

    /// @notice Returns student's status as string.
    /// @param _studentId Student's Id.
    /// @return Student's Status (Active, Suspended, Graduated, Expelled). 
    function getStudentStatusAsString(uint256 _studentId) public view returns(string memory) {
        StudentTypes.StudentStatus statusEnum = StudentTypes.StudentStatus(studentStore.getStudent(_studentId).studentStatus);
        return StudentUtils.statusToString(statusEnum);
    }

    /// @notice Returns student's data.
    /// @param _studentAddress Student's Id.  
    /// @return student's stored data. 
    function getStudentByAddress(address _studentAddress) public view returns(StudentLib.Student memory) {
        return studentStore.studentsByAddress[_studentAddress]; // From Lib. 
    }

    /// @notice Returns bool (true / false).
    /// @param _studentId Student's Id.
    /// @return true if student exists, false if not. 
    function checkIfStudentExist(uint256 _studentId) public view returns(bool) {
        return studentStore.exist(_studentId); // From Lib.
    }

    /// @notice Returns bool (true / false).
    /// @param _studentAddress Student's Address. 
    /// @return true if student exists, false if not. 
    function checkIfStudentAddressExist(address _studentAddress) public view returns(bool) {
        return studentStore.existAddress(_studentAddress); // From Lib.
    }

    /// @notice Returns student's course scores.
    /// @param _studentId Student's id. 
    /// @return Student course scores. 
    function getStudentCourseScores(uint256 _studentId) public view returns(uint256[] memory){
        return studentStore.studentRecords[_studentId].courseScores;
    }

    /// @notice Returns student's class performance scores. 
    /// @param _studentId Student's id. 
    /// @return Student class performance scores. 
    function getStudentPerformanceScores(uint256 _studentId) public view returns(uint256[] memory){
        return studentStore.studentRecords[_studentId].performanceScores;
    }

    /// @notice Returns student's class attendance scores. 
    /// @param _studentId Student's id. 
    /// @return Student class attendance scores. 
    function getStudentAttendanceScores(uint256 _studentId) public view returns(uint256[] memory){
        return studentStore.studentRecords[_studentId].attendanceScores;
    }

    /// @notice Returns student's course grades.
    /// @return student's course grades. 
    function getStudentCourseGrades(uint256 _studentId) public view returns(uint8[] memory) {
        StudentLib.StudentRecord storage student = studentStore.studentRecords[_studentId];

        uint256 len = student.courseGrades.length;
        uint8[] memory result = new uint8[](len);
        for(uint256 i = 0; i < len; i++)  {
            result[i] = uint8(student.courseGrades[i]);
        }
        return result;
    }

     /// @notice Returns student's performance grades.
    /// @return student's performance grades. 
    function getStudentPerformanceGrades(uint256 _studentId) public view returns(uint8[] memory) {
        StudentLib.StudentRecord storage student = studentStore.studentRecords[_studentId];
        
        uint256 len = student.performanceGrades.length;
        uint8[] memory result = new uint8[](len);
        for(uint256 i = 0; i < len; i++) {
            result[i] = uint8(student.performanceGrades[i]);
        }
        return result;
    }

     /// @notice Returns student's attendance grades.
    /// @return student's attendance grades. 
    function getStudentAttendanceGrades(uint256 _studentId) public view returns(uint8[] memory) {
        StudentLib.StudentRecord storage student = studentStore.studentRecords[_studentId];
        
        uint256 len = student.attendanceGrades.length;
        uint8[] memory result = new uint8[](len);
        for(uint i = 0; i < len; i++) {
            result[i] = uint8(student.attendanceGrades[i]);
        }
        return result;
    }
}