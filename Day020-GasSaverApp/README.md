# ⛽🔥 OptimizedGasSaver (Day 20 – 30 Days of Solidity)

A gas-optimized smart contract that allows users to register, update, view, and delete their personal data securely using struct and mapping. Built entirely from scratch as part of *Day 20* of the [#30DaysOfSolidityChallenge](https://github.com/BuildsWithKing/30-days-solidity-challenge).

---

## 📌 Project Summary

- *Contract Name:* OptimizedGasSaver
- *Language:* Solidity ^0.8.18
- *Tooling:* [Foundry](https://getfoundry.sh/)
- *License:* MIT
- *Author:* [MichealKing (BuildsWithKing)](https://github.com/BuildsWithKing)
- *Day:* 20 / 30
- *Testing:* 96.77% test coverage achieved
- *Optimization:* Focused on gas efficiency via bytes32 instead of string, and minimal data operations

---

## 🔧 Core Features

| Feature        | Description                                                           |
|----------------|-----------------------------------------------------------------------|
| Register       | Users can register with their first, middle, last name and age        |
| View Data      | Each user can retrieve their own saved information                    |
| Update         | Users can securely update their personal data                         |
| Delete         | Account data can be permanently deleted by the user                   |
| Gas Optimization | Uses bytes32 instead of string to reduce gas consumption            |
| Access Control | Only registered users can update or delete their own records          |

---

## 📦 Contracts

| File Name                     | Description                              |
|------------------------------|------------------------------------------|
| OptimizedGasSaver.sol      | Main gas-optimized smart contract logic  |
| UnoptimizedGasSaver.sol    | A less efficient version (for comparison)|
| OptimizedGasSaver.t.sol    | Full Foundry test suite (96.77% coverage)|

---

## 🧪 Test Coverage

- Total test cases: ✅ Pass
- Total functions tested: register, getMyData, update, delete
- Achieved: *96.77% test coverage*
![alt text](<WhatsApp Image 2025-08-07 at 16.06.06_3712236c.jpg>)


```bash
forge coverage
```

---

## 🧠 Learning Focus (Day 20)

Using bytes32 instead of string to optimize gas

Efficient struct handling within mappings

Advanced Foundry testing techniques

Writing clean, modular, and readable smart contracts

Comparing optimized vs unoptimized contract performance


---
```
📂 Repo Structure

OptimizedGasSaver/
├── src/
│   ├── OptimizedGasSaver.sol
│   └── UnoptimizedGasSaver.sol
├── test/
│   └── OptimizedGasSaverTest.t.sol
├── README.md

```

---

📌 Deployment & Usage

Not yet deployed to a live testnet.

To run locally:
```
forge test

```
---

## ⚠ License

This project is licensed under the MIT License.
Feel free to fork and contribute.


---

## 👑 Built by

MichealKing (@BuildsWithKing)
Solidity Developer | Builder | #30DaysOfSolidityChallenge


---

## 🏁 Day 20 Completed!