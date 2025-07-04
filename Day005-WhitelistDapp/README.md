# 🔐 WhitelistDapp (Day 5 – 30 Days of Solidity)

This is a basic whitelist smart contract where:
- Any user can opt-in to be whitelisted
- Only the contract deployer (owner) can remove users
- Tracks total number of whitelisted users
- Includes access control using custom errors

---

### ✅ Features
- `joinWhitelist()`: Join the whitelist
- `checkIfWhitelisted()`: Check your status
- `checkIfUserIsWhitelisted(address)`: Check status of others
- `deleteAddress(address)`: Owner-only address removal
- Custom errors used for gas optimization

---

### 🚀 What's New?
I wrote the first version on **July 3, 2025** (see OldVersion.sol) and improved it on **4th of July, 2025** by:
- Replacing string require with custom error modifiers
- Improving naming conventions
- Writing cleaner, modular code

---

### 📂 Files
- WhitelistDapp.sol: ✅ Final upgraded version
- OldVersion.sol: 🕰 Previous version (for learning comparison)

---

### 🧠 Concepts Practiced
- Mappings
- Access Control
- Custom Errors
- Constructor
- Modifiers
- Gas optimization with unchecked

---
## 📄 License

This project is licensed under the MIT License. Feel free to use, modify, and learn from it.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the **30 Days of Solidity Challenge**.

---
### 🧠 My Thoughts

This project helped me understand access control and how to use mappings effectively. I also learned how to optimize gas with custom errors and unchecked.

---
### 💡 Day 5 Completed!