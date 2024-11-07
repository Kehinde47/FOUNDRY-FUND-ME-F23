// SPDX-Lisence-Identifier:MIT
pragma solidity ^0.8.24;

import {Script,console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Scrpit {
   uint256 constant  SEND_VALUE = 0.01 ether;
   function WithdrawFundMe(address mostRecentlyDepolyed) public{ 
    vm.startBroadcast();
    FundMe(payable(mostRecentlyDepolyed)).withdraw(); 
    vm.stopBroadcast(); 
    // console.log("Funded FundMe with % s ", SEND_VALUE);                       
   }
   function run() external{
     address  mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
      "Fundme",
      block.chainId
     );
     //vm.startBroadCast();
     WithdrawFundMe(mostRecentlyDepolyed);
     //vm.stopBroadcast();
   }
}

contract WithdrawFundMe is Scrpit{}