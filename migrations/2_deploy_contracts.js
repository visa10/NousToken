var PreSale = artifacts.require("./PreSale.sol");
var MainSale = artifacts.require("./MainSale.sol");


module.exports = function(deployer) {
    deployer.deploy([PreSale]);
};
