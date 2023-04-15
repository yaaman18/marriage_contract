// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract MarriageRegistry is AccessControl, ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("MarriageRegistry", "MARRIAGE") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MATCHMAKER_ROLE, msg.sender);
    }

    struct Marriage {
        address spouse1;
        address spouse2;
        uint256 timestamp;
        address matchmaker;
    }

    bytes32 public constant MATCHMAKER_ROLE = keccak256("MATCHMAKER_ROLE");

    mapping(uint256 => Marriage) public marriages;

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
    return super.supportsInterface(interfaceId);
    }

    function mintMarriageNFTs(uint256 _marriageId, address _spouse1, address _spouse2) public onlyRole(MATCHMAKER_ROLE) {
        Marriage memory marriage = Marriage(_spouse1, _spouse2, block.timestamp, msg.sender);
        marriages[_marriageId] = marriage;

        _tokenIds.increment();
        uint256 newItemId1 = _tokenIds.current();
        _mint(_spouse1, newItemId1);

        _tokenIds.increment();
        uint256 newItemId2 = _tokenIds.current();
        _mint(_spouse2, newItemId2);

        _transfer(msg.sender, _spouse1, newItemId1);
        _transfer(msg.sender, _spouse2, newItemId2);
    }
}
