// SPDX-License-Identifier: MIT

/// @title StudentUtils (StudentUtils Library for StudentRecordSystem). 
/// @author Michealking(@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// date created 31st of July, 2025.   

pragma solidity ^0.8.18;

/// @notice Imports StudentTypes Library.
import {StudentTypes} from "./StudentTypes.sol";

library StudentUtils {

    /// @notice Converts status (enum) to string. 
    function statusToString(StudentTypes.StudentStatus status) internal pure returns(string memory) {
        if(status == StudentTypes.StudentStatus.Active) return "Active"; // Returns `Active` if status is 0.
        if(status == StudentTypes.StudentStatus.Suspended) return "Suspended"; // Returns `Suspended` if status is 1.
        if(status == StudentTypes.StudentStatus.Graduated) return "Graduated"; // Returns `Graduated` if status is 2.
        if(status == StudentTypes.StudentStatus.Expelled) return "Expelled"; // Returns `Expelled` if status is 3. 
        
        return "Unknown";
    }
}