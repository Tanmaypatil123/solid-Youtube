//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Comments {
    uint public videoId;

    struct Comment {
        address commentorAdd;
        string content;
    }

    mapping(uint => Comment) public comments;
    uint public commentCount;

    event Commented(
        uint commentid,
        string content,
        address commentorAdd
    );
    constructor(uint _id){
        videoId = _id;
        commentCount = 0;
    }
    function getVideoId() public view returns(uint){
        return videoId;
    }

    function CreateComment(string memory _content) public {
        commentCount++;
        Comment memory comment = comments[commentCount];
        comment.commentorAdd = msg.sender;
        comment.content = _content;
        comments[commentCount] = comment;
        emit Commented(
            commentCount,
            _content,
            msg.sender
        );
    }

    function getCommentsDetails(uint _id) public view returns (address, string memory){
        require(_id >=0 && _id <= commentCount);
        Comment memory comment = comments[_id];
        return (
        comment.commentorAdd,
        comment.content
        );
    }
}