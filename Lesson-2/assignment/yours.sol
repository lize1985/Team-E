pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    uint cost = 0;

    function Payroll() public {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment  = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private view returns (Employee, uint) {
        for(uint i=0; i<employees.length;i++){
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        cost = cost + salary;
        employees.push(Employee(employeeId, salary, now));
    }
    
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        cost = cost - employee.salary;
        assert(cost>=0);
        
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -=1;
    }
    
    function updateEmployee(address employeeId, uint salary) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        cost = cost - employee.salary;
        assert(cost>=0);
        cost = cost + salary;
        _partialPaid(employee);
        employees[index].salary = salary;
        employees[index].lastPayday = now;

    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance / cost;
    }
    
    function hasEnoughFund() public view returns (bool)  {
        return calculateRunway()>0;
    }
    
    function getPaid() public {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0); 
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    function getNumberOfEmployees() public view returns (uint) {
        return employees.length;
    }
    
    function getSalaryOfEmployee(address employeeId) public view returns (uint){
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0); 
        
        return employees[index].salary;
    }
}
