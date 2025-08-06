// SPDX-License-Identifier: MIT

/// @title AuctionLib (Auction Library for SimpleAuction contract). 
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// @date Created: 2nd of August, 2025.

/* Stores Auction mappings.
*/

pragma solidity ^0.8.18;

/// @notice Imports AuctionStruct Struct file.
import {AuctionStruct} from "../Structs/AuctionStruct.sol";

/// @notice Imports AuctionTypes Library.
import {AuctionTypes} from "./AuctionTypes.sol";

library AuctionLib {

    /// @notice Used ItemData from AuctionStruct. 
    using AuctionStruct for AuctionStruct.ItemData;

    /// @notice Used AuctionState from AuctionTypes. 
    using AuctionTypes for AuctionTypes.AuctionState;

    /// @notice Groups mapping for seller's data, bidder records. 
    struct AuctionData {
    
    /// @dev Maps seller's address => itemData. 
    mapping(address => AuctionStruct.ItemData[]) sellerInfo; 

    /// @dev Maps item ID => itemData. 
    mapping(uint256 => AuctionStruct.ItemData) itemsById;

    /// @dev Maps address => ETH. 
    mapping(address => uint256) bidderRecords;

    /// @dev Maps item ID => AuctionState.
    mapping(uint256 => AuctionTypes.AuctionState) itemState;

    /// @dev Maps item ID => highest ETH bid.
    mapping(uint256 => uint256) highestBid;

    /// @dev Maps ETH to bidder's address. 
    mapping(uint256 => address) highestBidder;

    /// @dev Maps item ID => bidCount. 
    mapping(uint256 => uint256) bidRecord;
    }
}