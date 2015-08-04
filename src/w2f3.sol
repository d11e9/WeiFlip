contract WeiFlip {

    uint constant distance = 6; // distance required in blocks between prime call and reveal call
    uint nonce = 0; // increments for each coinflip

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

    mapping (uint => CoinFlip ) coinFlips;

    function prime(bytes32 random, uint blockNumber, address heads, address tails)  returns (bool ok){
        if (blockNumber < block.number + distance) {
            // blockNumber must be greater than $distance in the future
            return false;
        }
        var flipId = nonce++;
        coinFlips[ flipId ] = CoinFlip( random, blockNumber, msg.value, heads, tails );
        return true;
    }

    function reveal(uint flipId) returns (result ok) {
        
        CoinFlip flip = coinFlips[flipId];
        if (flip.blockNumber + distance < block.number) {
            // reveal can only be called after $distance blocks
            return result.Error;
        }
        var blockHash = block.blockhash( flip.blockNumber );
        var newHash = sha3( blockHash, flip.random );
        // TODO: line below is broken:
        // Type error: Indexed expression has to be a type, mapping or array (is bytes32)
        var newRandom = newHash.Get(0);
        if ((newRandom / 0xff) & 0x1) result.Heads;
        else result.Tails;
    }
}
