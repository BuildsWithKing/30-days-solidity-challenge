# 🧾 NFTVault (Day 13 – 30 Days of Solidity)

A decentralized smart contract that enables users to **store**, **update**, **access**, and **delete** information about their NFTs, such as name, description, token ID, and contract address.

---

## ✅ Features

- **constructor():** Sets contract deployer as the owner.
- **storeNFT(string _name, string _description, string _imageUrl, uint256 _nftId, address _contractAddress):** Stores a new NFT for the caller. Prevents duplicate nftIds for each user.
- **getMyNFTs():** View all NFTs stored by the caller.
- **getMyNFTAtIndex(uint256 _nftIndex):** Retrieve a specific NFT by index from the caller’s records.
- **getMyTotalNFTs():** View the total number of NFTs stored by the caller.
- **updateNFT(uint256 _nftIndex, string _name, string _description, string _imageUrl, uint256 _nftId, address _contractAddress):** Updates a stored NFT at a given index.
- **deleteNFT(uint256 _nftIndex):** Deletes an NFT from the caller’s record.
- **getOwner():** View contract deployer’s address.
- **getUserNFTs(address _userAddress):** Allows the owner to view any user's NFT list.
- **getUserNFTAtIndex(address _userAddress, uint256 _nftIndex):** Allows the owner to retrieve an NFT by index from any user.
- **getUserTotalNFTs(address _userAddress):** Allows the owner to view the total NFTs stored by any user.
- **deleteUserNFT(address _userAddress, uint256 _nftIndex):** Allows the owner to delete any user’s NFT.

> ✍ **Note**: Future upgrades may include batch uploads, IPFS integration, and metadata validation for enhanced NFT management.

---

## 🧠 Concepts Practiced

- *Structs:* Encapsulates NFT properties (name, id, description, etc.).
- *Mappings:* Stores an array of NFTs per user.
- *Access Control:* onlyOwner modifier ensures admin-level functions are protected.
- *Custom Errors:* Uses named errors for gas savings and clarity.
- *For Loops:* Prevents duplicate nftId and performs array deletions.
- *Events:* Logs when NFTs are stored, updated, or deleted.
- *Storage vs Memory:* Efficient handling of data arrays for NFT records.

---

## 📂 Files

- NFTVault.sol

---

## 🚀 Why This Matters

Managing NFT data mimics real-world NFT dApps. This teaches how to:
- Store structured token metadata securely.
- Perform CRUD operations with index management.
- Restrict access to sensitive operations.
- Handle dynamic arrays in Solidity with efficiency and safety.

---

🗓 Posted on: July 12, 2025  
🛠 Built on: July 10, 2025  

---

## 🛠 Tools Used

- Language: Solidity `^0.8.18`
- IDE: [Remix](https://remix.ethereum.org/) + Visual Studio Code  
- Version Control: Git + GitHub (SSH)

---

## 📄 License

MIT License – feel free to learn, build, remix, and share.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the [30 Days of Solidity Challenge](https://github.com/BuildsWithKing/30-days-solidity-challenge)

---

### 🙏 Kindly give credit if this helped you learn.

---

## ✅ Day 13 Completed!