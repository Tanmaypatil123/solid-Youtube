//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VideoContract {
    struct Video {
        string ipfsAddress;
        string title;
        string description;
        uint256 likes;
        uint256 dislilkes;
        uint256 tipamount;
        address payable owner;
    }
    struct Comment {
        address commentorAdd;
        string content;
    }
    mapping(uint256 =>  mapping(uint256 => Comment)) public comments;

    uint256 public commentCount = 0;

    event Commented(uint256 commentid, string content, address commentorAdd);

    mapping(uint256 => Video) public videos;

    uint256 public VideoCount = 0;

    event VideoCreated(
        string ipfsAddress,
        string title,
        string description,
        uint256 likes,
        uint256 dislilkes,
        uint256 tipamount,
        address payable owner
    );
    event VideoTipped(
        string ipfsAddress,
        string title,
        string description,
        uint256 likes,
        uint256 dislilkes,
        uint256 tipamount,
        address payable owner
    );

    event VideoLiked(string ipfsAddress, uint256 id);
    event VideoDisliked(string ipfsAddress, uint256 id);

    function UploadVideo(
        string memory _ipfsAdd,
        string memory _title,
        string memory _description
    ) public {
        require(bytes(_ipfsAdd).length > 0);
        require(bytes(_description).length > 0);
        require(bytes(_title).length > 0);
        VideoCount++;
        uint256 intial_likes = 0;
        uint256 intial_dislikes = 0;
        videos[VideoCount] = Video(
            _ipfsAdd,
            _title,
            _description,
            intial_likes,
            intial_dislikes,
            0,
            payable(msg.sender)
        );
        emit VideoCreated(
            _ipfsAdd,
            _title,
            _description,
            intial_likes,
            intial_dislikes,
            0,
            payable(msg.sender)
        );
    }

    function getVideoDetails(uint256 _id)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            address payable
        )
    {
        require(_id > 0 && _id <= VideoCount);
        Video memory _video = videos[_id];
        return (
            _video.ipfsAddress,
            _video.title,
            _video.description,
            _video.likes,
            _video.dislilkes,
            _video.tipamount,
            _video.owner
        );
    }

    function tipVideoOwner(uint256 _id) public payable {
        require(_id > 0 && _id <= VideoCount);
        Video memory _video = videos[_id];
        address payable _creator = _video.owner;
        payable(_creator).transfer(msg.value);
        _video.tipamount = _video.tipamount + msg.value;
        videos[_id] = _video;
        emit VideoTipped(
            _video.ipfsAddress,
            _video.title,
            _video.description,
            _video.likes,
            _video.dislilkes,
            _video.tipamount,
            _video.owner
        );
    }

    function likesTheVideo(uint256 _id) public {
        require(_id > 0 && _id <= VideoCount);
        Video memory _video = videos[_id];
        _video.likes = _video.likes + 1;
        videos[_id] = _video;
        emit VideoLiked(_video.ipfsAddress, _id);
    }

    function DislikesTheVideo(uint256 _id) public {
        require(_id > 0 && _id <= VideoCount);
        Video memory _video = videos[_id];
        _video.dislilkes = _video.dislilkes + 1;
        videos[_id] = _video;
        emit VideoDisliked(_video.ipfsAddress, _id);
    }

    function CreateComment(string memory _content) public {
        commentCount++;
        Comment memory comment = comments[VideoCount][commentCount];
        comment.commentorAdd = msg.sender;
        comment.content = _content;
        comments[VideoCount][commentCount] = comment;
        emit Commented(commentCount, _content, msg.sender);
    }

    function getCommentsDetails(uint256 _id)
        public
        view
        returns (address, string memory)
    {
        require(_id >= 0 && _id <= commentCount);
        Comment memory comment = comments[VideoCount][_id];
        return (comment.commentorAdd, comment.content);
    }
}
