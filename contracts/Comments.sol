//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Comments{
    uint public videoId;
    constructor(uint _id){
        videoId = _id;
    }
}