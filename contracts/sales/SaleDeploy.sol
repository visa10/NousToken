pragma solidity ^0.4.10;

import "./PreSale.sol";
import "./MainSale.sol";

contract SaleDeploy {

	address public preSaleAddress;

	//PreSaleDeploy
	uint256 startTime = 1507053000; // Thu, 28 Sep 2017 16:35:00 GMT
	uint256 endTime = 1507053300; //

	uint256 ms_startTime = 1507053300; // Thu, 28 Sep 2017 16:35:00 GMT
	uint256 ms_endTime = 1507053600; //

	uint256 rate = 6400; // 6400 NOUS => 1 ether => per wei;
	uint256 goal = 400000 * 1 ether; // min investment capital
	uint256 cap = 10000000 * 1 ether; // max capital in ether
	address wallet = 0x36fEC3E4dCc753e8fd9530aBd4f3660CE0A26a85;
	address restricted = 0xF3bFf43a82c33562269171a120BA26D4FBC7799A;
	uint256 restrictedPercent = 30;

	function SaleDeploy(){
		preSaleAddress = createPreSail();
	}

	function createPreSail() returns (address){
		return address(new PreSale(startTime, endTime, rate, goal, cap, wallet, ms_startTime, ms_endTime, restricted, restrictedPercent));
	}

}
