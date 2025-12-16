// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is ERC721, Ownable {

    uint256 public tokenCounter;
    uint256 public marketplaceFee = 2; // 2%

    struct MarketItem {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => MarketItem) public marketItems;

    constructor() 
    ERC721("YardanNFT", "YFT") 
    Ownable(msg.sender) 
{
    tokenCounter = 0;
}


    // Mint NFT
    function mintNFT() external {
        tokenCounter++;
        _safeMint(msg.sender, tokenCounter);
    }

    // List NFT for sale
    function listNFT(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not NFT owner");
        require(price > 0, "Price must be > 0");

        marketItems[tokenId] = MarketItem(
            tokenId,
            msg.sender,
            price,
            true
        );
    }

    // Buy NFT
    function buyNFT(uint256 tokenId) external payable {
        MarketItem memory item = marketItems[tokenId];

        require(item.isListed, "NFT not for sale");
        require(msg.value == item.price, "Incorrect price");

        uint256 fee = (msg.value * marketplaceFee) / 100;
        uint256 sellerAmount = msg.value - fee;

        payable(item.seller).transfer(sellerAmount);
        payable(owner()).transfer(fee);

        _transfer(item.seller, msg.sender, tokenId);

        marketItems[tokenId].isListed = false;
    }
}
