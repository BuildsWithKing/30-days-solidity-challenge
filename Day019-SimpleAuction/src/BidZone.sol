// SPDX-License-Identifier: MIT

/// @title bidZone (bidZone file for SimpleAuction contract). 
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// @date Created: 2nd of August, 2025. 

/** @notice Allows Anyone Bid on items, Withdraw ETH.
    Claim item once declared as winner. 
*/

pragma solidity ^0.8.18; 

/// @notice Imports Utils file. 
import {Utils} from "./Utils.sol";

/// @notice Imports AuctionHub file. 
import {AuctionHub} from "./AuctionHub.sol";

/// @notice Import AuctionLib Library. 
import {AuctionLib} from "./Libraries/AuctionLib.sol";

/// @notice Imports AuctionTypes file. 
import {AuctionTypes} from "./Libraries/AuctionTypes.sol";

/// @notice Imports AuctionStruct file.
import {AuctionStruct} from "./Structs/AuctionStruct.sol";

/// @dev Thrown when bid amount is lower than minimum. 
error __SIMPLEAUCTION_ETH_AMOUNT_TOO_LOW();

/// @dev Thrown when bidders tries to bid on ID that doesn't exist. 
error __SIMPLEAUCTION_NONEXISTING_ITEMID();

/// @dev Thrwon when bidders tries to bid on inactive ID. 
error __SIMPLEAUCTION_AUCTION_NOT_ACTIVE();

/// @dev Thrown when bidders tries to bid on ended auctions.
error __SIMPLEAUCTION_AUCTION_ENDED();

/// @dev Thrown when bidders tries to bid on cancelled auctions.
error __SIMPLEAUCTION_AUCTION_CANCELLED();

/// @dev Thrown when bidder with zero balance tries to withdraw ETH. 
error __SIMPLEAUCTION_ETH_BALANCE_TOO_LOW();

/// @dev Thrown when Eth transfer fails. 
error __SIMPLEAUCTION_ETH_TRANSFER_FAILED();

/// @dev Thrown when highest bidder tries to withdraw. 
error __SIMPLEAUCTION_WITHDRAW_ONLY_WHEN_OUT_BIDDED();

/// @dev Thrown when highest bidder tries to claim item before end time. 
error __SIMPLEAUCTION_AUCTION_IS_STILL_ACTIVE();

/// @dev Thrown when a bidder who is not the highest bidder tries to claim item.  
error __SIMPLEAUCTION_ACCESS_DENIED();

