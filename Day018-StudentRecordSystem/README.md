# 📚 *StudentRecordSystem (Day 18 – 30 Days of Solidity)*

A decentralized, permissioned student management system that allows educational institutions to securely register students, manage their academic records, and track student status. This system enforces role-based access, detailed event logging, and the ability to update or delete student records, all while supporting an "Active" or "NotActive" contract state.

---

## ✅ *Features*

- *constructor()*: Sets the contract deployer as the owner, initializing the contract with the default owner for all roles (Admin Manager, Academic Manager, Grades Manager, Student Registrar).
  
- *registerStudent(StudentInput memory input)*: Registers a new student by calling the internal register() function from the StudentRegistry. Callable by staff only (once activated).

- *registerMany(StudentInput[] memory inputs)*: Allows bulk student registration. Useful for onboarding multiple students at once. Calls the internal register() function for each input.

- *updateStudentRecord(uint256 _studentId, UpdateStudentInput memory input)*: Updates an existing student’s record. The updateStudent() function from the StudentRegistry is invoked. Staff-only access.

- *deleteStudent(uint256 _studentId, address _studentAddress)*: Deletes a student’s record. Ensures student data can be removed by their registrar. Calls deleteStudentData() internally.

- *addStudentScores(uint256 _studentId, uint256[] memory _courseScores, uint256[] memory _performanceScores, uint256[] memory _attendanceScores)*: Registers all relevant student performance data — course scores, class performance, and attendance — in a single function. This data is then passed to the addAllScore() internal function.

- *addStudentGrades(uint256 _studentId, Grade[] memory _courseGrades, Grade[] memory _performanceGrades, Grade[] memory _attendanceGrades)*: Adds grading information for all areas (course, performance, attendance). This data is passed to the gradeAll() internal function.

- *getStudentData(uint256 _studentId)*: Fetches a specific student’s data using the studentStore.getStudent() function from the StudentLib.

- *getStudentStatus(uint256 _studentId)*: Returns the student’s status (Active, Suspended, Graduated, Expelled) using the student’s record data.

- *getStudentStatusAsString(uint256 _studentId)*: Converts the status enum (Active, Suspended, Graduated, Expelled) into a string for easier interpretation.

- *checkIfStudentExist(uint256 _studentId)*: Returns a boolean indicating whether a student exists in the system.

---

🔒 *Role-Based Access Control & Admin Functions*

- *onlyOwner*: Restricts access to the owner of the contract.

- *isAdminManager*: Restricts access to the admin manager for roles assignment. 
  
- *isRegistrar*: Restricts access to the Student Registrar role for registering and deleting students.
  
- *isAcademicManager*: Restricts access to Academic Manager role for adding scores.

- *isGradesManager*: Restricts access to the Grades Manager role for grading student's records.

- *activateContract()*: Only the contract owner can activate the contract, enabling all functionality.

- *deactivateContract()*: Only the contract owner can deactivate the contract, disabling all functionality.

- *transferOwnership(address _newOwner)*: Transfer ownership of the contract to a new address.

- *renounceOwnership()*: Allows the contract owner to renounce ownership of the contract.

---

⚠ *Important*

- The contract can only operate once activated by the owner (using the activateContract() function).
- All staff actions are logged and permission-restricted based on their role (Registrar, Academic Manager, or Grades Manager).
- A student's record is accessible by their studentId. The contract stores detailed student data, including performance, grades, and status.
  
---

🧠 *Concepts Practiced*

- *Custom Errors*: Custom error handling for cleaner debugging and optimized gas usage.
  
- *Role-Based Access Control*: Enforced using custom modifiers to restrict access to specific actions based on the user's role.

- *Mappings & Structs*: Use of Solidity mappings and structs for efficient student record management.

- *Academic Lifecycle Management*: Handles transitions between student statuses (Active, Suspended, Graduated, Expelled).

- *Event Emission*: Provides detailed event logging for better auditability, including student registration, grade addition, and contract activation.

- *Gas Optimization*: Uses efficient storage and data retrieval methods. 

---

📂 *Files*

