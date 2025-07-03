## 🚀 ToDoList

A basic smart contract that allows users to add, view, update, and delete their tasks. Each task includes a **title**, **status** (completed/not completed), and a **timestamp**.

---

## 📦 Features

- **Struct** – Groups user data: title, status, and timestamp.
- **Mapping** – Maps each user's address to their Tasks[].
- **Functions**:
  - Add tasks
  - Get own tasks
  - Mark task as done
  - Update task
  - Delete task at an index
  - Delete all tasks
  - Get task at an index
  - Get task count
  - Retrieve owner's address
- **Custom Error** - Reverts EMPTYTASK().
- **Constructor** – Sets the contract deployer as the owner.
- **Modifier** – Restricts special functions to only the contract owner.

---

## 📁 Contract File

- `ToDoList.sol`

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