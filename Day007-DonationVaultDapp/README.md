# 💰 DonationVaultDapp (Day 7 – 30 Days of Solidity)

A basic smart contract where:
- Users can deposit
- Users can view their donation 
- The contract owner can withdraw all and track total donation
- Includes access control using custom errors
- Emits events for deposits and withdrawals

---

### ✅ Features
- **depositETH():** Deposit ETH
- **getMyDepositHistory():** View personal donation history
- **getOwner():** View owner's address
- **withdrawAll():** Withdraw ETH (onlyOwner)
- **getTotalDeposit():** View total donation (onlyOwner)

---

### 📂 Files
- DonationVaultDapp.sol

---

### 🧠 Concepts Practiced
- `payable` functions
- `msg.value`, `.transfer`
- Custom Errors & gas optimization
- Access control via `modifier`
- `event` logs for state changes
- Smart contract structuring
- Best withdrawal practice
  + Use of .call{} for withdrawal

---
- **🗓 Posted on: 6th of July, 2025**
- **🛠 Built on: 4th of July, 2025**

---

## 📄 License

This project is licensed under the MIT License.  
Feel free to use, modify, and learn from it.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the *30 Days of Solidity Challenge*

---

### ✅ Day 7 Completed!