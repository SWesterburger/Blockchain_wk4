pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract PupperCoinSale is Crowdsale, MintedCrowdsale, TimedCrowdsale,CappedCrowdsale, RefundablePostDeliveryCrowdsale {
    constructor(
        uint rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        PupperCoin token, 
        uint open_time,
        uint close_time,
        uint goal // the ArcadeToken itself that the ArcadeTokenSale will work with
    )
        
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(open_time, close_time)
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        RefundablePostDeliveryCrowdsale()
        public
    {
        // constructor can stay empty
    }
}

contract PCSaleDeployer {

    address public token_sale_address;
    address public token_address;
    uint open_time;
    uint close_time;
    uint goal=300000000000000000000;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all Ether raised by the sale
    )
        public
    {
        // create the ArcadeToken and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);
        
        open_time=now;
        close_time=open_time+24 weeks;

        // create the ArcadeTokenSale and tell it about the token
        PupperCoinSale token_sale = new PupperCoinSale(1, wallet, token, open_time, close_time, goal);
        token_sale_address = address(token_sale);

        // make the ArcadeTokenSale contract a minter, then have the ArcadeTokenSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
    
    
    
    

