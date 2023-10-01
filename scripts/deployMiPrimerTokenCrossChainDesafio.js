var { ethers } = require("hardhat");

async function main() {
  var name = "Mi Primer Token CrossChain OJS";
  var symbol = "OJSS";
  const miPrimerTokenCrossChain = await ethers.deployContract("contracts/desafios/MiPrimerTokenCrossChain.sol:MiPrimerTokenCrossChain", [
    name,
    symbol,
  ]);
  console.log(`Address deployed: ${await miPrimerTokenCrossChain.getAddress()}`);

  // Espera 10 confirmaciones
  var res = await miPrimerTokenCrossChain.waitForDeployment();
  await res.deploymentTransaction().wait(10);

  /* await hre.run("verify:verify", {
    address: await miPrimerToken.getAddress(),
    constructorArguments: [name, symbol],
  }); */
  await hre.run("verify:verify", {
    address: await miPrimerTokenCrossChain.getAddress(),
    constructorArguments: [name, symbol],
    contract: "contracts/desafios/MiPrimerTokenCrossChain.sol:MiPrimerTokenCrossChain",
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1; // exitcode quiere decir fallor por error, terminacion fatal
});
