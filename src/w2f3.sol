contract WeiFlip {

    uint constant distance = 6; // distance required in blocks between prime call and reveal call
    uint public nonce = 1; // increments for each coinflip

    struct CoinFlip {
        bytes32 random;
        uint blockNumber;
        uint value;
        address heads;
        address tails;
    }
    
    enum result {
        Error,
        Heads,
        Tails
    }

    mapping ( uint=> CoinFlip ) public coinFlips;

    function prime(bytes32 random, uint blockNumber) returns (uint flipId) {
        return this.prime( random, blockNumber, msg.sender, msg.sender );
    }

    function prime(bytes32 random, uint blockNumber, address heads, address tails)  returns (uint flipId) {
        if (blockNumber < block.number + distance) {
            // blockNumber must be greater than $distance in the future
            return 0;
        }
        flipId = nonce++;
        coinFlips[ flipId ] = CoinFlip( random, blockNumber, msg.value, heads, tails);
        return flipId;
    }

    function reveal(uint flipId) returns (result) {
        
        CoinFlip flip = coinFlips[flipId];
        if (flip.blockNumber + distance < block.number) {
            // reveal can only be called after $distance blocks
            return result.Error;
        }
        var blockHash = block.blockhash( flip.blockNumber );
        var isHeads = uint160( sha3( blockHash, flip.random ) ) % 2 == 1;

        if (isHeads) {
            flip.heads.send( flip.value );
            delete coinFlips[flipId];
            return result.Heads;
        } else {
            flip.tails.send( flip.value );
            delete coinFlips[flipId];
            return result.Tails;
        }
        
    }
}
