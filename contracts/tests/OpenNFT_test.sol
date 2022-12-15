// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "hardhat/console.sol";
import "../nft-marketplace/OpenNFT.sol";

contract OpenNFTTest is OpenNFT {
    address acc0;
    address acc1;

    // OpenNFT nft;
    function beforeAll () public {
        // nft = new OpenNFT();
        acc0 = TestsAccounts.getAccount(0); 
        acc1 = TestsAccounts.getAccount(1);
    }

    function checkMint () public {
        console.log("Running checkMint");

        uint256 tokId = safeMint("uri", 1000, 1000);

        Assert.equal(tokId, uint256(0), "new id must be 0");
    }

    /// #sender: account-1
    /// #value: 1000
    function checkBuyEth () public payable {
        console.log("Running checkBuyEth");

        buyEth(0);

        Assert.equal(ownerOf(0), TestsAccounts.getAccount(1), "owner should change");
    }
}
