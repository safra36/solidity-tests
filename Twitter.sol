// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// A contract representing a simple Twitter-like application
contract Twitter {
    // Struct to represent a tweet
    struct Tweet {
        string text; // The content of the tweet
        uint40 like_count; // The number of likes the tweet has received
        address owner; // The address of the user who posted the tweet
        bool locked; // A flag indicating whether the tweet is locked (cannot be liked)
    }

    // Mapping to store tweets by their ID
    mapping(uint64 => Tweet) tweets;

    // The address of the contract owner
    address owner;

    // The ID of the next tweet to be created
    uint64 id;

    // Constructor to initialize the contract
    constructor() {
        id = 0;
        owner = msg.sender; // Set the contract owner to the deployer
    }

    // Modifier to ensure that only the owner can execute a function
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can lock tweets");
        _;
    }

    // Modifier to ensure that a tweet is not locked before executing a function
    modifier notLocked(uint64 tweet_id) {
        require(tweets[tweet_id].locked == false, "tweet is locked");
        _;
    }

    // Function to post a new tweet
    function send_tweet(string memory text) public {
        Tweet memory t = Tweet(text, 0, msg.sender, false); // Create a new Tweet struct
        tweets[id] = t; // Store the tweet in the mapping
        id++; // Increment the tweet ID
    }

    // Function to like a tweet
    function like_tweet(uint64 tweet_id) public notLocked(tweet_id) {
        require(tweet_id < id, "tweet id is not available"); // Ensure the tweet ID is valid
        tweets[tweet_id].like_count++; // Increment the like count for the tweet
    }

    // View function to retrieve a tweet
    function get_tweet(uint64 tweet_id) public view notLocked(tweet_id) returns (Tweet memory) {
        return tweets[tweet_id]; // Return the tweet from the mapping
    }

    // Function to lock a tweet (only accessible by the owner)
    function lock_tweet(uint64 tweet_id) public onlyOwner {
        tweets[tweet_id].locked = true; // Set the locked flag for the tweet to true
    }
    
}