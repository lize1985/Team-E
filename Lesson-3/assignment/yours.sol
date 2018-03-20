pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    mapping(address => Employee) employees;
    uint cost = 0;


    modifier employeeExist(address employeeId){
        Employee storage employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier EmployeeNotExist(address employeeId){
        Employee storage employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment  = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner EmployeeNotExist(employeeId) public {
        employees[employeeId]=(Employee(employeeId, salary * 1 ether, now));
        cost = cost.add(salary * 1 ether);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        Employee storage employee = employees[employeeId];
        _partialPaid(employee);
        cost = cost.sub(employee.salary);

        delete employees[employeeId];

    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        Employee storage employee = employees[employeeId];
        _partialPaid(employee);
        cost = cost.add(salary * 1 ether);
        cost = cost.sub(employee.salary);
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;


    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance.div(cost);
    }
    
    function hasEnoughFund() public view returns (bool)  {
        return calculateRunway()>0;
    }
    
    function getPaid() employeeExist(msg.sender)  public {
        Employee storage employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employees[employee.id].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    function changePaymentAddress(address employeeId, address newaddress) onlyOwner employeeExist(employeeId) EmployeeNotExist(newaddress) public {
        addEmployee(newaddress,  employees[employeeId].salary);
        removeEmployee(employeeId);
    }
    
    
    function checkEmployee(address employeeId) public employeeExist(employeeId) view returns (uint salary, uint lastPayday){
        Employee storage employee = employees[employeeId];
        salary = employee.salary;
        lastPayday=employee.lastPayday;
    }
    
    function getCost() public view returns (uint){
        return cost;
    }
      
}
