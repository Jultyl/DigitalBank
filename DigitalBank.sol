//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DigitalBank {
    uint256 public balance;    
    mapping (address => uint256) AddressToBalanceAmount;
    address owner ;

    modifier onlyOwner () {
        if (msg.sender != owner) revert NotOwner();
        _;
    }


    function Deposit () external payable   {
        AddressToBalanceAmount[msg.sender] += msg.value;
        emit Deposited (msg.sender , msg.value);
    } 

    function Withdrawal (uint256 _withdrawalAmount) external {
        if (_withdrawalAmount > AddressToBalanceAmount[msg.sender]) revert NotSufficientBalance();
        AddressToBalanceAmount[msg.sender] -= _withdrawalAmount;
        (bool success, ) = payable(msg.sender).call{value: _withdrawalAmount}("");
        if (!success) revert TransferFail();        
        emit Withdrew (msg.sender , _withdrawalAmount);
    }

    function Transfer (address _transferToAccount, uint256 _transferAmount) external { 
        if (_transferAmount > AddressToBalanceAmount[msg.sender]) revert NotSufficientBalance();
        AddressToBalanceAmount[msg.sender] -= _transferAmount;
        AddressToBalanceAmount[_transferToAccount] += _transferAmount;
        (bool success, ) = payable(_transferToAccount).call{value: _transferAmount}("");
        if (!success) revert TransferFail();        
        emit Transferred (msg.sender, _transferToAccount, _transferAmount);
    }

    function CheckBalance (address _userAddress) external view returns(uint256) {
        return AddressToBalanceAmount[_userAddress] ;
    }

    function CheckTotalLiquidity () external view onlyOwner returns (uint256) {
        return address(this).balance ;
    }
}
