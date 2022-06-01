pragma solidity ^0.8.0;

interface IVault {
    struct Vault {
        uint256 collateralAmount; 
        uint256 debtAmount; 
    }

    event Deposit(uint256 collateralDeposited, uint256 amountMinted);
    event Withdraw(uint256 collateralWithdrawn, uint256 amountBurned);
    
  
    function deposit(uint256 amountToDeposit) payable external;
    
   
    function withdraw(uint256 repaymentAmount) external;
    
   
    function getVault(address userAddress) external view returns(Vault memory vault);
    
    
    function estimateCollateralAmount(uint256 repaymentAmount) external view returns(uint256 collateralAmount);
    
 
    function estimateTokenAmount(uint256 depositAmount) external view returns(uint256 tokenAmount);
}
