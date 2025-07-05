# 💼 SimpleBank (Day 6 – 30 Days of Solidity)

A basic smart contract simulating a simple bank where:
- Users can deposit and withdraw ETH
- Users can view their balance and total bank balance
- The contract owner can view any user's balance
- Includes access control using custom errors
- Emits events for deposits and withdrawals

---

### ✅ Features
- depositETH(): Deposit ETH
- withdrawETH(): Withdraw ETH
- getMyBalance(): View your balance
- getBankBalance(): View contract's ETH balance
- getUserBalance(address): View any user's balance (onlyOwner)
- getOwner(): View the owner's address

---

### 📂 Files
- SimpleBank.sol

---

### 🧠 Concepts Practiced
- `payable` functions
- `msg.value`, `.transfer`
- Custom Errors & gas optimization
- Access control via `modifier`
- `event` logs for state changes
- Smart contract structuring

---
- **🗓 Posted on: 5th of July, 2025**
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

### ✅ Day 6 Completed!