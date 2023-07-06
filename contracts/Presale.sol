// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PresaleUMBA is Ownable {
    address public tokenAddress = 0xE187d7175756d806b7417B68dAd794bd43795F7d; // UMBA token address, place after deploy of UMBA
    address public UsdtAddress = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // USDT address  https://etherscan.io/token/0xdac17f958d2ee523a2206206994597c13d831ec7 ;

    uint256 public tokenPerUsdt = 125 * 10 ** 17; // 12.5 Token = 1 USDT
    uint256 public minBuyUsdt = 100; // Min buy 100 USDT

    uint256 public amountRaisedUsdt;

    function buyTokens(uint256 _amountUSDT) public {
        require(_amountUSDT >= minBuyUsdt);

        uint256 weiAmountUSDT = _amountUSDT * 10 ** 6;

        IERC20 USDT = IERC20(UsdtAddress);
        require(USDT.transferFrom(msg.sender, address(this), weiAmountUSDT));

        uint256 tokenAmount = _amountUSDT * tokenPerUsdt;
        amountRaisedUsdt = amountRaisedUsdt + (_amountUSDT);

        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, tokenAmount);
    }

    function changePrice(uint256 _price) external onlyOwner {
        tokenPerUsdt = _price;
    }

    function changeMinimumLimits(uint256 _minBuyUSDT) external onlyOwner {
        minBuyUsdt = _minBuyUSDT;
    }

    function transferTokens(uint256 _value) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, _value);
    }

    function transferUsdt(uint256 _value) external onlyOwner {
        IERC20 USDT = IERC20(UsdtAddress);
        USDT.transfer(msg.sender, _value);
    }
}
