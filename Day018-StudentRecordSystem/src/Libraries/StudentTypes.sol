// SPDX-License-Identifier: MIT

/// @title StudentTypes (StudentTypes Library for StudentRecordSystem). 
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 29th of July, 2025.   

pragma solidity ^0.8.18;

library StudentTypes {

    /// @notice Defines student's gender from male (0) to female (1).
    enum StudentGender {
        Male,
        Female
    }

    /// @notice Defines student's status from active (0) to expelled (3). 
    enum StudentStatus {
        Active,
        Suspended,
        Graduated,
        Expelled
    }

    /// @notice Defines student's grade from best (A => 0) to worst (F => 6). 
    enum Grade {A, AB, B, BC, D, E, F}
}