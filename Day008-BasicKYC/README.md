# 🪪 BasicKYC (Day 8 – 30 Days of Solidity)

A simple smart contract that simulates a basic Know Your Customer (KYC) registration flow.  
Users can register their identity (firstName, lastName, and wallet address), and only the contract owner can verify or manage users.  
It includes access control, events, mappings, custom errors, and gas-efficient patterns.

---

### ✅ Features

- register(_firstName, _lastName, _userAddress): Register a user with their identity details.
- getMyDetails(): Returns the caller's personal details.
- deleteMydata(): Delete user's data
- getUserDetail(address): View another user’s KYC details (onlyOwner).
- markAsVerified(address): Verify a user's identity (onlyOwner).
- checkIfVerified(): Check if the caller is verified.
- checkIfUserIsVerified(address): Check if a specific address is verified (onlyOwner).
- removeUserVerification(address): Unverify a user (onlyOwner).
- deleteUser(address): Delete a user's record (onlyOwner).
- getOwner(): Returns the contract owner's address.

---

### 🧠 Concepts Practiced

- struct for user data modeling
- mapping for state storage
- modifier for access control
- event logging
- Visibility best practices (view, private, public)
- Custom Errors for gas efficiency

---

### 📂 Files
- BasicKYC.sol

---

### 🚀 Why This Matters

KYC is a common requirement in DeFi and dApps.  
This project teaches how to handle **identity storage**, **verification logic**, and **privileged access control** using Solidity best practices.

---

- **🗓 Posted on:** 7th of July, 2025  
- **🛠 Built on:** 4th of July, 2025  

---

## 📄 License

This project is licensed under the MIT License.  
Feel free to use, learn from, and improve upon it.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the 30 Days of Solidity Challenge

---

### ✅ Day 8 Completed!