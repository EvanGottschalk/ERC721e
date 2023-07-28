async function main() {
    const NFT_contract_factory = await ethers.getContractFactory("CONTRACT_NAME")
  
    // Start deployment, returning a promise that resolves to a contract object
    const NFT_contract = await NFT_contract_factory.deploy()
    await NFT_contract.deployed()
    console.log("Contract deployed to address:", NFT_contract_factory.address)
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
  