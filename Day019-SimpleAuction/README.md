# 🛒 SimpleAuction Smart Contract (Day 19 – 30 Days of Solidity)

A fully modular and production-ready smart contract that allows users to list items, bid with ETH, and manage auction lifecycles. Built entirely from scratch in Solidity by [@BuildsWithKing](https://github.com/BuildsWithKing).

---

## 📌 Overview

*SimpleAuction* is an on-chain auction platform that enables:
- Sellers to list and manage items
- Bidders to compete in real-time with ETH bids
- Secure ETH withdrawal and claim process for winners
- Full auction lifecycle: Activate, Cancel, End, and Deactivate

All components are built in pure Solidity with modular contracts and libraries.

---

## ✅ Core Features

- 📦 *List Items*: Sellers can register items for auction with metadata
- 🏷 *Custom Auction States*: Active, Ended, Cancelled, etc.
- ⚔ *Bid System*: Users can bid on active items with ETH
- 🏆 *Claim Winner*: Highest bidder claims item after auction ends
- 🔒 *Secure Withdrawals*: Only outbidded users can withdraw
- 🔐 *Custom Errors & Access Modifiers*: Efficient and secure
- 🔄 *Ownership Transfer*: Auctioneer can transfer ownership
- ⚙ *Receive & Fallback*: Handles ETH sent to contract address
- 📈 *Auction Stats*: Bids count, highest bid, and more

---

## 🧱 Architecture

Modular breakdown:

```solidity
📁 src/ 
│ 
├── 📄 SimpleAuction.sol         # Main contract 
├── 📄 AuctionHub.sol            # Item listing, update, delete 
├── 📄 BidZone.sol               # Bidding, withdraw, claim 
├── 📄 Utils.sol                 # Contract state & ownership 
│ 
├── 📁 Structs/   
│└── 📄 AuctionStruct.sol     # ItemData struct
│ 
├── 📁 Libraries/ 
│├── 📄 AuctionLib.sol        # AuctionData mappings 
│└── 📄 AuctionTypes.sol      # AuctionState enum & utils

```

---

## 🛠 Example Usage (Remix)

### ✅ Step 1: Deploy Contract  
Deploy the SimpleAuction.sol contract on Remix.

Call activateContract() to enable core auction functionalities.

---

### ✅ Step 2: Register an Auction Item  


registerItem:  
```
Paste:  
["Vintage Watch", "Limited edition, stainless steel" , "Accessory", 1 ,500000000000000000, 1754654400 ]  
```
🕒 endsAt is a future UNIX timestamp — you can use https://www.unixtimestamp.com.

    500000000000000000 = 0.5ETH
---

### ✅ Step 3: Get Item Info  

```
getAuction(1) 
``` 
Returns full ItemData struct for item with ID 1.

---

### ✅ Step 4: Activate Auction  
```
activateAuction(1) 
``` 
Only seller can activate public bidding on the listed item.

---

### ✅ Step 5: Bid on Auction  
```
bidItem(1)  
```
💰 Send a value *greater than* startingPrice (e.g. 0.6 ETH: 600000000000000000)

---

### ✅ Step 6: Check Auction State  
```
getAuctionStateAsString(1) 
``` 
Returns: "Active", "Ended", "Cancelled", etc.

---

### ✅ Step 7: End Auction  
```
endAuction(1)  
```
⏳ Only seller can end Auction for Item ID 1.

---

### ✅ Step 8: Claim Won Item  
```
claimMyItem(1)  
```
🏆 Only the highest bidder can call this function after endsAt.

---

### ✅ Step 9: View Winner
```  
getWinner(1) 
``` 
Returns address of the auction winner for item ID 1.

---

### ✅ Step 10: Withdraw ETH (for outbid users)  
```
withdrawMyETH(500000000000000000)  
```
Only works if you're not the current highest bidder.

---

## 📅 Timeline

Built Between: 1st Aug - 6th Aug, 2025.

Posted On: 6th Aug, 2025.

---

## 🛠 Built With

- Solidity ^0.8.18
- Hardhat / Foundry-compatible
- Pure EVM & Gas Optimization
- NatSpec Comments & Custom Errors
- Full Event Emission for frontends

---

## 👨‍💻 Author

> Built by [MichealKing (BuildsWithKing)](https://github.com/BuildsWithKing)  
> ⚒ Day 19 of #30DaysSmartContractChallenge  
> 🚀 5 days of intense focus & Solidity engineering  

---

## 🌐 License

MIT — feel free to fork, use, contribute, and build upon.

---

## 💡 Future Ideas

- Add NFT auction capability
- Frontend dApp interface (React + Wagmi)
- ERC20 & ERC1155 item support

---

### 🙏 Please give credit if this inspired your learning journey.


---

## ✅ Day 19 Completed!

---
