var { ethers } = require("hardhat");

async function main() {
  var name = "Mi Primer Token";
  var symbol = "MPRTKN";
  const miPrimerToken = await ethers.deployContract("MiPrimerToken", [
    name,
    symbol,
  ]);
  console.log(`Address deployed: ${await miPrimerToken.getAddress()}`);

  // Espera 10 confirmaciones
  var res = await miPrimerToken.waitForDeployment();
  await res.deploymentTransaction().wait(10);

  await hre.run("verify:verify", {
    address: await miPrimerToken.getAddress(),
    constructorArguments: [name, symbol],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1; // exitcode quiere decir fallor por error, terminacion fatal
});
