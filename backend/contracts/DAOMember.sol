//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

interface MemberNFT {
    function balanceOf(address owner) external view virtual returns (uint256);

    function safeMint(address to) external;
}

contract DAOMember {
    struct ResearchPaper {
        address researcher;
        uint256 dateOfPublication; //time when the paper is published
        string researchPaperURI;
    }
    struct Member {
        address memberAddress;
        string name;
        string bio;
        uint256 yayVotes;
        uint256 nayVotes;
        bool approved; /// if the person is approved by the DAO members or not
        string pfpURI; /// profile picture URI
        string foR; /// field of research
        string[] researchesURI; /// string array of ipfsURI
    }

    /// cases for voting for adding a member
    enum Vote{
        YES,
        NO
    }

    uint256 public votingDuration = 2 days;

    uint256 public startVotingTime;

    uint256 public counterResearches = 0;
    uint256 public counterMembers = 0;
    uint256 public counterRequestList = 0;

    MemberNFT nft;

    /// record of all the members of the DAO for their details
    mapping(uint256 => Member) public membersList;

    /// requests to add new member
    mapping(uint256 => Member) public requestList;

    /// mapping from memberAddress -->  research paper
    mapping(address => ResearchPaper) public membersPaperList;

    /// mapping from researchNo -->researchPaper
    mapping(uint256 => ResearchPaper) public researchesPublishedList;

    constructor(address NFT) {
        nft = MemberNFT(NFT);
    }

    modifier onlyDAOMember() {
        require(nft.balanceOf(msg.sender) > 0, " You are not a DAO member");
        _;
    }

    /// @dev - To add the research
    /// @param  researchPaperURI -ipfs uri for the research

    function addResearch(string memory researchPaperURI) public onlyDAOMember {
        /// add the research to the common ResearchPaper Array to show it to all s
        researchesPublishedList[counterResearches] = ResearchPaper(
            msg.sender,
            block.timestamp,
            researchPaperURI
        );

        counterResearches += 1;

        /// adds the research for the specific member
        membersPaperList[msg.sender] = ResearchPaper(
            msg.sender,
            block.timestamp,
            researchPaperURI
        );
    }

    /// add member to the members array
    /// also mints the NFT from our contract directly to the user , will be easy to call it here
    function addMember(
        address _member,
        string memory _name,
        string memory _pfp,
        bool approved
    ) public onlyDAOMember {

    }

    function addRequest(string memory _name, string memory _bio, string memory _pfpURI, string memory _foR, string[] researchesURI) public {
        requestList[counterRequestList] = Member(msg.sender, _name, _bio, false, _pfpURI, _foR, researchesURI);
        counterRequestList+=1;
        startVotingTime = block.timestamp;
    }

    // voting function for requested member
    function approve(Vote vote, uint _id) public {
        require(block.timestamp > startVotingTime, "You can't approve this person before the voting starts");
        require(startVotingTime + votingDuration < block.timestamp, "Voting has already ended");
        Member storage member = requestList[_id];
        if(vote = Vote.YES)
            member.yayVotes += 1;
        else
            member.nayVotes += 1;
    }

    function getResearch() public view returns () {}

    function getMembers() public view returns () {}
}
