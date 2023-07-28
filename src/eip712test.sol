// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "src/Nft.sol";
import "./newTypes.sol";
import "src/tokenIdentifiers.sol";

contract eip712Test is EIP712Decoder{
    using SafeERC20 for IERC20;
    using TokenIdentifiers for uint256;

    //This would enable partial filling of tokens
    mapping(uint256 => uint256) tokensFilled;

    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    ERCTOKEN public Nft = ERCTOKEN(0x6079555928a48536E79bA424917beD02fFA78c04);
    IERC20 public  wrappedShm = IERC20(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6);
    struct Data {
        uint256 listingId;
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
          address creatorAddress = _data.message.From;
          uint256 tokenId = _data.message.tokenId;
          uint256 maxSupply = TokenIdentifiers.tokenMaxSupply(tokenId);
          uint256 currentSupply = Nft.totalSupply(tokenId);
          uint256 listingId = _data.message.listingId;
          uint256 cacheTokensFilled = tokensFilled[listingId];
          
          require(verifySignedPerson(_data) == creatorAddress,"Addres validation check failed");
          require(tokenId.tokenCreator() == creatorAddress,"Address validation check failed 2");
          
          require(_amountToBuy+currentSupply <= maxSupply, "Your purchase will exceed the supply of the tokens");
          //Umm couldn't find another way 
          //This would enable partial fill of tokens 
          require(_amountToBuy +cacheTokensFilled <= _data.message.AmountToSell, "Your amount exceeds maximum sale amount");  
          tokensFilled[listingId] = cacheTokensFilled + _amountToBuy;

          wrappedShm.safeTransferFrom(msg.sender,creatorAddress,_data.message.Price*_amountToBuy);
          Nft.mint(_to,tokenId,_amountToBuy,"");
            
    }


}
