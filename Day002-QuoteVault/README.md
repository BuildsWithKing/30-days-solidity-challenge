## QuoteVault

*A basic smart contract that allows users to store, view, update and delete their favorite quotes. it also allows the contract **owner** to view any user's submitted quote*

---

## Features:

-   **Struct** - Groups user to quote data (author, description and timestamp).
-   **Mapping** - Links each user's address to their quote.
-   **Function**- Users can:
    -   Store a quote
    -   View their quote
    -   Update their quote
    -   Delete their quote
    -   Owner can view any user's quote.
-   **Constructor** - Sets the contract deployer as the owner.
-  **Modifier**- Restricts special functions to only the contract owner. 

---

## Contract File:
- `QuoteVault.sol` 

---

## Tool used

- Language: Solidity `^0.8.18`
- IDE: [Remix] (https://remix.ethereum.org/)

---

## License 

This project is licensed under the MIT License. Feel free to use, modify, and learn from it.

## Author

Built by [@BuildsWithKing] (https://github.com/BuildsWithKing) as part of the `30 Days of solidity` challenge.
