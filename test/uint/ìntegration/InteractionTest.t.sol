// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../../../src/FundMe.sol";
import {DeployFundMe} from "../../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from  "../../../script/Interaction.s.sol";

contract InteractionTest is Test {
  FundMe fundMe;
 address USER = makeAddr("user"); // prank value
 uint256 constant   SEND_VALUE = 0.1 ether;
 uint256 constant STARTING_VALUE = 10 ether;
 uint256 constant  GAS_PRICE = 1;
  function setUp() external
  {
   DeployFundMe deploy  = new DeployFundMe();
    fundMe = deployFundMe.run();
    vm.deal(USER,STARTING_VALUE);
  }
   function testUserCanFundInteraction() public{
    FundFundMe fundFundMe  = new FundFundMe();
      fundFundMe.fundFundMe(address(fundMe));
      
      WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
      withdrawFundMe.withdrawFundMe(address(fundMe));
      assert(address(fundMe).balance == 0);
      vm.prank(USER);
      vm.deal(USER, 1e18);

  
  
    address funder = fundMe.getFunder(0);
     assertEq(funder, USER);
   }
}
 