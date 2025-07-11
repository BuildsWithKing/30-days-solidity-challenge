# 📇 ContactBook (Day 12 – 30 Days of Solidity)

A decentralized smart contract that allows users to securely store, access, and delete their contact information.

---

## ✅ Features

- **constructor():** Sets contract deployer as owner.
- **addContact(string memory _firstName, string memory _lastName, uint256 _mobileNo, string memory _emailAddress):** Adds a new contact (no duplicates).
- **getMyContacts():** View all caller’s contacts.
- **getMyContactCount():** View number of contacts stored by the caller.
- **deleteContact(uint256 _contactIndex):** Deletes a contact from caller’s address.
- **getOwner():** View contract deployer’s address.
- **deleteUserContact(address _userAddress, uint256 _contactIndex):** Allows owner to delete any user’s contact.
- **getUserContacts(address _userAddress):** Allows owner to retrieve any user's contact list.

> ✍ **Note**: updateContact() will be added in future upgrades — this version focuses on core CRUD logic first.

---

## 🧠 Concepts Practiced

- *Structs*: Groups contact details (name, email, mobileNo, etc.).
- *Mappings*: Links user addresses with dynamic contact arrays.
- *Access Control*: onlyOwner modifier for admin-only operations.
- *Custom Errors*: Gas-optimized error handling.
- *For Loops*: Used to enforce unique mobile numbers and delete contact by index.
- *Events*: Logged when a contact is added or deleted.
- *Storage vs Memory*: Managed contact info via storage arrays.

---

## 📂 Files

- ContactBook.sol

---

## 🚀 Why This Matters

Storing user data like contact information teaches how to:
- Handle dynamic arrays with mappings.
- Use for loops efficiently.
- Securely manage user-owned data.
- Implement clean and gas-efficient error and access control.

---

🗓 *Posted on*: July 11, 2025  
🛠 *Built on*: July 9, 2025  

---

## 🛠 Tools Used

- Language: Solidity `^0.8.18`
- IDE: [Remix](https://remix.ethereum.org/) + Visual Studio Code
- Version Control: Git + GitHub (SSH)

---

## 📄 License

MIT License – feel free to learn, build, and remix.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the [30 Days of Solidity Challenge](https://github.com/BuildsWithKing/30-days-solidity-challenge)

---

### 🙏 Kindly give credit if this helped you learn.

---

## ✅ Day 12 Completed!