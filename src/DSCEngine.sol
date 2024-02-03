//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;


/**
 * @title DSCEngine
 * @author hexbyte
 * @notice The system is designed to be as minimal as possible and have the tokens maintain a 1 token == 1$ peg.
 * The stablecoin has the properties:
 * - Exogenous Collateral
 * - Dollar pegged
 * - Algorithmically Stable
 * 
 * It is similar to DAI if DAI had no governance, no fees and only backed by WETH and WBTC.
 * 
 * Our DSC system should always be overcollateralized. AT no point, should the collateral summed together be less 
 * than or equal to the USD backed value of all the DSC.
 * 
 * @notice This contract is the core of the DSC System. It handles all the logic for mining and redeeming DSC, 
 * as well as depositing and withdrawing collateral.
 * @notice This contract is very loosely based on DAI on the MakerDAO DSS (DAI) system.
 */
contract DSCEngine {

    /////////////////
    ////ERRORS     //
    /////////////////

    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();

    /////////////////////////
    ////STATE MAPPINGS     //
    /////////////////////////
    mapping(address token => address priceFeed) private s_priceFeeds;


    /////////////////
    ////MODIFIERS  //
    /////////////////

    modifier moreThanZero(uint256 amount){
        if (amount == 0){
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    // modifier isAllowedToken(address token){

    // }


    /////////////////
    ////FUNCTIONS  //
    /////////////////

    constructor(
        address[] memory tokenAddresses, 
        address[] memory priceFeedAddresses,
        address dscAddress
        ) {
            if(tokenAddresses.length != priceFeedAddresses.length){
                revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
            }

            for (uint256 i; i < tokenAddresses.length; i++){
                s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            }
        }

    //////////////////////////
    ////EXTERNAL FUNCTIONS  //
    //////////////////////////
    
    function depositCollateralAndMintDsc() external {

    }

    /**
     * 
     * @param tokenCollateralAddress The address of the token to deposit as collateral.
     * @param amountCollateral The amount of collateral to deposit.
     */

    function depositCollateral(
        address tokenCollateralAddress,
        uint256 amountCollateral
        ) external moreThanZero(amountCollateral) {

        }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}
    
    function mintDsc() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}



    

}