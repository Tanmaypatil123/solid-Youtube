const { assert, expect } = require("chai");
const { ethers } = require("hardhat");

describe("Video contract", function() {
  before(async function() {
    accounts = await ethers.getSigners();
    deployer = accounts[0];
    video_owner = accounts[1];
    user = accounts[2];
    const Videos = await ethers.getContractFactory("VideoContract");

    videos = await Videos.deploy();
    await videos.deployed();
  });
  it("checks deployment", async function() {
    const address = await videos.address;
    assert.notEqual(address, 0x0);
    assert.notEqual(address, "");
    assert.notEqual(address, null);
    assert.notEqual(address, undefined);
  });
  it("should emit Video created event", async function() {
    const cid = "Qmeff4AvGELYTWUZD23s36VrPo6An24wywFxoDskjzVPJc";
    const transaction = await videos.connect(video_owner).UploadVideo(
      cid, "test title", "test desc"
    );
    const res = await transaction.wait();
    const hash = res.events[0].args;
    expect(transaction).to.emit(videos, "VideoCreated");
    expect(hash[0]).to.equal(cid);
    expect(hash[1]).to.equal("test title");
    expect(hash[2]).to.equal("test desc");
    expect(hash[3]).to.equal(0);
    expect(hash[4]).to.equal(0);
    expect(hash[5]).to.equal(0);
    expect(hash[6]).to.equal(video_owner.address);
  });
  it("should add video in mapping", async function() {
    const VideoCount = await videos.VideoCount();
    const [ipfs, title, desc, likes, dislikes, tipamount, owner] = await videos.getVideoDetails(1);
    expect(VideoCount).to.equal(1);
    expect(ipfs).to.equal("Qmeff4AvGELYTWUZD23s36VrPo6An24wywFxoDskjzVPJc");
    expect(title).to.equal("test title");
    expect(desc).to.equal("test desc");
    expect(likes).to.equal(0);
    expect(dislikes).to.equal(0);
    expect(tipamount).to.equal(0);
    expect(owner).to.equal(video_owner.address);
  });
  it("should like the video", async function() {
    const likeTx = await videos.likesTheVideo(1);
    const likeRes = await likeTx.wait();
    const likeHash = likeRes.events[0].args;
    const [ipfs2, title2, desc2, likes2, dislikes2, tipamount2, owner2] = await videos.getVideoDetails(1);
    expect(likes2).to.equal(1);
    expect(likeHash[0]).to.equal("Qmeff4AvGELYTWUZD23s36VrPo6An24wywFxoDskjzVPJc");
    expect(likeHash[1]).to.equal(1);
  });
  it("should dislike the video",async function(){
    const dislikeTx = await videos.DislikesTheVideo(1)
    const dislikesRes = await dislikeTx.wait()
    const dislikesHash = dislikesRes.events[0].args;
    const [ipfs3, title3, desc3, likes3, dislikes3, tipamount3, owner3] = await videos.getVideoDetails(1);
    expect(dislikes3).to.equal(1)
    expect(dislikesHash[0]).to.equal("Qmeff4AvGELYTWUZD23s36VrPo6An24wywFxoDskjzVPJc")
    expect(dislikesHash[1]).to.equal(1)
  });
  it("should tip video owner with 1 ether",async function(){
    const transactionTip = await  videos.tipVideoOwner(1,{
      value:ethers.utils.parseEther("1.0")
    })
    const tipRes = await transactionTip.wait()
    const tipHash = await tipRes.events[0].args
    const [ipfs4, title4, desc4, likes4, dislikes4, tipamount4, owner4] = await videos.getVideoDetails(1);
    expect(tipHash[5]).to.equal(ethers.utils.parseEther("1.0"))
    expect(tipamount4).to.equal(ethers.utils.parseEther("1.0"))
  })
});