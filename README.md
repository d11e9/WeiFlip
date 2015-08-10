# WeiFlip

![WeiFlip](/assets/img/flip.gif?raw=true "WeiFlip")

An Ethereum coin flip contract

###About

This contract is intended to be used by other contracts and not necesariliy by end users. Using WeiFlip is made up of 2 contract calls made in sequence.

The coin flip is perfomed by providing the contract with a random value and a blockNumber which must be at least n (default: 7) blocks in the future.

If sending value with your coin flip you must also pass in a heads_address and a tails_address to which all value will be sent depending on the outcome of the flip.

After n blocks anyone can call the reveal method with flipId (returned from previous call and stored in the contract) to have the outcome (and relevent value) sent to the appropriate address.


