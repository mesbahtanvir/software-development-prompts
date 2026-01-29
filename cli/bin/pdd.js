#!/usr/bin/env node

const { install, uninstall, update, showVersion, showHelp } = require('../lib/commands');

const args = process.argv.slice(2);
const command = args[0];

async function main() {
  switch (command) {
    case 'install':
      await install();
      break;
    case 'uninstall':
      await uninstall();
      break;
    case 'update':
      await update();
      break;
    case '--version':
    case '-v':
      showVersion();
      break;
    case '--help':
    case '-h':
    case undefined:
      showHelp();
      break;
    default:
      console.error(`Unknown command: ${command}`);
      console.log('Run "pdd --help" for usage information.');
      process.exit(1);
  }
}

main().catch((err) => {
  console.error('Error:', err.message);
  process.exit(1);
});
