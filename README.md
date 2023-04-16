# marriage_contract


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




# 婚姻コントラクト

婚姻コントラクトは結婚の登録と離婚や和解などの関連機能を処理するSolidityスマートコントラクトです。OpenZeppelinのERC721を利用して、各配偶者に固有のトークンを作成・管理し、結婚が解消されるまでERC20トークンを保証金としてロックします。

## 主要コンポーネント

### 結婚のしくみ

この契約には `Marriage` 構造体があり、結婚に関する情報（配偶者の住所、年齢、性別、結婚のタイムスタンプ、仲人のウォレットアドレスなど）を保持しています。

### 離婚の構造体

Divorce`構造体には、各配偶者の離婚承認状況がブール値で格納されます。

### 和解の構造

Settlement`構造体には、離婚時の和解案に関する情報（和解案の有無、ロックされたトークンを受け取るべき配偶者、和解案が承認されたかどうかなど）が格納されます。

### ERC20 トークンのロック

この契約では、結婚が登録される際に、保証金としてERC20トークンがロックされる必要があります。このトークンは、お互いの離婚または仲人の判断により婚姻が解消されたときに解放されます。

## 主な機能

### ミント・アンド・ロック・マリッジNFT

mintAndLockMarriageNFTs`関数は、婚姻届が提出された際に、各配偶者に固有の2つのERC721トークンを鋳造しロックする。トークンはロックされ、ロックされたトークンごとにイベントが発行されます。

### ロック

locked`関数は、与えられたtokenIdがロックされているかどうかをチェックします。

### 離婚

divorce`関数は、どちらかの配偶者が離婚を承認することで離婚を開始することができる。配偶者双方が離婚を承認した場合、ロックされていたERC20トークンは解放され、結婚NFTは焼却されます。

### proposeSettlementとapproveSettlement

proposeSettlement`関数は、どちらかの配偶者が離婚時の和解案を提案し、ロックされたトークンをどちらの配偶者に渡すかを指定することができます。approveSettlement`関数は、どちらかの配偶者が提案された和解案を承認することができる。

### マッチメイカー・ジャッジメント

matchmakerJudgment`関数は、仲人が離婚案件の判定を行い、承認された和解案に従ってロックされたERC20トークンを分配することができます。この関数は `MATCHMAKER_ROLE` を持つ人だけが呼び出すことができます。
