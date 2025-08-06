// SPDX-License-Identifier: MIT

/// @title AuctionHub (AuctionHub file for SimpleAuction contract). 
/// @author Michealking (@BuildsWithKing)
/// @custom: security-contact buildswithking@gmail.com
/// @date Created: 2nd of August, 2025. 

/** @notice Allows sellers list items for Auction, Update item list. 
    Control item lifeCycle and Delete item. 
*/

pragma solidity ^0.8.18; 

/// @notice Imports Utils file. 
import {Utils} from "./Utils.sol";

/// @notice Imports AuctionLib file.
import {AuctionLib} from "./Libraries/AuctionLib.sol";

/// @notice Imports AuctionTypes file. 
import {AuctionTypes} from "./Libraries/AuctionTypes.sol";

/// @notice Imports AuctionStruct file.
import {AuctionStruct} from "./Structs/AuctionStruct.sol";

/// @dev Thrown when seller tries to sell zero item. 
error SIMPLEAUCTION_QUANTITY_CANT_BE_ZERO();

/// @dev Thrown when seller tries to sell item with no starting price. 
error SIMPLEAUCTION_STARTING_PRICE_CANT_BE_ZERO();

/// @dev Thrown when a seller tries to update another seller's item. 
error __SIMPLEAUCTION_ACCESS_DENIED();

/// @dev Thrown when a seller tries to activate wrong itemID. 
error __SIMPLEAUCTION_INVALID_ITEMID();

