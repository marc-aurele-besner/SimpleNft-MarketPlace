const hre = require('hardhat');
const fs = require('fs');

const constants = require('../constants');

async function main() {
  if (fs.existsSync('abi')) fs.rmdirSync('abi', { recursive: true });

  const allArtifactPaths = await hre.artifacts.getArtifactPaths();
  const filteredArtifactPaths = allArtifactPaths.filter((path) => path.includes(constants.CONTRACT_NAME));
  console.log('\x1b[32m', "Building ABI's for ", filteredArtifactPaths.length, '\x1b[0m', ' contracts');
  filteredArtifactPaths.forEach((path) => {
    // detect if file exists
    if (fs.existsSync(path)) {
      // parse file
      const file = JSON.parse(fs.readFileSync(path, 'utf8'));
      // if abi/ does not exist, create it
      if (!fs.existsSync('abi')) fs.mkdirSync('abi');
      // write file
      const filePath = 'abi/' + file.contractName + '.json';
      fs.writeFileSync(filePath, JSON.stringify(file.abi, null, 2));
      console.log('\x1b[32m', 'Build ABI for ', '\x1b[0m', file.contractName, ' to ', '\x1b[34m', filePath, '\x1b[0m');
    }
  });
  console.log('\x1b[32m', "Done building ABI's", '\x1b[0m');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
