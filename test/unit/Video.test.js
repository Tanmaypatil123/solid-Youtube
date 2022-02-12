const {assert,expect} = require("chai")
const {ethers} = require("hardhat")

describe("Video contract",function(){
  before(async function(){
    const Videos = await ethers.getContractFactory("VideoContract")
    videos = await Videos.deploy()
    await videos.deployed()
    accounts = await  ethers.getSigners()
    deployer = accounts[0]
  })
  it("checks deployment",async function(){
    const address = await videos.address
    assert.notEqual(address, 0x0)
    assert.notEqual(address, '')
    assert.notEqual(address, null)
    assert.notEqual(address, undefined)
  })
  it('should emit Video created event',async function(){
    const cid = "Qmeff4AvGELYTWUZD23s36VrPo6An24wywFxoDskjzVPJc"
    const transaction = await videos.UploadVideo(
      cid,"test title","test desc"
    )
    expect(transaction).to.emit(videos,'VideoCreated')
  })
})