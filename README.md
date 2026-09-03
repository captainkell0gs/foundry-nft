# Foundry NFT

ERC721 NFT implementation using Solidity, Foundry, OpenZeppelin, and IPFS-hosted metadata.

## Requirements

- [Git](https://git-scm.com/)
- [Foundry](https://getfoundry.sh/)

Check installations:

```bash
git --version
forge --version
```

## Setup

Clone the repository:

```bash
git clone <REPOSITORY_URL>
cd <REPOSITORY_NAME>
```

Install dependencies:

```bash
forge install
```

Build:

```bash
forge build
```

## OpenZeppelin

This project uses OpenZeppelin's ERC721 implementation.

```bash
forge install OpenZeppelin/openzeppelin-contracts
```

## Local Development

Start an Anvil node:

```bash
anvil
```

Deploy locally:

```bash
make deploy
```

## Testing

Run the test suite:

```bash
forge test
```

Run with increased verbosity:

```bash
forge test -vv
```

Run with maximum verbosity:

```bash
forge test -vvvv
```

### Fork Testing

Set the Sepolia RPC URL in `.env`:

```bash
SEPOLIA_RPC_URL=<YOUR_SEPOLIA_RPC_URL>
```

Run fork tests:

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```bash
forge coverage
```

## Deployment

Create a `.env` file:

```bash
SEPOLIA_RPC_URL=<YOUR_SEPOLIA_RPC_URL>
PRIVATE_KEY=<YOUR_PRIVATE_KEY>
```

Optional:

```bash
ETHERSCAN_API_KEY=<YOUR_ETHERSCAN_API_KEY>
```

Never commit `.env` or expose your private key.

### IPFS NFT

Deploy to Sepolia:

```bash
make deploy ARGS="--network sepolia"
```

The NFT uses metadata and images hosted through IPFS.

## NFT Metadata

Each NFT stores a token URI pointing to its metadata.

Example metadata structure:

```json
{
  "name": "NFT Name",
  "description": "NFT Description",
  "image": "ipfs://<IMAGE_CID>"
}
```

The metadata is uploaded to IPFS and the resulting URI is associated with the NFT's token ID.

## Examples

![drifter_1](img/drifter_1.jpg) ![drifter_2](img/drifter_2.jpg)

## Interacting With the Contract

Mint an NFT:

```bash
cast send <NFT_CONTRACT_ADDRESS> \
    "mintNft(string)" \
    "ipfs://<METADATA_CID>" \
    --private-key $PRIVATE_KEY \
    --rpc-url $SEPOLIA_RPC_URL
```

Check the owner of a token:

```bash
cast call <NFT_CONTRACT_ADDRESS> \
    "ownerOf(uint256)" <TOKEN_ID> \
    --rpc-url $SEPOLIA_RPC_URL
```

Get the metadata URI:

```bash
cast call <NFT_CONTRACT_ADDRESS> \
    "tokenURI(uint256)" <TOKEN_ID> \
    --rpc-url $SEPOLIA_RPC_URL
```

## Gas

Generate a gas snapshot:

```bash
forge snapshot
```

## Formatting

Format the project:

```bash
forge fmt
```

Check formatting:

```bash
forge fmt --check
```
