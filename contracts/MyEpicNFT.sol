//SPDX-License-Identifier: MIT
/**
* MyEpicNFT   -
*               Solidity Contract for Buildspace course NFT Minting
*               Sept/2021
*               Trainer: Farza Majeed
*               Student: Roberto Vicuña
 */
pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

//Helper functions 
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {

  uint constant MAX_NFTS = 50;     // Max limit of NFT to mint

  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: black; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='orange' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // Three arrays, each with their own theme of random words.
  // The combination of words shall give a Fortune Cooky advice
  string[] firstWords = ["Always", "Remember", "Simply", "Never", "if lonely", "if sad", "Just", "When Angry","When Doubtful","When Happy"];
  string[] secondWords = [" Believe", " Trust In", " Distrust", " Disbelieve"," Blame"," Love"," Hate"," Complain Of"];
  string[] thirdWords = [" Yourself", " your Partner", " your Boss", " coWorkers"," neighbours"," Love", " Friends", " People", " Destiny", " Goverment"," Ethereum"];  

  // event to send the tokenId just minted
  event NewEpicNFTMinted(address sender, uint256 tokenId);


  // We need to pass the name of our NFTs token and it's symbol.
  constructor() ERC721 ("FortuneCookies", "NFTCOO") {
    console.log("This is my NFT contract. Woah!");
  }

  // Next three functions to randomly pick a word from each array and make an advice
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // Seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }
  // A function our user will hit to get their NFT.
  function makeAnEpicNFT() public {
     // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();
    console.log('Minting %s / %s', newItemId + 1 , MAX_NFTS);
     require (newItemId + 1 <= MAX_NFTS, "Cookies NFT limit reached");
  
    // Randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    // Concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of Fortune Cookies.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );    
    console.log("\n--------------------");
    // console.log(finalTokenUri);
    console.log(combinedWord);
    console.log("--------------------\n");


     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    // Update URI
    _setTokenURI(newItemId,finalTokenUri);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();
    //console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    
    // Now put out there the tokenId
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function getTotalNFTsMintedSoFar () public view returns (uint256) {
    return _tokenIds.current();
  }
}
