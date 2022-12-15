# Open NFT

## Yet Another NFT Marketplace

- Any NFT can be bought by anyone
- After each successful deal the price is increased by a constant factor
- Fully distributed (no back-end)
- Metadata is stored on IPFS
- Buy NFTs in Ether or USDC

## Smart Contract

Solidity code can be found at `contracts/` folder.

Currently hosted on [Goerli](https://goerli.etherscan.io/address/0x780a891C0B8a359a8708b66E47cC75EcDe495cE3).

Available methods:

- `safeMint(string uri, uint256 ethPrice, uint256 usdcPrice)`: mint token with the specified IPFS uri (link part after `https://ipfs.io/ipfs/`) and prices in ETH and [USDC](https://goerli.etherscan.io/token/0x98339D8C260052B7ad81c28c16C0b98420f2B46a)
- `buyEth(uint256 tokenId)`: buy specified token in ETH (price can be seen by invoking `tokenPriceEth(uint256 tokenId)`)
- `buyUSDC(uint256 tokenId)`: buy specified token in USDC (price can be seen by invoking `tokenPriceUSDC(uint256 tokenId)`). Before invoking this method, this contract should be approved to transfer USDC from your account

After any successful deal, the price is increased by a constant amount.

## Unit testing

[Unit tests](./contracts/tests) of the contract are done with the [Remix Plugin](https://remix-ide.readthedocs.io/en/latest/unittesting.html).

## Linter

Linting is done with the [solhint](https://protofire.github.io/solhint/) Remix Plugin.
