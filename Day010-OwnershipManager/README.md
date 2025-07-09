# 🔐 OwnershipManager (Day 10 – 30 Days of Solidity)

A decentralized smart contract that uses the onlyOwner pattern to:

- Assign ownership
- Transfer control
- Restrict access to sensitive functions

🧠 This contract is foundational for secure smart contract systems — powering admin controls, DAO management, and upgradable protocols.

---

## ✅ Features
- **constructor()**: Sets the contract deployer as the owner
- **transferOwnership(address _newOwnerAddress)**: Only current owner can transfer ownership to a new address
- **renounceOwnership()**: Allows the owner to give up ownership permanently.
- **changeOwnerData(string memory)**: Allows the owner to update their personal data (first name, last name)
- **getOwner()**: Gets current owner's address
- **getOwnerData()**: Gets current owner's data
- **getContractSummary()**: Gets contract summary

---

## 🧠 Concepts Practiced

- Mapping: For storing owner address and their data
- Modifier: Restricting access to only owner
- Custom errors: Gas efficient error handling
- Event logs: For key owner actions (transferOwnership(), renounceOwnership(), changeOwnerData()).
- Block timestamp: Records when the owner data was last updated (useful for audit/logging)
- Private/public: Managing visibility correctly

---

## 📂 Files

- OwnershipManager.sol

---

## 🚀 Why This Matters

This is foundational for upgradable contracts, DAOs, and security access control.

---

🗓 Posted on: 9th of July, 2025  
🛠 Built on: 7th of July, 2025  

---

## 🛠 Refactor Notes

- ownerData is empty by default; call changeOwnerData() to populate it.
- Future improvements: auto-init owner data in constructor, support multiple owners.

---

## 📄 License

MIT License – Feel free to learn, build, and remix.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the [30 Days of Solidity Challenge](https://github.com/BuildsWithKing/30-days-solidity-challenge)

---
### 🙏 If you find this project helpful, kindly give credit.

---
### ✅ Day 10 Completed!