# MarriageRegistry Contract

The `MarriageRegistry` contract is a Solidity smart contract that handles the registration of marriages and related functionality like divorce and settlement. It utilizes OpenZeppelin's ERC721 standard to create and manage unique tokens for each spouse, and it locks ERC20 tokens as a security deposit until the marriage is dissolved.

## Key Components

### Marriage Structure

The contract has a `Marriage` struct that holds information about the marriage, including the addresses of the spouses, their ages, their genders, the timestamp of the marriage, and the address of the matchmaker.

### Divorce Structure

The `Divorce` struct stores the divorce approval status of each spouse, with a boolean value for each spouse's approval.

### Settlement Structure

The `Settlement` struct stores information about the proposed settlement during a divorce, including whether a settlement has been proposed, which spouse should receive the locked tokens, and whether the settlement has been approved.

### ERC20 Token Locking

The contract requires ERC20 tokens to be locked as a security deposit when a marriage is registered. These tokens are released when the marriage is dissolved, either through a mutual divorce or through a matchmaker's judgment.

## Key Functions

### mintAndLockMarriageNFTs

The `mintAndLockMarriageNFTs` function mints and locks two unique ERC721 tokens for each spouse when a marriage is registered. The tokens are locked, and an event is emitted for each locked token.

### locked

The `locked` function checks if a given tokenId is locked.

### divorce

The `divorce` function allows either spouse to initiate a divorce by approving it. If both spouses approve the divorce, the locked ERC20 tokens are released and the marriage NFTs are burned.

### proposeSettlement and approveSettlement

The `proposeSettlement` function allows either spouse to propose a settlement during a divorce, specifying which spouse should receive the locked tokens. The `approveSettlement` function allows either spouse to approve the proposed settlement.

### matchmakerJudgment

The `matchmakerJudgment` function allows a matchmaker to make a judgment on a divorce case, distributing the locked ERC20 tokens according to the approved settlement. This function can only be called by someone with the `MATCHMAKER_ROLE`.
