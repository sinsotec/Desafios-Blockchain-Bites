var { ethers } = require("hardhat");

async function main() {
  const airdropOneCrossChainDesafio = await ethers.deployContract(
    "AirdropOneCrossChainDesafio"
  );
  console.log(`Address deployed: ${await airdropOneCrossChainDesafio.getAddress()}`);

  // Espera 10 confirmaciones
  var res = await airdropOneCrossChainDesafio.waitForDeployment();
  await res.deploymentTransaction().wait(10);

  await hre.run("verify:verify", {
    address: await airdropOneCrossChainDesafio.getAddress(),
    constructorArguments: [],
    contract: "contracts/desafios/AirdropOneCrossChainDesafio.sol:AirdropOneCrossChainDesafio"
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1; // exitcode quiere decir fallor por error, terminacion fatal
});
