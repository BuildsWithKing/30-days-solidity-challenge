// SPDX-License-Identifier: MIT

/// @title NFTVault
/// @author Michealking (@BuildsWithKing)
/// @date created 10th of July, 2025

/// @notice Users can store, access and delete info about their owned NFTs (name, tokenId, and contract address) 

pragma solidity ^0.8.18;

error __NFTVAULT_UNAUTHORIZED_ACCESS(); // Reverts `__NFTVAULT_UNAUTHORIZEDACCESS`
error __NFTVAULT_EXISTING_NFT_ID(); // Reverts `__NFTVAULT_EXISTINGNFTID`
error __NFTVAULT_INVALID_INDEX(); // Reverts `__NFTVAULT_INVALIDINDEX`


contract NFTVault {

    address immutable i_owner; // contract deployer's address
    uint256 public totalNFTs; // Records total NFTs
    uint256 public totalUpdatedNFTs; // Records Updated NFTs

    // Groups NFT's info
    struct NFT {
        string name;
        string description;
        string imageUrl;
        uint256 nftId;
        address contractAddress;
        uint256 timestamp;
    }

    mapping(address => NFT[]) internal nftsInfo; // Links user address to their NFTs (internal used for extensibility)

    event NftStored (string indexed name, uint256 indexed nftId, address indexed contractAddress, address userAddress);// Emits NftStored
    event NftUpdated (uint256 nftIndex, string indexed name, uint256 indexed nftId, address indexed contractAddress); // Emits NftUpdated
    event NftDeleted (uint256 indexed nftIndex, address indexed userAddress); // Emits NftDeleted

    // Sets owner as the contract deployer
    constructor () {
        i_owner = msg.sender;
    }

    // Restricts access to contract deployer
    modifier onlyOwner () {
        if(i_owner != msg.sender) revert __NFTVAULT_UNAUTHORIZED_ACCESS();
        _;
    }

    /// @notice Store a new NFT for the caller
    /// @param _name Name of the NFT
    /// @param _description NFT brief info
    /// @param _nftId Token ID of the NFT
    /// @param _contractAddress Address of the NFT's contract
    function storeNFT(string memory _name, string memory _description, string memory _imageUrl,
    uint256 _nftId, address _contractAddress) public {

        NFT[] storage nft = nftsInfo[msg.sender];

        for(uint256 i = 0; i < nft.length; i++) {
           if(nft[i].nftId == _nftId) revert __NFTVAULT_EXISTING_NFT_ID();
        }    

        NFT memory newNft = NFT(_name, _description, _imageUrl, _nftId, _contractAddress, block.timestamp);
        nftsInfo[msg.sender].push(newNft);
    
        emit NftStored(_name, _nftId, _contractAddress, msg.sender);
        totalNFTs++;
        }

    /// @notice Returns the user's stored NFTs
    /// @return Array of NFTs stored by the caller
    function getMyNFTs() public view returns (NFT[] memory) {
        return nftsInfo[msg.sender];
    }

    /// @notice Returns the user's NFT at the index
    /// @return NFT stored by the caller
    function getMyNFTAtIndex(uint256 _nftIndex) public view returns (NFT memory) {
        NFT[] memory nft = nftsInfo[msg.sender];
        if(_nftIndex >= nft.length) revert __NFTVAULT_INVALID_INDEX();
        return nftsInfo[msg.sender][_nftIndex];
    }

    /// @notice Updates a new NFT for the caller
    /// @param _nftIndex Index position of the nft
    /// @param _name Name of the NFT
    /// @param _description NFT brief info
    /// @param _nftId Token ID of the NFT
    /// @param _contractAddress Address of the NFT's contract
    function updateNFT(uint256 _nftIndex, string memory _name, string memory _description, string memory _imageUrl, 
    uint256 _nftId, address _contractAddress) public {
        NFT[] storage nft = nftsInfo[msg.sender];

          for(uint256 i = 0; i < nft.length; i++) {
            if(nft[i].nftId == _nftId) revert __NFTVAULT_EXISTING_NFT_ID();
        } 

        NFT memory updatedNft = NFT(_name, _description, _imageUrl, _nftId, _contractAddress, block.timestamp);
        nft[_nftIndex] = updatedNft;

       emit NftUpdated(_nftIndex, _name, _nftId, _contractAddress);   
       totalUpdatedNFTs++; 
    }

    // Deletes user NFTs
    function deleteNFT(uint256 _nftIndex) public {
        NFT[] storage nft = nftsInfo[msg.sender]; 
        if(_nftIndex >= nft.length) revert __NFTVAULT_INVALID_INDEX();

        for(uint256 i =_nftIndex; i < nft.length - 1; i++) {
            nft[i] = nft[i + 1]; 
        }

        nft.pop(); // Removes the last duplicate element after shifting
        emit NftDeleted(_nftIndex, msg.sender);
    }
    
    // Gets owner's address
    function getOwner() public view returns (address) {
        return i_owner;
    }

    // Returns the number of NFTs stored by the caller
    function getMyTotalNfts() public view returns (uint256) {
        return nftsInfo[msg.sender].length;
    }
    
    // Only owner can get users NFTs
    function getUserNFTs(address _userAddress) public onlyOwner view returns(NFT[] memory) {
        return nftsInfo[_userAddress];
    } 

    // Only owner can get Users NFT at index
    function getUserNFTAtIndex(address _userAddress, uint256 _nftIndex) public onlyOwner view returns(NFT memory) {
        NFT [] memory nft = nftsInfo[_userAddress];
        if(_nftIndex >= nft.length) revert __NFTVAULT_INVALID_INDEX();
        return nftsInfo[_userAddress][_nftIndex];
    }

    // Only owner can get users total NFTs
    function getUserTotalNfts(address _userAddress) public onlyOwner view returns (uint256) {
        return nftsInfo[_userAddress].length;
    }

    // Only Owner can delete users NFTs
    function deleteUserNFT(address _userAddress, uint256 _nftIndex) public onlyOwner {
        NFT[] storage nft = nftsInfo[_userAddress];
        if (_nftIndex >= nft.length) revert __NFTVAULT_INVALID_INDEX();

        for(uint256 i = _nftIndex; i < nft.length - 1; i++) {
            nft[i] = nft[i + 1];
        }
        nft.pop(); // Removes the last duplicate element after shifting
        emit NftDeleted(_nftIndex, _userAddress);
    }
}