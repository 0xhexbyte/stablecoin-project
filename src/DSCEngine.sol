//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
contract DSCEngine is ReentrancyGuard {
    /////////////////
    ////ERRORS     //
    /////////////////

    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine_NotAllowedToken();
    error DSCEngine__TransferFailed();

    /////////////////////////
    ////STATE MAPPINGS     //
    /////////////////////////
    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping (address user => uint256 amountDscMinted) private s_DSCMinted;

    DecentralizedStableCoin private immutable i_dsc;

    /////////////////
    ////EVENTS     //
    /////////////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);
    
    /////////////////
    ////MODIFIERS  //
    /////////////////

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine_NotAllowedToken();
        }
        _;
    }

    /////////////////
    ////FUNCTIONS  //
    /////////////////

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    //////////////////////////
    ////EXTERNAL FUNCTIONS  //
    //////////////////////////

    function depositCollateralAndMintDsc() external {}

    /**
     * @notice Follows CEI
     * @param tokenCollateralAddress The address of the token to deposit as collateral.
     * @param amountCollateral The amount of collateral to deposit.
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success){
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    /**
    @notice Follows CEI
    @param amountDscToMint The amount of centralised stablecoin to mint
    @notice They must have more collateral value than the minimum threshold
     */
    function mintDsc(uint256 amountDscToMint) external moreThanZero(amountDscToMint) nonReentrant {
        s_DSCMinted[msg.sender] += amountDscToMint;
        // Revert if health factor is broken
        revertIfHealthFactorIsBroken(msg.sender);
    }

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    ////////////////////////////////////
    ////PRIVATE & INTERNAL FUNCTIONS  //
    ////////////////////////////////////

    function _healthFactor(address user) private view returns(uint256){

    }

    function _revertIfHealthFactorIsBroken(address user) internal view {
        // 1. Check health factor (enough collateral?)
        // 2. Revert if not
    }
}
