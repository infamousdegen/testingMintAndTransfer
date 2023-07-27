// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import 'src/tokeIdentifiers.sol';

import "forge-std/console.sol";


contract AsterpodTest is Test {

    address owner = address(0x69);
    address depositor1 = address(0x50);
    address depositor2 = address(0x39);
    address random1 = address(0x420);
    address random2 = address(0x421);

    
    function setUp() public {

    }

    function testLibrary() public {
        console.log(TokenIdentifiers.tokenIndex(64652664769250025719079801724001666634496905276031147392014816059133911891969));
        console.log(TokenIdentifiers.tokenIndex(64652664769250025719079801724001666634496905276031147392014816058034400264193));
        console.log(TokenIdentifiers.tokenIndex(64652664769250025719079801724001666634496905276031147392014816056934888636417));
    }

    
}