# 💡 ProjectIdeaStorage (Day 11 – 30 Days of Solidity)

A decentralized smart contract where users can submit and retrieve project ideas (like a web3 "idea Vault"). Perfect for startups, hackathon ideas, or anyone who wants to store and share ideas transparently on-chain.

---

## ✅ Features

- `constructor()`: Sets contract deployer as owner.
- `addIdea(string memory _title, string memory _description, bool _isPublic)`: Adds user's idea.
- `getMyIdeas()`: View caller's ideas.
- `getUserPublicIdeas(address _userAddress)`: View all caller's public ideas.
- `deleteIdea(uint256 _indexNo)`: Deletes user's idea.
- `getOwner()`: View owner's address
- `getMyIdeaCount()`: View caller's idea count
- `deleteUserIdea(address _userAddress, uint256 _indexNo)`: Only owner can delete user's idea
- `getUserIdeaCount(address _userAddress)`: Only owner can view user's idea count
   
---

## 🧠 Concepts Practiced

- **Mapping:** For storing user's address and their ideas.
- **Modifier:** Restricting access to only owner
- **Custom errors:** Gas efficient error handling
- **Event logs:** For key owner actions (IdeaAdded(), IdeaDeleted()).
- **Block timestamp:** Records when the user's Idea was last updated (useful for audit/logging)
- **Private/public:** Managing visibility correctly
---

## 📂 Files

- ProjectIdeaStorage.sol

---

## 🚀 Why This Matters

This is important in understanding how contents are stored on storage, accessed through memory using for loop (looping through the array), deleted on the storage using for loop, if index number is invalid it reverts the custom error __PROJECTIDEASTORAGE_INVALIDINDEX().

---

🗓 **Posted on**:  July 10, 2025
🛠 **Built on**: July 7, 2025  

---

## 🛠Tools used:
- Language: Solidity ^0.8.18
- IDE: [Remix](http://remix.ethereum.org) & Visual Studio Code
- Version Control: Git + GitHub (SSH)

## 📄 License

MIT License – feel free to learn, build, and remix.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the [30 Days of Solidity Challenge](https://github.com/BuildsWithKing/30-days-solidity-challenge)

---

### 🙏 If you find this project helpful, kindly give credit.

---

## ✅ Day 11 Completed!