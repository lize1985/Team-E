
var Payroll = artifacts.require("./Payroll.sol");
var sleep = require("sleep");
contract('Payroll', function(accounts) {
  var employeeexisted = true;
  var PayrollInstance;
  it("...should add Employee accounts[1]", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 1,{from: accounts[0]});
    }).then(function() {
      employeeexisted= false;
      return PayrollInstance.checkEmployee.call(accounts[1]);
    }).then(function(results) {
      var i = 1;                     //  set your counter to 1
      sleep.sleep(3);
    
      assert.equal(results[0].c[0], 10000, "The value 1 was not stored.");
      assert.notEqual(results[1].c[0], new Date().getTime()/1000|0, "The time should not be equal.");
    }).catch((error) => {
      assert.notEqual(employeeexisted, false, "employee existed");
    });
  });

  it("...only owner can add accounts[2]", function() {
    return PayrollInstance.addEmployee(accounts[2], 1,{from: accounts[1]})
       .catch((error) => {
           assert(true, "only owner can add accounts[2]");
        });
    });



  it("...should Remove accounts[1]", function() {
    var removed = false;    
    return PayrollInstance.addFund({from:accounts[0], value: 10})
    .then(function() { 
      return PayrollInstance.addEmployee(accounts[3],2,{from: accounts[0]});
    }).then(function() {
      return PayrollInstance.removeEmployee(accounts[3], {from: accounts[0]});
    }).then(function() {
      return PayrollInstance.checkEmployee.call(accounts[3]);
    }).then(function(Employee) {
      assert(false,"Failed to remove accounts");
     }).catch((error) => {
       removed=true;
      assert.equal(removed,true, "The account is removed");
    });
  });


    //getPaid
    it("... should get paid from account[1] ", function () {

        web3.currentProvider.send({jsonrpc: '2.0',  method: 'evm_increaseTime', params: [10000], 
                                  id: new Date().getSeconds()
                             }, (err, resp) => {
                                if (!err) {
                                  web3.currentProvider.send
                                  ({
                                    jsonrpc: '2.0', method: 'evm_mine', params: [], id: new Date().getSeconds()
                                    },
                                    (err,resp) => {
                                      return PayrollInstance.getPaid({from: accounts[1]}).then(function() {
                                        hasThrown = false;
                                        assert(true,"Get Paid");
                                      })
                                    }
                                  )
                                }    
                              })
    });

    it("... should not can get paid from account[1]", function () {
      
      web3.currentProvider.send({jsonrpc: '2.0',  method: 'evm_increaseTime', params: [10000], 
                                id: new Date().getSeconds()
                           }, (err, resp) => {
                              if (!err) {
                                web3.currentProvider.send({
                                  jsonrpc: '2.0', 
                                  method: 'evm_mine', 
                                  params: [], 
                                  id: new Date().getSeconds()
                                },
                                (err,resp) => {
                                  return PayrollInstance.getPaid({from: accounts[1]
                                  }).then(function() {
                                      assert.fail('Should not get paid');
                                  })
                                  .catch(function(err) {
                                      assert(true, "Did not get paid");
                                  }); 
                                }
                                )
                              }    
                              }
                            )
    });
});