- *StudentRecordSystem.sol*: Main contract file containing all features and functionality.
- *AdminManager.sol*: Manages administrative staff roles and permissions.
- *GradesManager.sol*: Handles the recording and grading of student performance.
- *StudentRegistry.sol*: Manages the registration and storage of student data.
- *AcademicRecordManager.sol*: Manages academic data like scores and performance records.
- *Utils.sol*: Manages contract's state, ownershiptransfer, ownershiprenounce,ETH withdrawal, receive and fallback. 
- *StudentLib.sol*: Library for student data management.
- *StudentTypes.sol*: Defines (Enum) student's gender, status and grades.  
- *StudentUtlis.sol*: Converts student's status (enum) to string.
- *StudentStructs.sol*: Groups student's info and record. 

---

## 📁 Project Structure

This contract was structured modularly for clarity and maintainability. Below is a breakdown of each file's purpose:

```
src/
├── StudentRecordSystem.sol        # Main contract integrating all features and modules
├── AdminManager.sol               # Manages administrative staff roles and permissions
├── GradesManager.sol              # Handles student performance recording and grading logic
├── StudentRegistry.sol            # Handles student registration and ID tracking
├── AcademicRecordManager.sol      # Manages academic data: scores. 
├── Utils.sol                      # Handles contract state control, ownership logic, ETH withdrawal, receive, and fallback
│
├── libraries/
│   ├── StudentLib.sol             # Utility library for managing student data
│   ├── StudentTypes.sol           # Enum definitions: Gender, Status, Grade
│   └── StudentUtils.sol           # Converts student enums (e.g., status) to strings
│
└── structs/
    └── StudentStructs.sol         # Shared struct definitions for student information and academic records

```
---

## 🚀 *Why This Matters*

In Web3 education applications, student data needs to be decentralized, secure, and immutable. This project demonstrates the key components of:

- A decentralized, permissioned student management system.
- Advanced record-keeping using Solidity mappings and structs.
- Role-based access control for managing student data and academic records.
- Secure and efficient handling of student data through lifecycle stages, including active status, suspension, graduation, and expulsion.

---

## 🛠 *Example Usage (Remix)*

### ✅ *Step 1: Deploy Contract*
- Compile and deploy the StudentRecordSystem.sol contract on Remix.
- Call activateContract() to enable core features.

### ✅ *Step 2: Register a Student*

```solidity
registerStudent 

paste: [ "Micheal", "King", "BuildsWithKing", 19990510, 1, 0, "Software Engineering", "Smart Contracts", "Nigeria", 2348012345678, 0x63c013128BF5C7628Fc8B87b68Aa90442AF312aa, "buildswithKing@gmail.com", 1722404024]

```
### ✅ Step 3: View Student Data

```solidity
getStudentData(12345)

```
### ✅ Step 4: Update Student Record

```solidity
updateStudentRecord
  
paste: [ "Micheal", "King", "BuildsWithKing", 20000515, 1, 0, "Software Developement", "Smart Contracts", "Nigeria", 2348123456789, 0x63c013128BF5C7628Fc8B87b68Aa90442AF312aa, "buildswithKing@gmail.com", 1789554675]
```

### ✅ Step 5: Add Student Scores

```solidity
addStudentScores(
  1, 
  [85, 90], 
  [88, 92], 
  [95, 97]
)
```

### ✅ Step 6: Add Student Grades

```solidity
addStudentGrades(
  1, [1, 0], [2, 2], [0, 1]
)
```

### ✅ Step 7: Check Student Status

```solidity
getStudentStatusAsString(1)

```
---

## 📅 Timeline

Built Between: July 26th – 1st Aug, 2025.

Posted On: 1st Aug, 2025.

---

## 📌 Tools & Stack

Language: Solidity ^0.8.18

IDE: [Remix](https://remix.ethereum.org/) + Visual Studio Code

Version Control: Git + GitHub (SSH)

Testing: Remix (Manual) — Upcoming Foundry test suite integration.

Design: Gas optimization, modular architecture for role-based access

---

## 📄 License

MIT License — Feel free to use, modify, and learn from.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the 30 Days of Solidity Challenge.


🙏 Please give credit if this inspired your learning journey.


---

## ✅ Day 18 Completed!

---
