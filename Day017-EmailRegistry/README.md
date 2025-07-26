# 📧 EmailRegistry (Day 17 – 30 Days of Solidity)  
A decentralized on-chain identity registry for email-like records. Users can register, update, suspend, delete, and manage their profile records (including usernames and metadata) with full access control and lifecycle management.

---

## ✅ Features  
- *constructor()*: Sets the deployer as the contract owner.  
- *register(string _firstName, string _lastName, uint256 _dateOfBirth, string _userName)*: Registers a new email profile.  
- *updateEmail(uint256 _id, ...)*: Updates a user's email record (firstname, lastname, username, DOB).  
- *deleteMyEmail(uint256 _id, string _userName)*: Deletes the caller's email entry.  
- *suspendMyEmail(uint256 _id)*: Caller can suspend their own email.  
- *checkMyEmailStatus(uint256 _id)*: View your email’s current status.  
- *getMyEmail(uint256 _id)*: Returns a specific email record owned by caller.  
- *getAllMyEmail()*: Returns all email records associated with the caller.  
- *isContractActive()*: View if the contract is currently active.  
- *getOwner()*: View current contract owner.  
- *Admin Functions (owner-only):*  
  - *activateContract() / deactivateContract()*  
  - *transferOwnership(address)* / *renounceOwnership()*  
  - *activateCreatorEmail(address, id)* / *suspendCreatorEmail(...)* / *banCreatorEmail(...)*  
  - *getEmailById(id)* / *getCreatorEmails(address)*  
  - *deleteUserEmail(...) / deleteCreatorsUserName(...)*  

---

⚠ Important:
- Contract must be activated by owner to enable functionality.  
- Usernames are unique across the contract — only one user per userName.  
- Lifecycle states supported: Created, Active, Suspended, Banned.

---

## 🧠 Concepts Practiced  
- *Custom Errors*: Efficient gas usage and clearer debugging.  
- *Structs & Mappings*: Advanced use of nested data and multi-view retrieval.  
- *Email Lifecycle Management*: Controlled state changes using enums.  
- *Event Logging*: Detailed on-chain auditability via emitted logs.  
- *Ownership & Access Control*: Role-based function access via onlyOwner.  
- *Gas Optimization*: Efficient array deletion with swap-and-pop pattern.  
- *Fallback & Receive Functions*: Handles ETH deposits gracefully.

---

## 📂 Files  
- EmailRegistry.sol

---

### 🚀 Why This Matters  
Identity-based applications in Web3 often need decentralized storage of user records. This project simulates:

- On-chain email/user profile registration  
- Lifecycle control for user entries  
- Advanced data structuring and access restriction  
- Event-driven updates and secure username tracking  
- Admin tools for moderation or recovery (e.g., in DAO or platform contexts)

---

🗓 Posted on: July 26th, 2025.  
🛠 Built between: July 24th – July 26th, 2025.

---

### ⚙ Example Usage (Remix):  

✅ *Step 1*: Deploy Contract  
Compile and deploy EmailRegistry.sol on Remix.  
Call activateContract() to enable core features.

✅ *Step 2*: Register Email  
```solidity
register("Jane", "Doe", 20010415, "jane123")
```

✅ *Step 3*: View My Email  
```solidity
getMyEmail(1)
```

✅ *Step 4*: Update Email  
```solidity
updateEmail(
  1,
  "Janet",
  "Doe",
  20010415,
  "janetUpdated"
)
```

✅ *Step 5*: Suspend or Delete Email  
```solidity
suspendMyEmail(1)
deleteMyEmail(1, "janetUpdated")
```

✅ *Step 6*: Admin Actions  
```solidity
activateCreatorEmail(userAddress, 1)
deleteUserEmail(userAddress, 1, "janetUpdated")
```

---

## 🛠 Tools Used  
- *Language*: Solidity ^0.8.18  
- *IDE*: [Remix](https://remix.ethereum.org/) + Visual Studio Code  
- *Version Control*: Git + GitHub (SSH)

---

## 📄 License  
MIT License – Free to use, learn, and build on top of.

---

## ✍ Author 

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the 30 Days of Solidity Challenge.

---
### 🙏 Please give credit if this inspired your learning journey.

---
### ✅ Day 17 Completed!

---