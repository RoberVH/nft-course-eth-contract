const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);
  // Call the function.
  let txn = await nftContract.makeAnEpicNFT()
  // Wait for it to be mined.
  await txn.wait()
  let nftminted = await nftContract.getTotalNFTsMintedSoFar()
  console.log(nftminted._hex,'Cookies NFT minted')
  txn = await nftContract.makeAnEpicNFT()
  // Wait for it to be mined.
  await txn.wait()
  nftminted = await nftContract.getTotalNFTsMintedSoFar()
  console.log(nftminted._hex,'Cookies NFT minted')  
  txn = await nftContract.makeAnEpicNFT()
  // Wait for it to be mined.  
  await txn.wait()
  nftminted = await nftContract.getTotalNFTsMintedSoFar()
  console.log(nftminted._hex,'Cookies NFT minted') 
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };

  runMain();