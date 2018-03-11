/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint salary;
    address receiver;
    address owner;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    // Assume that the contract who created is the owner of the Payroll
    function Payroll() payable {
        owner = msg.sender;
    }
    
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    // Assume that only the owner of the payroll system can set the salary
    function setSalary() payable returns(uint){
        if(msg.sender != owner) {
            revert();
        }
        salary = msg.value;
        return salary;
    }
    
    function registerReceiver() returns(address){
        receiver = msg.sender;
        return receiver;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() >0;
    }

    function getPaid() {
        if(msg.sender != receiver) {
            revert();
        }
        
        uint nextPayDay = lastPayday + payDuration;
        if ( nextPayDay> now) {
            revert();
        }
        
        lastPayday = lastPayday + payDuration;
        receiver.transfer(salary);
    }    
    
}
