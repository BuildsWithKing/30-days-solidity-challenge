// SPDX-License-Identifier: MIT

/// @title AuctionStruct (AuctionStruct for SimpleAuction contract). 
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// @date Created: 2nd of August, 2025. 

pragma solidity ^0.8.18;

library AuctionStruct {

    /// @notice Struct representing an item available for auction. 
    struct ItemData {
            uint256 itemId;
            uint256 quantity;
            uint256 startingPrice;
            uint256 listedAt;
            uint256 endsAt;
            address owner;
            string title;
            string description;
            string itemType;    
    }
}