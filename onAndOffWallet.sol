//SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.8.17;

contract swithcWalletOnOff {

// add the the three state variables to your contract
// specify the owner
// add a true/false flag that will be used to indicate if the tokens can be sent   

    address owner;
    bool public transferable;
    mapping(address => uint) balanceOf;
    
   
      
    constructor() {
        owner = msg.sender;
    }

    function send() public payable {
       balanceOf[msg.sender] += msg.value;
    }


    function balance() public view returns(uint256) {
       return address(this).balance;
   }
   


    modifier isTransferable(bool _choice) {
        require(_choice, "Cannot send");
        _;
    }

      modifier onlyOwner() {
         require(msg.sender==owner, 'Not Owner');
         _;
    }

// Add a setter to change the transferable flag
    function canSend(bool _choice) public onlyOwner {
       transferable = _choice;
    }

// only the owner of the contract can call because onlyOwner modifier is specified
    function transfer(address _to, uint _value) public payable onlyOwner {
                
        if (_value > 0 && _value <= balanceOf[msg.sender]) {
            balanceOf[msg.sender] -=_value;
            balanceOf[_to] +=_value;
            canSend(transferable);
            (bool sent, ) = msg.sender.call{value: balanceOf[msg.sender]} ("");
            require(sent, "Ether not sent");
        }
    }

    }