contract BidZone is Utils, AuctionHub {

     /// @notice Used auctionData from AuctionLib. 
    using AuctionLib for AuctionLib.AuctionData;
   
    /// @notice Used ItemData from AuctionStruct. 
    using AuctionStruct for AuctionStruct.ItemData;

    /// @notice Records total number of bids.
    uint256 public totalBid;

    /// @notice Emits SuccessfulBid. 
    /// @param itemId The item's identification number. 
    /// @param ethAmount The Amount of ETH bidded. 
    /// @param bidderAddress The bidder's Address.
    event SuccessfulBid(uint256 indexed itemId, uint256 indexed ethAmount, address bidderAddress);

    /// @notice Emits EthWithdrawn.
    /// @param bidderAddress The bidder's address.
    /// @param ethAmount The Amount of ETH withdrawn. 
    event EthWithdrawn(address indexed bidderAddress, uint256 indexed ethAmount);

    /// @notice Emits ItemClaimed.
    /// @param bidderAddress The highest bidder's address.
    /// @param itemId The item's identification number.
    event ItemClaimed(address indexed bidderAddress, uint256 itemId);

    /// @notice Allows bidders bid on items. 
    /// @param _itemId The item's identification number.
    function bid(
        uint256 _itemId
    ) internal isActive {
        
        // Access item ID. 
        AuctionStruct.ItemData memory itemData = seller.itemsById[_itemId];

        // Prevent bidding once timestamp is greater than end time. 
        if(block.timestamp > itemData.endsAt) revert __SIMPLEAUCTION_AUCTION_ENDED();

        // Ensure bidder ETH is greater than starting price. 
        if(msg.value <= itemData.startingPrice) revert __SIMPLEAUCTION_ETH_AMOUNT_TOO_LOW();

        // Ensure next bidder ETH is greater than previous ETH
         if(msg.value <= seller.highestBid[_itemId]) revert __SIMPLEAUCTION_ETH_AMOUNT_TOO_LOW();

        // Prevent bidder from bidding when auction is not active.  
        if(seller.itemState[_itemId] == AuctionTypes.AuctionState.NotActive) revert __SIMPLEAUCTION_AUCTION_NOT_ACTIVE();

        // Prevent bidder from bidding once auction has ended. 
        if(seller.itemState[_itemId] == AuctionTypes.AuctionState.Ended) revert __SIMPLEAUCTION_AUCTION_ENDED();

        // Prevent bidder from bidding once auction is cancelled. 
        if(seller.itemState[_itemId] == AuctionTypes.AuctionState.Cancelled) revert __SIMPLEAUCTION_AUCTION_CANCELLED();

        // Store bidder as new highest bidder. 
        seller.highestBidder[_itemId] = msg.sender;

        // Store ETH on bidder records.
        seller.bidderRecords[msg.sender] = msg.value;

        // Store ETH as new highest bid.
        seller.highestBid[_itemId] = msg.value;

        // Increment total bid by 1. 
        totalBid++;
        
        // Record bid count.
        uint256 bidCount = 1;

        // Store bid count for itemId. 
        seller.bidRecord[_itemId] += bidCount;

        // Emit event SuccessfulBid. 
        emit SuccessfulBid(_itemId, msg.value, msg.sender);
    }

    /// @notice Allows bidders Withdraw ETH. 
    function withdraw(uint256 _ethAmount) internal isActive {

        // Prevent bidder with zero ETH balance from withdrawing. 
        if(_ethAmount > seller.bidderRecords[msg.sender]) revert __SIMPLEAUCTION_ETH_BALANCE_TOO_LOW();

        // Prevent highest bidder until out bidded.
        if(_ethAmount == seller.bidderRecords[msg.sender]) revert __SIMPLEAUCTION_WITHDRAW_ONLY_WHEN_OUT_BIDDED();

        // Fund caller's address . 
        (bool success,) = payable(msg.sender).call{value: _ethAmount}("");
      
        // Revert if withdraw fails. 
        if(!success) revert __SIMPLEAUCTION_ETH_TRANSFER_FAILED(); 

        uint256 bidCount = 1;

        // Subtract 1 from bid count. 
        unchecked{

            bidCount --;
        }

        // Emit event ETH withdrawn. 
        emit EthWithdrawn(msg.sender, _ethAmount);
    }

    /// @notice Allows Bidders claim items. 
    /// @param _itemId The item identification number.
    function claim(uint256 _itemId) internal isActive {

        // Access item ID. 
        AuctionStruct.ItemData memory itemData = seller.itemsById[_itemId];

        // Prevent highest bidder from withdrawing before end time. 
        if(block.timestamp < itemData.endsAt) revert __SIMPLEAUCTION_AUCTION_IS_STILL_ACTIVE();

        // Prevent highest bidder from claiming once auction is cancelled. 
        if(seller.itemState[_itemId] == AuctionTypes.AuctionState.Cancelled) revert __SIMPLEAUCTION_AUCTION_CANCELLED();

        // Prevent non-highest bidders. 
        if(msg.sender != seller.highestBidder[_itemId]) revert __SIMPLEAUCTION_ACCESS_DENIED(); 

        // Assign highest bidder as item owner. 
        seller.itemsById[_itemId].owner = msg.sender;

        // Reset highest bidder's ETH after claim. 
        seller.bidderRecords[msg.sender] = 0;

        // Emit event item claimed. 
        emit ItemClaimed(msg.sender, _itemId);
    }
}