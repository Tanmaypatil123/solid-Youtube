//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract UsersContract {
    struct User {
        address payable userAddress;
        string name;
        bool exists;
    }
    mapping(address => User) public Users;
    event UserAdded(address indexed account);
    function addUser(address account,string memory _name) public {
        User memory newUser = User(payable(account),_name,true);
        Users[account] = newUser;
        emit UserAdded(account);
    }
    function isUser(address account) public view returns(bool){
        if(Users[account].exists == true){
            return true;
        }else{
            return false;
        }
    }
    modifier onlyUser() {
        require(Users[msg.sender].exists == true,"You are not registered User");
        _;
    }
}