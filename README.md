# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
Deployment 
```shell
Polygon-Mumbai-Matic-Network 
Deploying contracts... 🏃
Token deployed to: 0xAD577D56fe6aB887954cC235791CB59B8145AcDF
Exchange deployed to: 0x5784881A90d932602bf986332401cef214E6c9f3
Deployment Done ✅

```
Verification (npx hardhat verify --network mumbai 0x5784881A90d932602bf986332401cef214E6c9f3 0xAD577D56fe6aB887954cC235791CB59B8145AcDF)
```shell
Successfully submitted source code for contract
contracts/Exchange.sol:Exchange at 0x5784881A90d932602bf986332401cef214E6c9f3
for verification on the block explorer. Waiting for verification result...

Successfully verified contract Exchange on the block explorer.
https://mumbai.polygonscan.com/address/0x5784881A90d932602bf986332401cef214E6c9f3#code
```
