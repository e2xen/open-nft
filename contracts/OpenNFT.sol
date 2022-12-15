// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.8.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.8.0/utils/Counters.sol";

import "@openzeppelin/contracts@4.8.0/token/ERC20/IERC20.sol";

contract OpenNFT is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping (uint256 => uint256) private _tokenPricesEth;
    mapping (uint256 => uint256) private _tokenPricesUSDC;

    uint256 public ethPriceStep = 10000; // 10 Gweis
    uint256 public usdcPriceStep = 50000;  // 50 cents

    IERC20 public usdc;

    //solhint-disable-next-line
    constructor() ERC721("OpenNFT", "OPN") {
        usdc = IERC20(0x98339D8C260052B7ad81c28c16C0b98420f2B46a);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function safeMint(string memory uri, uint256 ethPrice, uint256 usdcPrice) public returns (uint256) {
        require(ethPrice > 0, "Price should not be zero");
        require(usdcPrice > 0, "Price should not be zero");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(_msgSender(), tokenId);
        _setTokenURI(tokenId, uri);
        _tokenPricesEth[tokenId] = ethPrice;
        _tokenPricesUSDC[tokenId] = usdcPrice;

        return tokenId;
    }

    function tokenPriceEth(uint256 tokenId) public view returns (uint256) {
        return _tokenPricesEth[tokenId];
    }
    function tokenPriceUSDC(uint256 tokenId) public view returns (uint256) {
        return _tokenPricesUSDC[tokenId];
    }

    function _increaseEthPrice(uint256 tokenId) private {
        _tokenPricesEth[tokenId] += ethPriceStep;
    }
    function _increaseUSDCPrice(uint256 tokenId) private {
        _tokenPricesUSDC[tokenId] += usdcPriceStep;
    }


    function buyEth(uint256 tokenId) public payable {
        require(_exists(tokenId), "Token does not exist");

        address payable seller = payable(ownerOf(tokenId));
        address buyer = _msgSender();
        require(seller != buyer, "You are already the owner of the token");

        uint256 sentPrice = msg.value;
        require(sentPrice >= tokenPriceEth(tokenId), "Please send token price in Eth");
        
        seller.transfer(sentPrice);

        _safeTransfer(seller, buyer, tokenId, "");
        _increaseEthPrice(tokenId);
    }

    function buyUSDC(uint256 tokenId) public payable {
        require(_exists(tokenId), "Token does not exist");

        address seller = ownerOf(tokenId);
        address buyer = _msgSender();
        require(seller != buyer, "You are already the owner of the token");

        uint256 sentPrice = usdc.allowance(buyer, address(this));
        require(sentPrice >= tokenPriceUSDC(tokenId), "Allowance less than token price, please approve this contract to send tokens on your behalf");
        
        require(
            usdc.transferFrom(buyer, seller, sentPrice), 
            "USDC transfer failed"
        );

        _safeTransfer(seller, buyer, tokenId, "");
        _increaseUSDCPrice(tokenId);
    }




    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setApprovalForAll(address, bool) public virtual override(ERC721) {
        require(1 == 0, "This method is disabled");
    }

    function approve(address, uint256) public virtual override(ERC721) {
        require(1 == 0, "This method is disabled");
    }

    function safeTransferFrom(address, address, uint256, bytes memory) public virtual override(ERC721) {
        require(1 == 0, "This method is disabled");
    }

    function transferFrom(address, address, uint256) public virtual override(ERC721) {
        require(1 == 0, "This method is disabled");
    }


}
