// SPDX-License-Identifier: MIT

/// @title SimpleAuction (Main Contract)
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// @date Created: 1st of August, 2025. 

/** @notice Allows anyone bid ETH on an item during a limited time. 
    After the auction ends, the highest bidder wins.
*/

pragma solidity ^0.8.18;

/// @notice Imports Utils file. 
import {Utils} from "./Utils.sol";

/// @notice Imports AuctionHub file. 
import {AuctionHub} from "./AuctionHub.sol";

import {BidZone} from "./BidZone.sol";

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

contract SimpleAuction is Utils, AuctionHub, BidZone {

    /// @notice Used auctionData from AuctionLib. 
    using AuctionLib for AuctionLib.AuctionData;
   
    /// @notice Used ItemData from AuctionStruct. 
    using AuctionStruct for AuctionStruct.ItemData;

    /// @notice Sets contract deployer as auctioneer.
    constructor(){
        auctioneer = msg.sender;
    }

    /// @notice Allows sellers register items for auction.
    /// @param _title The Item's title. 
    /// @param _description A brief description of the item.
    /// @param _quantity Number of items available for auction.
    /// @param _startingPrice Initial price set by the seller. 
    function registerItem(
        string memory _title,
        string memory _description,
        string memory _itemType,
        uint256 _quantity,
        uint256 _startingPrice,
        uint256 _endsAt
    ) external isActive {

        // Call internal register function. 
        register(_title, _description, _itemType, _quantity, _startingPrice, _endsAt);

    }
 /// @notice Allows Sellers update items.
     /// @param _itemId The item's identification number. 
    /// @param _newTitle Item's new title. 
    /// @param _newDescription A brief description of the item. 
    /// @param _newItemType The Item's new Type.
    /// @param _newQuantity Number of items available for auction.
    /// @param _newStartingPrice Initial price set by the seller.
    /// @param _newEndsAt Auction's new end time.  
    function updateItem(
        uint256 _itemId,
        string memory _newTitle,
        string memory _newDescription,
        string memory _newItemType,
        uint256 _newQuantity,
        uint256 _newStartingPrice,
        uint256 _newEndsAt
    ) external isActive {

        // Call internal update function.
        update(_itemId, _newTitle, _newDescription, _newItemType, _newQuantity, _newStartingPrice, _newEndsAt);

    }

    /// @notice Deletes seller's item. 
    /// @param _itemId The The item's identification number. 
    function deleteMyItem(
        uint256 _itemId
    ) external isActive {

        // Call internal delete function.
        deleteItem(_itemId);
    }

    /// @notice Activates Auction.
    /// @param _itemId The item's identification number. 
    function activateAuction(
        uint256 _itemId
    ) external isActive {

        // Call internal activate function.
        activate(_itemId);
    }

    /// @notice Deactivates Auction.
    /// @param _itemId The item's identification number. 
    function deactivateAuction(
        uint256 _itemId
    ) external isActive {

        // Call internal activate function.
        deactivate(_itemId);  
    }

    /// @notice Ends Auction.
    /// @param _itemId The item's identification number. 
    function endAuction(
        uint256 _itemId
    ) external isActive {
        
        // Call internal end function.
        end(_itemId);
    }

    /// @notice Allows bidders bid on items. 
    /// @param _itemId The item's identification number.
    function bidItem(
        uint256 _itemId
    ) external payable isActive {
        
        // Call internal bid function. 
        bid(_itemId);

        // Emit event SuccessfulBid. 
        emit SuccessfulBid(_itemId, msg.value, msg.sender);
    }

    /// @notice Allows bidder's Withdraw ETH.
    function withdrawMyETH(uint256 _ethAmount) external isActive {
        withdraw(_ethAmount);
    }

    /// @notice Allows Bidders claim items. 
    /// @param _itemId The item identification number.
    function claimMyItem(uint256 _itemId) external isActive {
        claim(_itemId);
    }

    /// @notice Returns auction data.
    /// @param _itemId The item's identification number. 
    /// @return AuctionStruct.ItemData ItemData Struct. 
    function getAuction(
        uint256 _itemId
    ) external view returns (
        AuctionStruct.ItemData memory) {

        return seller.itemsById[_itemId];
    }

    /// @notice Returns auction state as string. 
    /// @param _itemId The item's identification number.
    function getAuctionStateAsString(
        uint256 _itemId
    ) external view returns (
            string memory) {
        
        // Access the auction state of item ID. 
        AuctionTypes.AuctionState state = seller.itemState[_itemId];

        return AuctionTypes.auctionStateToString(state);
    }

    /// @notice Returns highestbidder's address.
    /// @param _itemId The item's identification number. 
    function getWinner(uint256 _itemId) external view returns(address){
       return seller.highestBidder[_itemId];
    }

    /// @notice Returns Item's total bids.
    /// @param _itemId The item's identification number. 
    function getItemBidCount(uint256 _itemId) external view returns(uint256) {
        return seller.bidRecord[_itemId];
    } 
}