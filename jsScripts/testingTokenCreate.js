// Define the hex address, index, and supply as strings
const hexAddress = "b24156B92244C1541F916511E879e60710e30b84";
const index = "123456";
const supply = "10";

// Convert the hex address to a BigInt
const addressBigInt = BigInt("0x" + hexAddress);

// Ensure that the index and supply are within valid ranges
const maxIndex = BigInt(Math.pow(2, 56) - 1);
const maxSupply = BigInt(Math.pow(2, 40) - 1);

const indexBigInt = BigInt(index);
const supplyBigInt = BigInt(supply);

if (indexBigInt < 0 || indexBigInt > maxIndex) {
  throw new Error("Invalid index value");
}

if (supplyBigInt < 0 || supplyBigInt > maxSupply) {
  throw new Error("Invalid supply value");
}

// Concatenate the BigInt representations to create the token identifier
const tokenIdBigInt = (addressBigInt << BigInt(96)) | (indexBigInt << BigInt(40)) | supplyBigInt;

// Convert the token identifier to a hexadecimal string
const tokenIdHex = tokenIdBigInt.toString(16).toUpperCase();

console.log("Token Identifier:", tokenIdBigInt);
