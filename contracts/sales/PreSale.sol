pragma solidity ^0.4.4;

import "../crowdsale/CappedCrowdsale.sol";
import "../crowdsale/RefundableCrowdsale.sol";
import "../crowdsale/BonusCrowdsale.sol";
import "../NousToken.sol";
import "./MainSale.sol";


/**
 * @title SampleCrowdsale
 * @dev This is an example of a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 * In this example we are providing following extensions:
 * CappedCrowdsale - sets a max boundary for raised funds
 * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract PreSale is CappedCrowdsale, RefundableCrowdsale, BonusCrowdsale {

	address nextSale;

	/*uint256 startTime = 1507059600; // Thu, 28 Sep 2017 16:35:00 GMT
    uint256 endTime = 1507060200; //
    uint256 rate = 6400; // 6400 NOUS => 1 ether => per wei;
    uint256 goal = 400000 * 1 ether; // min investment capital
    uint256 cap = 10000000 * 1 ether; // max capital in ether
    address wallet = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;


	function PreSale()
		CappedCrowdsale(cap)
		FinalizableCrowdsale()
		RefundableCrowdsale(goal)
		Crowdsale(startTime, endTime, rate, wallet)
		BonusCrowdsale()
	{
		//As goal needs to be met for a successful crowdsale
		//the value needs to less or equal than a cap which is limit for accepted funds
		require(goal <= cap);
	}*/


	function PreSale(
		uint256 _startTime,
		uint256 _endTime,
		uint256 _rate,
		uint256 _goal,
		uint256 _cap,
		address _wallet,
		uint256 _ms_startTime,
		uint256 _ms_endTime,
		address _restricted,
		uint256 _restrictedPercent
		)
		CappedCrowdsale(_cap)
		FinalizableCrowdsale()
		RefundableCrowdsale(_goal)
		Crowdsale(_startTime, _endTime, _rate, _wallet)
		BonusCrowdsale()
	{
		//As goal needs to be met for a successful crowdsale
		//the value needs to less or equal than a cap which is limit for accepted funds
		require(_goal <= _cap);

		//nextSale = createMainSale(_ms_startTime, _ms_endTime, _restricted, _restrictedPercent);
	}

	function createTokenContract() internal returns (MintableToken) {
		return new NousToken();
	}

	// finalize an add new sale.
	function finalize(address _nextSale) onlyOwner public {
		require(nextSale != 0x0);
		nextSale = _nextSale;
		super.finalize();
	}

	// pre sale finalization and chang owner in RefundVault and new sale
	function finalization() internal {
		require(nextSale != 0x0);
		token.transferOwnership(nextSale);
		vault.transferOwnership(nextSale);
	}
}

