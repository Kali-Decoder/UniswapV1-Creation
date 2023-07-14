// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {
    // Future code goes here
    address public erc20;

    constructor(address _erc20) ERC20("ETH TOKEN LP Token", "lpETHTOKEN") {
        require(_erc20 != address(0), "Invalid ERC20 address");
        erc20 = _erc20;
    }

    /// @notice Function to deposit ERC20 tokens and mint LP tokens
    /// @dev The ERC20 tokens are transferred from the caller to the contract
    /// @return balance The amount of LP tokens minted to the user

    function getReserve() public view returns (uint balance) {
        balance = ERC20(erc20).balanceOf(address(this));
    }

    ///    @notice Function to deposit ERC20 tokens and mint LP tokens
    ///    @dev The ERC20 tokens are transferred from the caller to the contract
    ///    @param amountOfToken The amount of ERC20 tokens to deposit
    ///    @return lpTokensToMint The amount of LP tokens minted to the user

    function addLiquidity(
        uint amountOfToken
    ) public payable returns (uint256 lpTokensToMint) {
        uint ethReserveBalance = address(this).balance;
        uint tokenReserveBalance = getReserve();
        ERC20 token = ERC20(erc20);
        if (tokenReserveBalance == 0) {
            token.transferFrom(msg.sender, address(this), amountOfToken);
            lpTokensToMint = ethReserveBalance;
            _mint(msg.sender, lpTokensToMint);
            return lpTokensToMint;
        }
        // x*y=k && (x + &x)(y - &y)=k by solving this we get &y=
        uint ethReservePriorToFunctionCall = ethReserveBalance - msg.value;
        uint mintTokenAmountRequired = (msg.value * tokenReserveBalance) /
            ethReservePriorToFunctionCall;

        require(
            amountOfToken >= mintTokenAmountRequired,
            "Insufficient amount of tokens provided"
        );
        token.transferFrom(msg.sender, address(this), mintTokenAmountRequired);
        lpTokensToMint =
            (totalSupply() * msg.value) /
            ethReservePriorToFunctionCall;

        // Mint LP tokens to the user
        _mint(msg.sender, lpTokensToMint);
        return lpTokensToMint;
    }

    ///@notice Function to withdraw ERC20 tokens and burn LP tokens
    ///@param amountOfLPTokens The amount of LP tokens to burn
    ///@dev The ERC20 tokens are transferred from the contract to the caller
    ///@return The amount of ETH and tokens returned to the user

    function removeLiquidity(
        uint amountOfLPTokens
    ) public returns (uint256, uint256) {
        require(
            amountOfLPTokens > 0,
            "Amount of tokens to remove must be greater than 0"
        );

        uint256 ethReserveBalance = address(this).balance;
        uint256 lpTokenTotalSupply = totalSupply();
        // Calculate the amount of ETH and tokens to return to the user
        uint256 ethToReturn = (ethReserveBalance * amountOfLPTokens) /
            lpTokenTotalSupply;
        uint256 tokenToReturn = (getReserve() * amountOfLPTokens) /
            lpTokenTotalSupply;

        // Burn the LP tokens from the user, and transfer the ETH and tokens to the user
        _burn(msg.sender, amountOfLPTokens);
        payable(msg.sender).transfer(ethToReturn);
        ERC20(erc20).transfer(msg.sender, tokenToReturn);

        return (ethToReturn, tokenToReturn);
    }

    /// @notice Function to swap ERC20 tokens for ETH
    ///@param inputAmount as a value
    ///@param inputReserve as a value
    ///@param outputReserve as a value
    ///@dev The ERC20 tokens are transferred from the caller to the contract
    ///@return value The amount of value returned to the user

    function _getOutputAmountFromSwap(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) private pure returns (uint256 value) {
        require(
            inputReserve > 0 && outputReserve > 0,
            "Reserves must be greater than 0"
        );

        uint256 inputAmountWithFee = inputAmount * 99;

        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;

        value = numerator / denominator;
    }

    /// @notice Function to swap ERC20 tokens for ETH
    ///@dev The ERC20 tokens are transferred from the caller to the contract
    ///@param minTokensToReceive The minimum amount of tokens to receive from the swap

    function ethToTokenSwap(uint256 minTokensToReceive) public payable {
        uint256 tokenReserveBalance = getReserve();
        uint256 tokensToReceive = _getOutputAmountFromSwap(
            msg.value,
            address(this).balance - msg.value,
            tokenReserveBalance
        );

        require(
            tokensToReceive >= minTokensToReceive,
            "Tokens received are less than minimum tokens expected"
        );

        ERC20(erc20).transfer(msg.sender, tokensToReceive);
    }

    /// @notice Function to swap ETH for ERC20 tokens
    /// @dev The ERC20 tokens are transferred from the contract to the caller
    /// @param tokensToSwap The amount of tokens to swap
    /// @param minEthToReceive The minimum amount of ETH to receive from the swap

    function tokenToEthSwap(
        uint256 tokensToSwap,
        uint256 minEthToReceive
    ) public {
        uint256 tokenReserveBalance = getReserve();
        uint256 ethToReceive = _getOutputAmountFromSwap(
            tokensToSwap,
            tokenReserveBalance,
            address(this).balance
        );

        require(
            ethToReceive >= minEthToReceive,
            "ETH received is less than minimum ETH expected"
        );

        ERC20(erc20).transferFrom(msg.sender, address(this), tokensToSwap);

        payable(msg.sender).transfer(ethToReceive);
    }
}
