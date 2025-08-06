// SPDX-License-Identifier: MIT

/// @title AuctionTypes (AuctionTypes file for SimpleAuction contract). 
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// @date Created: 2nd of August, 2025. 

/// @notice Stores auction states. 

pragma solidity ^0.8.18;


library AuctionTypes {

    /// @notice Defines auction state. 
    enum AuctionState {
        NotActive,
        Active,
        Ended,
        Cancelled
    }

    /// @dev Converts AuctionState enum to string representation. 
    /// @param state The AuctionState to convert.
    /// @return A string version of the AuctionState. 
    function auctionStateToString(
        AuctionState state
        ) internal pure returns(
        string memory) {
        if(state == AuctionState.NotActive) return "Not Active";
        if(state == AuctionState.Active) return "Active";
        if(state == AuctionState.Ended) return "Ended";
        if(state == AuctionState.Cancelled) return "Cancelled";
        revert("Invalid auction state");
    }
}