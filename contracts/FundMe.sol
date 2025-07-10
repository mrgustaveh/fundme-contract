// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error NotOwner();

error AmountTooLow();

error TransactionFailed();

contract FundMe{
    address public immutable i_owner;
    uint256 public constant MIN_AMOUNT = 1e14;

    constructor() {
        i_owner = msg.sender;
    }

    function fundContract() public payable {
        if(msg.value < MIN_AMOUNT){
            revert AmountTooLow();
        }
    }

    receive() external payable { fundContract(); }

    fallback() external payable { fundContract(); }

    function withdraw() public ownerAction  {
        /*Transfer*/
        // payable(msg.sender).transfer(address(this).balance);

        /*Send*/
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Transaction with send failed");
        
        /*Call*/
        (bool callSuccess,) = payable (msg.sender).call{value:address(this).balance}("");
        if(!callSuccess){
            revert TransactionFailed();
        }
    }

    modifier ownerAction(){
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
}