contract AuctionHub is Utils {

    /// @notice Used ItemData from AuctionStruct. 
    using AuctionStruct for AuctionStruct.ItemData;

    /// @notice Used auctionData from AuctionLib. 
    using AuctionLib for AuctionLib.AuctionData;

    /// @notice Records Number of items. 
    uint256 public itemCount;

    /// @notice Seller assigned to AuctionLib.AuctionData for easy access. 
    AuctionLib.AuctionData internal seller;

    /// @notice Emits ItemRegistered. 
    /// @param sellerAddress Seller's address.
    /// @param itemId item identification number. 
    /// @param itemTitle Item's title.
    /// @param itemQuantity Item's quantity. 
    event ItemRegistered(address indexed sellerAddress, uint256 itemId, string itemTitle, uint256 indexed itemQuantity);

    /// @notice Emits ItemUpdated.
    /// @param sellerAddress The seller's address
    /// @param itemId The item identification number.
    /// @param newTitle The item's new title.
    /// @param newQuantity The item's new quantity.
    event ItemUpdated(address indexed sellerAddress, uint256 itemId, string newTitle, uint256 indexed newQuantity);

    /// @notice Emits ItemDeleted.
    /// @param itemId The item identification number.
    /// @param sellerAddress Thr seller's address. 
    event ItemDeleted(uint256 indexed itemId, address indexed sellerAddress);

     /// @notice Emits AuctionActivated.
    /// @param itemId The item identification number.
    /// @param sellerAddress Thr seller's address. 
    event AuctionActivated(uint256 indexed itemId, address indexed sellerAddress);

    /// @notice Emits AuctionDeactivated.
    /// @param itemId The item identification number.
    /// @param sellerAddress Thr seller's address. 
    event AuctionDeactivated(uint256 indexed itemId, address indexed sellerAddress); 

    /// @notice Emits AuctionEnded.
    /// @param itemId The item identification number.
    /// @param sellerAddress Thr seller's address. 
    event AuctionEnded(uint256 indexed itemId, address indexed sellerAddress);

    /// @notice Emits AuctionCancelled.
    /// @param itemId The item identification number.
    /// @param sellerAddress Thr seller's address. 
    event AuctionCancelled(uint256 indexed itemId, address indexed sellerAddress);

    /// @notice Reverts if not item owner. 
    modifier itemOwner(uint256 _itemId) {

        // Deny access if not item owner. 
        if(msg.sender != seller.itemsById[_itemId].owner) 
        revert __SIMPLEAUCTION_ACCESS_DENIED();
        _;
    }

    /// @notice Allows sellers register items for auction.
    /// @param _title The Item's title. 
    /// @param _description A brief description of the item.
    /// @param _itemType The item's type. 
    /// @param _quantity Number of items available for auction.
    /// @param _startingPrice Initial price set by the seller.  
    /// @param _endsAt Auction's end time. 
    function register(
        string memory _title, 
        string memory _description,
        string memory _itemType,  
        uint256 _quantity,
        uint256 _startingPrice, 
        uint256 _endsAt
    )internal isActive {

        // Ensure quantity is greater than zero. 
        if(_quantity <= 0) revert SIMPLEAUCTION_QUANTITY_CANT_BE_ZERO();
        
        // Ensure starting price is greater than zero.   
        if(_startingPrice <= 0) revert SIMPLEAUCTION_STARTING_PRICE_CANT_BE_ZERO();

        // Generate a new item ID.  
        itemCount++;
        uint256 _itemId = itemCount;

        // Create the item data struct.  
        AuctionStruct.ItemData memory itemData = AuctionStruct.ItemData ({ 
        itemId: _itemId,
        title: _title,
        description: _description,
        itemType: _itemType,
        quantity: _quantity,
        startingPrice: _startingPrice,
        listedAt: block.timestamp,
        endsAt: _endsAt,
        owner: msg.sender
        });

        // Push to seller's item array. 
        seller.sellerInfo[msg.sender].push(itemData);

        // Store seller's item. 
        seller.itemsById[_itemId] = itemData;

        // Emit event for new item. 
        emit ItemRegistered(msg.sender, _itemId, _title, _quantity);
    }

     /// @notice Allows Sellers update items.
     /// @param _itemId The item's identification number. 
    /// @param _newTitle Item's new title. 
    /// @param _newDescription A brief description of the item. 
    /// @param _newItemType The Item's new Type.
    /// @param _newQuantity Number of items available for auction.
    /// @param _newStartingPrice Initial price set by the seller.
    /// @param _newEndsAt Auction's new end time. 
    function update(
        uint256 _itemId,
        string memory _newTitle,
        string memory _newDescription,
        string memory _newItemType, 
        uint256 _newQuantity, 
        uint256 _newStartingPrice,
        uint256 _newEndsAt
    ) internal isActive itemOwner(_itemId) {
       
        // Ensure quantity is greater than zero.
        if(_newQuantity <= 0) revert SIMPLEAUCTION_QUANTITY_CANT_BE_ZERO();
        
        // Ensure starting price is greater than zero.
        if(_newStartingPrice <= 0) revert SIMPLEAUCTION_STARTING_PRICE_CANT_BE_ZERO();

        // Access seller's item by item Id. 
        AuctionStruct.ItemData storage newItemData = seller.itemsById[_itemId];

        // Update seller's item data. 
        newItemData.title =  _newTitle; 
        newItemData.description = _newDescription;
        newItemData.itemType = _newItemType;
        newItemData.quantity = _newQuantity; 
        newItemData.startingPrice = _newStartingPrice;
        newItemData.listedAt = block.timestamp;
        newItemData.endsAt = _newEndsAt;

         // Update seller's item. 
        seller.itemsById[_itemId] = newItemData;

        // Emit event for updated item. 
        emit ItemUpdated(msg.sender, _itemId, _newTitle, _newQuantity);
    }

    /// @notice Deletes seller's item. 
    /// @param _itemId The The item's identification number. 
    function deleteItem(
    uint256 _itemId
    ) internal isActive itemOwner(_itemId) {

        // Delete item from seller's itemById. 
        delete seller.itemsById[_itemId];

        //Access seller's info
        AuctionStruct.ItemData[] storage itemData = seller.sellerInfo[msg.sender];

        // Delete itemId from seller's item array. 
        for(uint256 i = 0; i < itemData.length; i++) {
            if(itemData[i].itemId == _itemId) {
                itemData[i] = itemData[itemData.length -1];
                // Remove the last duplicate item after shifting.  
                itemData.pop(); 

            // Delete one from item count. 
            unchecked {
                itemCount--;
            }
            } 
        }

        // Emit event for deleted item. 
        emit ItemDeleted(_itemId, msg.sender);

        return;
    } 

    /// @notice Activates Auction.
    /// @param _itemId The item's identification number. 
    function activate(
    uint256 _itemId
    ) internal isActive itemOwner(_itemId) {

        // Activate item state. 
        seller.itemState[_itemId] = AuctionTypes.AuctionState.Active;

        // Emit event auction activated. 
        emit AuctionActivated(_itemId, msg.sender);
    }

    /// @notice Deactivates Auction.
    /// @param _itemId The item's identification number. 
    function deactivate(
    uint256 _itemId
    ) internal isActive itemOwner(_itemId) {

        // Deactiavate item state.
        seller.itemState[_itemId] = AuctionTypes.AuctionState.NotActive;

        // Emit event auction deactivated. 
        emit AuctionDeactivated(_itemId, msg.sender);
    }

    /// @notice Ends Auction.
    /// @param _itemId The item's identification number. 
    function end(
    uint256 _itemId
    ) internal isActive itemOwner(_itemId) {

        // Deactiavate item state.
        seller.itemState[_itemId] = AuctionTypes.AuctionState.Ended;

        // Emit event auction ended. 
        emit AuctionEnded(_itemId, msg.sender);
    }

    /// @notice Cancels Auction.
    /// @param _itemId The item's identification number. 
    function cancelAuction(
        uint256 _itemId
    ) internal isActive itemOwner(_itemId) {

        // Cancels item state.
        seller.itemState[_itemId] = AuctionTypes.AuctionState.Cancelled;

        // Emit event auction ended. 
        emit AuctionCancelled(_itemId, msg.sender);
    }
}