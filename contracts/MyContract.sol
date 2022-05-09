pragma solidity ^0.8.1;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Huntress is ERC721, Ownable, ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  string public baseURI;
  uint256 public mintPrice = 500 ether;
  uint256 public mintLimit = 5;

  constructor() ERC721 ("Cyber Huntresses NFT", "CHN") {
    
  }

  function mint() public payable nonReentrant {
    require(msg.value >= mintPrice, "Not enough ether to mint.");
    require(balanceOf(msg.sender) < mintLimit, "Cannot mint more than 5");

    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    _tokenIds.increment();
  }

  function setMintPrice(uint256 _mintPrice) public onlyOwner {
    mintPrice = _mintPrice;
  }

  function setBaseURI(string memory _uri) public onlyOwner {
    baseURI = _uri;
  }

  function _baseURI() internal view override returns (string memory) {
    return baseURI;
  }
  
  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    require(_exists(tokenId), "Token does not exist");
    return string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json"));
  }

  function withdraw() external onlyOwner {
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    require(success, "Transfer failed.");
  }
}