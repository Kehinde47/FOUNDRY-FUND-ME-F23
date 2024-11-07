// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
 address USER = makeAddr("user"); // prank value
 uint256 constant   SEND_VALUE = 0.1 ether;
 uint256 constant STARTING_VALUE = 10 ether;
 uint256 constant  GAS_PRICE = 1;


 FundMe fundMe;
    function setUp() external {
      DeployFundMe deployFundMe = new DeployFundMe(); 
      FundMe = deployFundMe.run();
      vm.deal(USER, STARTING_VALUE);
    }

    function testMinimumDollarisFive() public{
       assertEq(fundMe.MINIMUM_USD = 5 * 10 ** 18);
    }
    function testOwnerIsMsgSender() public{
    // console.log(funMe.i_owner());
    // console.log(msg.sender);
      assertEq(funMe.getOwner(), address(this));
    }
     function testPriceFeedVersionIsAccurate() public{
        uint256 version = fundMe.getVersion();
         assertEq(version, 4);
         
     }
     function testFundFailsWithoutEnoughETH() public{
       vm.expectRevert();

       fundMe.fund();
     }
      function testFundUpdatesFundedDataStructure() public{
       vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}() ;
        uint256 amountFunded = fundMe.getAddressToFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
     }
      function testAddFunderToArrayofFunders() public {
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
      }
      modifier funded {
         vm.prank(USER);
         fundMe.fund{value:SEND_VALUE}();
         _;
      }
       function testOnlyOwnerCanWithdraw() public funded{
       // vm.prank(USER);
        //fundMe.fund{value:SEND_VALUE}();  

        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
       }
        function testWithDrawWithASingleFunder() public funded {
         // ARRANGE
         uint256 startingOwnerBalance = fundMe.getOwner().balance;
         uint256 startingFundMeBalance = address(fundMe).balance;

         //ACT
           //uint256 gasStart = gasleft();
           //vm.txGasPrice(GAS_PRICE);
            vm.prank(fundMe.getOwner());
         fundMe.withdraw();

       //  uint256 gasEnd = gasleft();
         //uint256 gasUsed = (gasStart - gasEnd) * tx.gasPrice();
         //console.log(gasUsed);  

         //ASSERT
         uint256 endingOwnerBalance = fundMe.getOwner().balance;
         uint256 endingFundMeBalance = address(fundMe).balance;
         assertEq(endingFundMeBalance,0);
         assertEq(startingFundMeBalance + startingOwnerBalance , endingOwnerBalance);

        }
         function testWithdawFromMultipleFunders() public funded{
          uint160 numberofFunders = 10;
          uint160 startingFunderIndex = 1;
          for(uint256 i = startingFunderIndex; i < numberofFunders; i++){ 
             // vm.prank 
             // vm.deal
             hoax(address(i),SEND_VALUE);
             fundMe.fund{value:SEND_VALUE}();
             // vm.
          }
          //act
          uint256 gasStart = gasLeft();
          uint256 startingOwnerBalance = fundMe.getOwner().balance;
          uint256 staringFundMeBalance = address(fundMe).balance;
          vm.txGasPrice(GAS_PRICE);
          vm.prank(fundMe.getOwner());
          fundMe.withdraw();
          
          vm.stopPrank();
          //assert
          assert(address(fundMe).balance == 0);
          assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
         }
         //
         function testWithdawFromMultipleFundersCheaper() public funded{
          uint160 numberofFunders = 10;
          uint160 startingFunderIndex = 1;
          for(uint256 i = startingFunderIndex; i < numberofFunders; i++){ 
             // vm.prank 
             // vm.deal
             hoax(address(i),SEND_VALUE);
             fundMe.fund{value:SEND_VALUE}();
             // vm.
          }
          //act
          uint256 gasStart = gasLeft();
          uint256 startingOwnerBalance = fundMe.getOwner().balance;
          uint256 staringFundMeBalance = address(fundMe).balance;
          vm.txGasPrice(GAS_PRICE);
          vm.prank(fundMe.getOwner());
          fundMe.chepaerWithdraw();
          
          vm.stopPrank();
          //assert
          assert(address(fundMe).balance == 0);
          assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
         }
         //
}