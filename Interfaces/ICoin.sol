pragma solidity ^0.8.0;

interface ICoin {

    function mint(address account, uint256 amount) external returns(bool);

   
    function burn(address account, uint256 amount) external returns(bool);
}
