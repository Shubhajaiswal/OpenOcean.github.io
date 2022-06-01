pragma solidity ^0.8.0;

import "../interfaces/IVault.sol";
import "./Coin.sol";
import "./PriceConsumerV3.sol";
import "./MockOracle.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Vault is IVault, Ownable {

    mapping (address => Vault) vaults;
    StableCoinToken public token;
    PriceConsumerV3 private oracle;
    

    constructor(StableCoinToken _token, PriceConsumerV3 _oracle){
        token = _token;
        oracle = _oracle;
    }

    
    function deposit(uint256 amountToDeposit) override payable external {
        require(amountToDeposit == msg.value, "incorrect ETH amount");
        uint256 amountToMint = amountToDeposit * getEthUSDPrice();
        token.mint(msg.sender, amountToMint);
        vaults[msg.sender].collateralAmount += amountToDeposit;
        vaults[msg.sender].debtAmount += amountToMint;
        emit Deposit(amountToDeposit, amountToMint);
    }
    
  
    function withdraw(uint256 repaymentAmount) override external {
        require(repaymentAmount <= vaults[msg.sender].debtAmount, "withdraw limit exceeded"); 
        require(token.balanceOf(msg.sender) >= repaymentAmount, "not enough tokens in balance");
        uint256 amountToWithdraw = repaymentAmount / getEthUSDPrice();
        token.burn(msg.sender, repaymentAmount);
        vaults[msg.sender].collateralAmount -= amountToWithdraw;
        vaults[msg.sender].debtAmount -= repaymentAmount;
        payable(msg.sender).transfer(amountToWithdraw);
        emit Withdraw(amountToWithdraw, repaymentAmount);
    }

    function getVault(address userAddress) external view override returns(Vault memory vault) {
        return vaults[userAddress];
    }
    
    function estimateCollateralAmount(uint256 repaymentAmount) external view override  returns(uint256 collateralAmount) {
        return repaymentAmount / getEthUSDPrice();
    }
    
 
    function estimateTokenAmount(uint256 depositAmount) external view override returns(uint256 tokenAmount) {
        return depositAmount * getEthUSDPrice();
    }

    function getEthUSDPrice() public view returns (uint256){
        uint price8 = uint(oracle.getLatestPrice());
        return price8*(10**10);
    }

    function getToken() external view returns (address){
        return address(token);
    }

    function setOracle(address _oracle) public onlyOwner {
        oracle = PriceConsumerV3(_oracle);
    }

    function getOracle() public view returns (address) {
        return address(oracle);
    }
}
