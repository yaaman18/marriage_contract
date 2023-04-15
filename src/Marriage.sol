// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IERC5192 {
    event Locked(uint256 tokenId);
    function locked(uint256 tokenId) external view returns (bool);
}

contract MarriageRegistry is AccessControl, ERC721,ERC721Burnable,IERC5192 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => bool) private _locked;

    IERC20 public erc20Token;
    uint256 public lockAmount;

    constructor(address erc20TokenAddress, uint256 _lockAmount) ERC721("MarriageRegistry", "MARRIAGE") {
        erc20Token = IERC20(erc20TokenAddress);
        lockAmount = _lockAmount;

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MATCHMAKER_ROLE, msg.sender);
    }


    struct Marriage {
        address spouse1;
        address spouse2;
        uint8 spouse1Age;
        uint8 spouse2Age;
        string spouse1Gender;
        string spouse2Gender;
        uint256 timestamp;
        address matchmaker;
    }

    struct Settlement {
        bool proposed;
        bool sendToSpouse1;
        bool approved;
    }

    struct Divorce {
        bool spouse1Approved;
        bool spouse2Approved;
    }


    bytes32 public constant MATCHMAKER_ROLE = keccak256("MATCHMAKER_ROLE");

    mapping(uint256 => Marriage) public marriages;

    mapping(uint256 => Divorce) public divorceApprovals;

    mapping(uint256 => Settlement) public settlements;

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
    return super.supportsInterface(interfaceId);
    }

    function mintAndLockMarriageNFTs(uint256 _marriageId, address _spouse1, address _spouse2, uint8 _spouse1Age, uint8 _spouse2Age, string memory _spouse1Gender, string memory _spouse2Gender ) public onlyRole(MATCHMAKER_ROLE) {
        require(erc20Token.transferFrom(_spouse1, address(this), lockAmount), "Transfer of tokens from spouse1 failed.");
        require(erc20Token.transferFrom(_spouse2, address(this), lockAmount), "Transfer of tokens from spouse2 failed.");

        _tokenIds.increment();
        uint256 tokenId1 = _tokenIds.current();

        _tokenIds.increment();
        uint256 tokenId2 = _tokenIds.current();

        Marriage memory marriage = Marriage(_spouse1, _spouse2, _spouse1Age, _spouse2Age, _spouse1Gender, _spouse2Gender, block.timestamp, msg.sender);
        marriages[_marriageId] = marriage;

        _safeMint(_spouse1, tokenId1);
        _locked[tokenId1] = true;
        emit Locked(tokenId1);

        _safeMint(_spouse2, tokenId2);
        _locked[tokenId2] = true;
        emit Locked(tokenId2);


        grantRole(MATCHMAKER_ROLE, _spouse1);
        grantRole(MATCHMAKER_ROLE, _spouse2);
    }

    function locked(uint256 tokenId) public view override returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        return _locked[tokenId];
    }

    function divorce(uint256 marriageId) public {
        Marriage memory marriage = marriages[marriageId];
        require(msg.sender == marriage.spouse1 || msg.sender == marriage.spouse2, "Caller must be one of the spouses");

        if (msg.sender == marriage.spouse1) {
            divorceApprovals[marriageId].spouse1Approved = true;
        } else if (msg.sender == marriage.spouse2) {
            divorceApprovals[marriageId].spouse2Approved = true;
        }

        if (divorceApprovals[marriageId].spouse1Approved && divorceApprovals[marriageId].spouse2Approved) {
            uint256 tokenId1 = marriageId * 2;
            uint256 tokenId2 = marriageId * 2 + 1;

            _burn(tokenId1);
            _burn(tokenId2);

            erc20Token.transfer(marriage.spouse1, lockAmount);
            erc20Token.transfer(marriage.spouse2, lockAmount);
        }
    }
    function proposeSettlement(uint256 marriageId, bool _sendToSpouse1) public {
        Marriage memory marriage = marriages[marriageId];
        require(msg.sender == marriage.spouse1 || msg.sender == marriage.spouse2, "Caller must be one of the spouses");

        settlements[marriageId] = Settlement(true, _sendToSpouse1, false);
    }

    function approveSettlement(uint256 marriageId) public {
        Marriage memory marriage = marriages[marriageId];
        require(msg.sender == marriage.spouse1 || msg.sender == marriage.spouse2, "Caller must be one of the spouses");

        require(settlements[marriageId].proposed, "Settlement must be proposed before approval");

        settlements[marriageId].approved = true;
    }


    function matchmakerJudgment(uint256 marriageId) public onlyRole(MATCHMAKER_ROLE) {
        require(divorceApprovals[marriageId].spouse1Approved && divorceApprovals[marriageId].spouse2Approved, "Both spouses must approve the divorce");
        require(settlements[marriageId].proposed && settlements[marriageId].approved, "Settlement must be proposed and approved");

        Marriage memory marriage = marriages[marriageId];
        uint256 tokenId1 = marriageId * 2;
        uint256 tokenId2 = marriageId * 2 + 1;

        _burn(tokenId1);
        _burn(tokenId2);

        if (settlements[marriageId].sendToSpouse1) {
            erc20Token.transfer(marriage.spouse1, lockAmount * 2);
        } else {
            erc20Token.transfer(marriage.spouse2, lockAmount * 2);
        }
    }


}
