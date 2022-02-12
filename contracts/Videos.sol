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
}