//SPDX-License-Identifier: MIT

/// @title EmailRegistry.
/// @author Michealking (@BuildsWithKing).
/// @custom: security-contact buildswithking@gmail.com.
/// @date created 23rd of july, 2025.

/// @notice Allows users to register, update, access and delete their email addresses on-chain.
/// @dev Contract manage lifecycle. custom errors optimize gas.

pragma solidity ^0.8.18;

/// @dev Thrown when a creator tries to perform only owner operation.
error __EMAILREGISTRY_UNAUTHORIZED_ACCESS();

/// @dev Thrown when a creator tries to create an account with an existing username.
error __EMAILREGISTRY_EXISTING_USERNAME();

/// @dev Thrown when contract is not active.
error __EMAILREGISTRY_INACTIVE_CONTRACT();

/// @dev Thrown when a creator inputs wrong email for deletion.
error __EMAILREGISTRY_ACCESS_DENIED();

/// @dev Thrown when owner tries to activate/delete email of user using wrong id.
error __EMAILREGISTRY_INVALID_EMAIL_ID();

/// @dev Thrown when dev tries to transfer ownership to the zero address.
error __EMAILREGISTRY_INVALID_USER_ADDRESS();

contract EmailRegistry {
    ///@notice Defines the email various states.
    enum EmailStatus {
        Created, // default
        Active,
        Suspended,
        Banned
    }

    /// @notice Contract deployer's address.
    address private owner;

    /// @notice Records total email created.
    uint128 public emailCount;

    /// @notice Activates and deactivates contract.
    bool private active;

    /// @notice Groups creator's data.
    struct EmailEntry {
        uint256 id;
        string firstName;
        string lastName;
        uint256 dateOfBirth;
        string userName;
        EmailStatus status;
        uint256 timeStamp;
    }

    /// @notice Maps id => creator's email.
    mapping(uint256 => EmailEntry) private EmailId;

    /// @notice Maps id => creator's address.
    mapping(uint256 => address) private creatorId;

    /// @notice Maps creator address => EmailEntry array;
    mapping(address => EmailEntry[]) private creatorEmails;

    /// @notice Maps username => true/false.
    mapping(string => bool) public userNameTaken;

    /// @notice Emits EthReceived.
    /// @param senderAddress The sender's address.
    /// @param ethAmount Amount of ETH receieved.
    event EthReceived(address senderAddress, uint256 ethAmount);

    /// @notice Emits EmailCreatedAndActivated.
    /// @param creatorAddress The creator's address.
    /// @param emailId The creator's unique email id.
    /// @param firstName The creator's first name.
    /// @param userName The creator's unique user name.
    event EmailCreatedAndActivated(
        address indexed creatorAddress, uint256 indexed emailId, string firstName, string userName
    );

    /// @notice Emits EmailUpdated.
    /// @param creatorAddress The creator's address.
    /// @param updatedEmailId The creator's updated email id.
    /// @param newFirstName The creator's new first name.
    /// @param newUserName The creator's new user name.
    event EmailUpdated(
        address indexed creatorAddress, uint256 indexed updatedEmailId, string newFirstName, string newUserName
    );

    /// @notice Emits UserNameFreed.
    /// @param freeUserName user name now available for new users.
    event UserNameFreed(string freeUserName);

    /// @notice Emits EmailActivated.
    /// @param creatorAddress The creator's address.
    /// @param emailId The creator's unique email id.
    event EmailActivated(address indexed creatorAddress, uint256 emailId);

    /// @notice Emits EmailSuspended.
    /// @param creatorAddress The creator's address.
    /// @param emailId The creator's unique email id.
    event EmailSuspended(address indexed creatorAddress, uint256 emailId);

    /// @notice Emits EmailBanned.
    /// @param creatorAddress The creator's address.
    /// @param emailId The creator's unique email id.
    event EmailBanned(address indexed creatorAddress, uint256 emailId);

    /// @notice Emits userNameDeleted.
    /// @param deletedUserName The deleted usern name.
    event UserNameDeleted(string deletedUserName);

    /// @notice Emits EmailDeleted.
    /// @param creatorAddress The creator's address.
    /// @param emailId The creator's unique email id.
    /// @param userName The creator's deleted user name.
    event EmailDeleted(address indexed creatorAddress, uint256 indexed emailId, string userName);

    /// @notice Emit ContractOwnershipTransferred.
    /// @param ownerAddress Contract deployer's address.
    /// @param newOwnerAddress The new owner's address.
    event ContractOwnershipTransferred(address indexed ownerAddress, address indexed newOwnerAddress);

    /// @notice Emits ContractOwnerShipRenounced.
    /// @param zeroAddress The zero address.
    event ContractOwnershipRenounced(address indexed zeroAddress);

    /// @notice Emits contractActivated.
    event ContractActivated();

    /// @notice Emits contractDeactivated.
    event ContractDeactivated();

    /// @notice Sets contract deployer as owner.
    constructor() {
        owner = msg.sender;
    }

    /// @dev Restricts access to only contract deployer.
    modifier onlyOwner() {
        if (msg.sender != owner) revert __EMAILREGISTRY_UNAUTHORIZED_ACCESS();
        _;
    }
    /// @dev Activates and deactivates contract.

    modifier isActive() {
        if (!active) revert __EMAILREGISTRY_INACTIVE_CONTRACT();
        _;
    }

    /// @notice Returns bool(true/false)
    /// @return true if contract is active, false otherwise.
    function isContractActive() public view returns (bool) {
        return active;
    }

    /// @notice Allows user's register.
    /// @param _firstName The user's first name.
    /// @param _lastName The user's last name.
    /// @param _dateOfBirth The user's date of birth.
    /// @param _userName The user's unique name.
    function register(string memory _firstName, string memory _lastName, uint256 _dateOfBirth, string memory _userName)
        public
        isActive
    {
        if (userNameTaken[_userName] == true) {
            revert __EMAILREGISTRY_EXISTING_USERNAME();
        } // prevents multiple username.

        emailCount++;
        uint256 _id = emailCount;
        EmailEntry storage emailEntry = EmailId[_id];
        emailEntry.id = _id;
        emailEntry.firstName = _firstName;
        emailEntry.lastName = _lastName;
        emailEntry.userName = _userName;
        emailEntry.dateOfBirth = _dateOfBirth;
        emailEntry.status = EmailStatus.Active;
        emailEntry.timeStamp = block.timestamp;

        userNameTaken[_userName] = true;

        creatorEmails[msg.sender].push(emailEntry); // Stores creator's multiple emails.

        creatorId[_id] = msg.sender; // Stores creator's email id.

        emit EmailCreatedAndActivated(msg.sender, _id, _firstName, _userName);
    }

    /// @notice Allows user's update their Email.
    /// @param _newFirstName The user's new first name.
    /// @param _newLastName The user's new last name.
    /// @param _newDateOfBirth The user's new date of birth.
    /// @param _newUserName The user's new unique name.
    function updateEmail(
        uint256 _id,
        string memory _newFirstName,
        string memory _newLastName,
        uint256 _newDateOfBirth,
        string memory _newUserName
    ) public isActive {
        if (creatorId[_id] != msg.sender) revert __EMAILREGISTRY_ACCESS_DENIED();

        string memory oldUserName = EmailId[_id].userName;

        if (keccak256(bytes(_newUserName)) != (keccak256(bytes(oldUserName))) && userNameTaken[_newUserName]) {
            revert __EMAILREGISTRY_EXISTING_USERNAME();
        }

        userNameTaken[oldUserName] = false; // Deletes creator's old username.

        EmailEntry storage newEmailEntry = EmailId[_id];

        newEmailEntry.firstName = _newFirstName;
        newEmailEntry.lastName = _newLastName;
        newEmailEntry.userName = _newUserName;
        newEmailEntry.dateOfBirth = _newDateOfBirth;
        newEmailEntry.status = EmailStatus.Active;
        newEmailEntry.timeStamp = block.timestamp;

        userNameTaken[_newUserName] = true; // Sets the creator's new username.

        EmailEntry[] storage id = creatorEmails[msg.sender];

        uint256 indexToUpdate = 0;

        for (uint256 i = 0; i < id.length; i++) {
            if (id[i].id == _id) {
                indexToUpdate = i;
                break;
            }
        } // Stores creator's updated email.

        creatorId[_id] = msg.sender;

        emit UserNameFreed(oldUserName);
        emit EmailUpdated(msg.sender, _id, _newFirstName, _newUserName);
    }

    /// @notice Suspends caller's email.
    /// @param _id The creator's email id.
    function suspendMyEmail(uint256 _id) external isActive {
        EmailEntry storage emailEntry = EmailId[_id];
        if (creatorId[_id] != msg.sender) revert __EMAILREGISTRY_INVALID_EMAIL_ID();

        emailEntry.status = EmailStatus.Suspended;

        emit EmailSuspended(msg.sender, _id);
    }

    /// @notice Deletes caller's email.
    /// @param _id The creator email id.
    function deleteMyEmail(uint256 _id, string memory _userName) public isActive {
        if (creatorId[_id] != msg.sender) revert __EMAILREGISTRY_ACCESS_DENIED();
        delete EmailId[_id];

        EmailEntry[] storage emailEntry = creatorEmails[msg.sender];

        uint256 indexToDelete = 0;

        for (uint256 i = 0; i < emailEntry.length; i++) {
            if (emailEntry[i].id == _id) {
                indexToDelete = i;
                break;
            }
        }

        for (uint256 i = indexToDelete; i < emailEntry.length - 1; i++) {
            emailEntry[i] = emailEntry[i + 1];
        }
        emailEntry.pop(); // Remove last element.

        userNameTaken[_userName] = false;

        unchecked {
            emailCount--;
        }

        emit EmailDeleted(msg.sender, _id, _userName);
    }

    /// @notice Returns (0 -> active) (1 -> suspended) (2 -> banned).
    /// @return The current email status.
    function checkMyEmailStatus(uint256 _id) public view returns (EmailStatus) {
        if (creatorId[_id] != msg.sender) revert __EMAILREGISTRY_ACCESS_DENIED();
        EmailEntry memory emailEntry = EmailId[_id];
        return emailEntry.status;
    }

    /// @notice Returns creator's email.
    /// @return Creator's email.
    function getMyEmail(uint256 _id) public view returns (EmailEntry memory) {
        if (creatorId[_id] != msg.sender) revert __EMAILREGISTRY_ACCESS_DENIED();
        return EmailId[_id];
    }

    /// @notice Returns All creator's email.
    /// @return All creator's email
    function getAllMyEmail() public view returns (EmailEntry[] memory) {
        return creatorEmails[msg.sender];
    }

    /// @notice Returns contract deployer's address.
    function getOwner() public view returns (address) {
        return owner;
    }

    /// @notice Only contract deployer can return creator's email.
    function getEmailById(uint256 _id) external view onlyOwner returns (EmailEntry memory) {
        return EmailId[_id];
    }

    /// @notice Only contract deployer can activate creator's email (used during network delays).

    /// @param _creatorAddress The creator's address.
    /// @param _emailId The creator's email id.
    function activateCreatorEmail(address _creatorAddress, uint256 _emailId) external isActive onlyOwner {
        EmailEntry storage emailEntry = EmailId[_emailId];
        if (creatorId[_emailId] != _creatorAddress) revert __EMAILREGISTRY_INVALID_EMAIL_ID();

        emailEntry.status = EmailStatus.Active;

        emit EmailActivated(_creatorAddress, _emailId);
    }

    /// @notice Only contract deployer can suspend creator's email.
    /// @param _creatorAddress The creator's address.
    /// @param _emailId The creator's email id.
    function suspendCreatorEmail(address _creatorAddress, uint256 _emailId) external onlyOwner isActive {
        EmailEntry storage emailEntry = EmailId[_emailId];
        if (creatorId[_emailId] != _creatorAddress) revert __EMAILREGISTRY_INVALID_EMAIL_ID();

        emailEntry.status = EmailStatus.Suspended;

        emit EmailSuspended(_creatorAddress, _emailId);
    }

    /// @notice Only contract deployer can suspended creators email.
    /// @param _creatorAddress The creator's address.
    /// @param _emailId The creator's email id.
    function banCreatorEmail(address _creatorAddress, uint256 _emailId) external onlyOwner isActive {
        EmailEntry storage emailEntry = EmailId[_emailId];
        if (creatorId[_emailId] != _creatorAddress) revert __EMAILREGISTRY_INVALID_EMAIL_ID();

        emailEntry.status = EmailStatus.Banned;

        emit EmailBanned(_creatorAddress, _emailId);
    }

    /// @notice Only contract deployer can return creator's email id.
    /// @param _creatorAddress The creator's address.
    function getCreatorEmailIds(address _creatorAddress) external view onlyOwner returns (uint256[] memory) {
        EmailEntry[] memory emails = creatorEmails[_creatorAddress];

        uint256[] memory ids = new uint256[](emails.length);

        for (uint256 i = 0; i < ids.length; i++) {
            ids[i] = emails[i].id;
        }

        return ids;
    }

    /// @notice Only owner can returns (0 -> created) (1 -> active) (2 -> suspended) (3 -> banned).
    /// @return The current email status.
    function checkCreatorEmailStatus(address _creatorAddress, uint256 _id)
        external
        view
        onlyOwner
        returns (EmailStatus)
    {
        if (creatorId[_id] != _creatorAddress) revert __EMAILREGISTRY_INVALID_EMAIL_ID();
        EmailEntry memory emailEntry = EmailId[_id];
        return emailEntry.status;
    }

    /// @notice Only contract deployer can return creator's email.
    /// @return emails owned by the address.
    function getCreatorEmails(address _creatorAddress) external view onlyOwner returns (EmailEntry[] memory) {
        return creatorEmails[_creatorAddress];
    }

    /// @notice Only contract deployer can delete creator's user name.
    /// @param _userName The creator's user name.
    function deleteCreatorsUserName(string memory _userName) external onlyOwner isActive {
        userNameTaken[_userName] = false;

        emit UserNameDeleted(_userName);
    }

    /// @notice Only owner can delete user's email.
    /// @param _creatorAddress The creator's address.
    /// @param _emailId The Creator's email id.
    /// @param _userName  The creator's userName.
    function deleteUserEmail(address _creatorAddress, uint256 _emailId, string memory _userName)
        external
        isActive
        onlyOwner
    {
        if (creatorId[_emailId] != _creatorAddress) revert __EMAILREGISTRY_ACCESS_DENIED();
        delete EmailId[_emailId];

        EmailEntry[] storage emailEntry = creatorEmails[_creatorAddress];

        uint256 indexToDelete = 0;

        for (uint256 i = 0; i < emailEntry.length; i++) {
            if (emailEntry[i].id == _emailId) {
                indexToDelete = i;
                break;
            }
        }

        for (uint256 i = indexToDelete; i < emailEntry.length - 1; i++) {
            emailEntry[i] = emailEntry[i + 1];
        }
        emailEntry.pop(); // Remove last element.

        userNameTaken[_userName] = false;

        unchecked {
            emailCount--;
        }

        emit EmailDeleted(_creatorAddress, _emailId, _userName);
    }

    /// @notice Only contract deployer can transfer ownership.
    /// @param _userAddress The user address.
    function transferOwnership(address _userAddress) external onlyOwner {
        if (_userAddress == address(0)) revert __EMAILREGISTRY_INVALID_USER_ADDRESS();
        owner = _userAddress;

        emit ContractOwnershipTransferred(owner, _userAddress);
    }

    /// @notice Only contract deployer can renounce ownership to zero address.
    function renounceOwnership() external onlyOwner isActive {
        owner = address(0);

        emit ContractOwnershipRenounced(address(0));
    }

    /// @notice Only contract deployer can activate contract.
    function activateContract() external onlyOwner {
        active = true;

        emit ContractActivated();
    }

    /// @notice Only contract deployer can deactivate contract.
    function deactivateContract() external onlyOwner {
        active = false;

        emit ContractDeactivated();
    }

    /// @notice Handles ETH deposit without calldata.
    receive() external payable {
        emit EthReceived(msg.sender, msg.value);
    }

    /// @notice Handles ETH deposit with calldata.
    fallback() external payable {
        emit EthReceived(msg.sender, msg.value);
    }
}