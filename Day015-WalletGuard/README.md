# 🔐 WalletGuard (Day 15 – 30 Days of Solidity)

A security-focused smart contract that enables users to **whitelist trusted wallet addresses**, **block unknown interactions**, and **pause wallet activity** when threats are detected.

---

## ✅ Features

- **constructor():** Sets the contract deployer as the owner.
- **register(string _firstName, string _lastName, address _userAddress):** Registers a user (only once).
- **whitelistAddress(address _safeAddress):** Stores a trusted address for the user.
- **updateWhitelistedAddress(uint256 _index, address _newSafeAddress):** Allows users to update their safe address.
- **getMyWhitelistedAddress():** View the list of safe addresses.
- **sendETHToWhitelisted(address _userAddress):** Owner-only function to send ETH to a user's whitelisted address.
- **activateContract():** Turns on all core features.
- **deactivateContract():** Turns off all core features.
- **receive() / fallback():** Emits an event when ETH is sent directly or with unknown calldata.

> 🔐 Contract must be activated before usage.

---

## 🧠 Concepts Practiced

- *Custom Errors:* Efficient gas-friendly error handling.
- *Mappings & Structs:* Secure data storage per user.
- *Modifiers:* Restrict access and control contract state.
- *Access Control:* Only owner can activate/deactivate or send ETH.
- *Event Emissions:* For tracking suspicious and valid ETH flows.
- *ETH Transfer Handling:* Uses .call() with full failure check.

---

## 📂 Files

- WalletGuard.sol

---

## 🚀 Why This Matters

In a Web3 world full of wallet hacks, phishing, and malicious smart contract calls, building a *protective layer* over user interactions is essential. This teaches how to:

- Track and store user info securely.
- Create allowlists (whitelists).
- Block interactions and flag suspicious ETH behavior.
- Design for pause/resume security.

---

🗓 Posted on: July 14, 2025  
🛠 Built on: July 12, 2025  

---

## 🛠 Tools Used

- Language: Solidity ^0.8.18
- IDE: [Remix](https://remix.ethereum.org/) + Visual Studio Code  
- Version Control: Git + GitHub (SSH)

---

## 📄 License

MIT License – feel free to learn, remix, and build with it.

---

## ✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the [30 Days of Solidity Challenge](https://github.com/BuildsWithKing/30-days-solidity-challenge)

---

🙏 Kindly give credit if this inspired your learning journey.

---

## ✅ Day 15 Completed!