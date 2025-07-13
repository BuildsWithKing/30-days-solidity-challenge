# 🧑‍🤝‍🧑🧑‍🤝‍🧑 ReferralSystem (Day 14 – 30 Days of Solidity)

A smart contract that allows users to **register**, **link referrers**, **track referrals**, and **get funded** by the contract owner. Each user can only be referred once, and referral history is recorded per user. Built with custom errors, ETH handling, and solid access control.

---

## ✅ Features

- **constructor():** Sets contract deployer as immutable owner.
- **register(string _firstName, string _lastName, string _emailAddress):** Registers a new user and stores profile.
- **updateMyData(string _firstName, string _lastName, string _emailAddress):** Updates caller’s stored data.
- **referralAddressOptional(address _referrerAddress):** Links a referrer to the caller. Valid only once.
- **getMyData():** Returns caller’s profile data.
- **getReferrer():** Returns address that referred the caller.
- **getMyReferrals():** Lists all addresses referred by the caller.
- **getMyTotalReferrals():** Returns count of referrals made by caller.
- **getOwner():** Returns the contract owner.
- **fundUser(address _userAddress):** Sends ETH to a user (onlyOwner).
- **getUserData(address _userAddress):** Owner can view any user's data.
- **getUserReferrals(address _userAddress):** Owner can view any user's referral list.
- **getAllReferralStats();** Owner can get refferal stats.
- **receive() / fallback():** Emits logs when ETH is sent directly or with unknown calldata.

> ✍ **Note:** This contract supports future reward logic and tiered referral systems.

---

## 🧠 Concepts Practiced

- Structs: Store personal user info like name and email.
- Mappings: Track referrer relationships and referred users.
- Modifiers: Protect sensitive logic with onlyOwner.
- Custom Errors: Save gas and improve clarity (e.g., re-referral, invalid address).
- Events: Emit logs on registration, funding, and referrals.
- Fallback & Receive: Handle ETH with calldata or direct deposits.

---

## 📂 Files

- ReferralSystem.sol

---

## 🚀 Why This Matters

Referral systems are key in many dApps and onboarding flows. This teaches how to:
- Build trusted relationships between accounts.
- Handle referral edge cases securely.
- Reward users fairly using tracked data.
- Control critical logic with proper access and checks.

---

🗓 Posted on: July 13, 2025  
🛠 Built on: July 11, 2025  

---

## 🛠 Tools Used

- Language: Solidity `^0.8.18`
- IDE: [Remix](https://remix.ethereum.org/) + Visual Studio Code  
- Version Control: Git + GitHub (SSH)

---

## 📄 License

MIT License – feel free to learn, remix, and use.

---

## ✍ Author

**Michealking**   
**Security contact:** buildswithking@gmail.com

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the [30 Days of Solidity Challenge](https://github.com/BuildsWithKing/30-days-solidity-challenge)

---

### 🙏 Kindly give credit if this helped you grow.

---

## ✅ Day 14 Completed!