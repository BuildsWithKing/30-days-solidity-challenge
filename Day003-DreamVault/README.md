## 🚀 DreamVault

A basic smart contract that allows users to store, view, update, and delete their personal dreams (goals or aspirations). Each dream includes a **title**, **description**, and a **timestamp**. The contract also allows the **owner** (deployer) to view any user's submitted dream.

---

## 📦 Features

- **Struct** – Groups user data: title, description, and timestamp.
- **Mapping** – Maps each user's address to their dream.
- **Functions**:
  - Store a dream
  - View own dream
  - Update dream
  - Delete dream
  - View dream by address (onlyOwner)
  - Retrieve owner's address
  - Retrieve dreamer by index (onlyOwner)
  - Retrieve all dreamers (onlyOwner)

- **Constructor** – Sets the contract deployer as the owner.
- **Modifier** – Restricts special functions to only the contract owner.

---

## 📁 Contract File

- `DreamVault.sol`

---

## 🛠 Tools Used

- **Language**: Solidity `^0.8.18`
- **IDE**: [Remix](https://remix.ethereum.org/) & Visual Studio Code
- **Version Control**: Git + GitHub (SSH)
- **Testing/Deployment**: Foundry (in later phases)

---

## 📄 License

This project is licensed under the MIT License. Feel free to use, modify, and learn from it.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the **30 Days of Solidity Challenge**.

---
