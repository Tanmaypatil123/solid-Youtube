//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IComments{
    function getVideoId() external returns(uint);
    function CreateComment(string memory _content) external;
    function getCommentsDetails(uint _id) external view returns (address, string memory);
}