# 🗳 VoterVault (Day 9 – 30 Days of Solidity)

A decentralized voting smart contract where:
- Only the contract owner can create proposals.
- Any user can register as a voter.
- Voters can vote once per proposal.
- Proposal data and voting status are tracked transparently on-chain.

---

## ✅ Features

- createAProposal(_title, _description, _proposalId): Owner creates a new proposal
- register(_firstName, _lastName): Register voter details
- vote(_title, _description, _proposalId): Vote once for a proposal
- getProposalData(_proposalId): View active proposal (by ID)
- getVoterStatus(address): Check voting status (onlyOwner)
- getMyStatus(): Check if the sender has voted
- getOwner(): Returns contract owner address

---

## 🧠 Concepts Practiced

- Struct: Grouping user and proposal data
- Mapping: For storing voter and proposal records
- Modifier: Restricting access to only owner
- Custom errors: Gas efficient error handling
- Event logs: For key user actions (register, vote, create)
- Timestamp: Tracking vote and proposal timing
- Private/public: Managing visibility correctly

---

## 📂 Files

- VoterVault.sol

---

## 🚀 Why This Matters

On-chain governance is a core use case in Web3.  
This project teaches **voting logic**, **data validation**, and **access control** — foundational concepts for DAOs and real-world governance apps.

---

🗓 Posted on: 8th of July, 2025  
🛠 Built on: 5th of July, 2025  

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
### ✅ Day 9 Completed!