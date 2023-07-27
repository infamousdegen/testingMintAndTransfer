// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "src/Nft.sol";
import "./TypesFile.sol";

import "src/tokeIdentifiers.sol";
contract eip712Test is EIP712Decoder{
    using SafeERC20 for IERC20;

    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    ERCTOKEN public Nft = ERCTOKEN(0x6079555928a48536E79bA424917beD02fFA78c04);
    IERC20 public  wrappedShm = IERC20(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6);
    struct Identity {
        address from;
        uint256 tokenId;
        uint256 Price;
        uint256 AmountToSell;
    }
    

function getEIP712DomainHash(string memory contractName, string memory version, uint256 chainId, address verifyingContract) public pure returns (bytes32) {
    bytes memory encoded = abi.encode(
      EIP712DOMAIN_TYPEHASH,
      keccak256(bytes(contractName)),
      keccak256(bytes(version)),
      chainId,
      verifyingContract
    );
    return keccak256(encoded);
  }

  function getDomainHash () public view override returns (bytes32){
    return(getEIP712DomainHash("Shardible","1",8081,address(this)));
  }


     function mintAndTransfer(address _to,SignedPerson memory _data,uint256 _amountToBuy) external 
    {
          
          //First check if the from address in the data and the address from signed data is the same
          
          require(verifySignedPerson(_data) == _data.message.From,"Addres validation check failed");

          require(TokenIdentifiers.tokenCreator(_data.message.tokenId) == _data.message.From,"Address validation check failed 2");
          uint256 tokenId = _data.message.tokenId;

          //Check if the _amountToBuy + current Balance of the token < maxSupplyEncoded in the token Id

          uint256 maxSupply = TokenIdentifiers.tokenMaxSupply(tokenId);
          uint256 currentSupply = Nft.totalSupply(tokenId);

            require(_amountToBuy+currentSupply <= maxSupply, "Your purchase will exceed the supply of the tokens");
            wrappedShm.safeTransferFrom(msg.sender,_data.message.From,_data.message.Price*_amountToBuy);

            Nft.mint(_to,tokenId,_amountToBuy,"");
            
    }


}