import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

// Pass a module id () and a callback function
const StorageModule = buildModule("StorageModule", (m) => {
  const storage = m.contract("SimpleStorage", []);

  m.call(storage, "set", [99]);

  return { storage };
});

export default StorageModule;
