pragma solidity ^0.4.4;

import "../crowdsale/CappedCrowdsale.sol";
import "../crowdsale/RefundableCrowdsale.sol";
import "../crowdsale/BonusCrowdsale.sol";
import "../NousToken.sol";
import "../token/MintableToken.sol";
import "../crowdsale/RefundVault.sol";


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
contract MainSale is CappedCrowdsale, RefundableCrowdsale, BonusCrowdsale {

	address restricted;
	uint256 restrictedPercent;

	function MainSale(
		uint256 _startTime,
		uint256 _endTime,
		uint256 _rate,
		uint256 _goal,
		uint256 _cap,
		address _wallet,
		address _restricted,
		uint256 _restrictedPercent,
		address _tokenAddress,
		address _vaultAddress
		)
		CappedCrowdsale(_cap)
		FinalizableCrowdsale()
		RefundableCrowdsale(_goal)
		Crowdsale(_startTime, _endTime, _rate, _wallet)
		BonusCrowdsale()
	{
		require(_restricted != 0x0);
		restricted = _restricted;

		require(_restrictedPercent > 0);
		restrictedPercent = _restrictedPercent;

		//require(_token != 0x0);
		token = MintableToken(_tokenAddress);

		vault = RefundVault(_vaultAddress);

		//As goal needs to be met for a successful crowdsale
		//the value needs to less or equal than a cap which is limit for accepted funds
		require(goal <= cap);
	}

	// finalize an add new sale.
	function finalize() onlyOwner public {
		super.finalize();
	}

	// pay restricted percent
	function finalization() internal {
		uint256 totalSupply = token.totalSupply();
		uint restrictedTokens = totalSupply.mul(restrictedPercent).div(100);
		token.mint(restricted, restrictedTokens);
		token.finishMinting();
		super.finalization();
	}

	// set time sale
	function setTime(uint256 _startTime, uint256 _endTime) onlyOwner public {
		require(_startTime < _endTime);
		startTime = _startTime;
		endTime = _endTime;
	}

}
