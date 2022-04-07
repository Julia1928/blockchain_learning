# Blockchain_learning

### ERC20

-One of the most significant Ethereum tokens is known as ERC-20(Ethereum Request for Comment)

-It is a technical standard used for all smart contracts on the Ethereum blockchain for token implementation and provides a list of rules that all Ethereum-based tokens must follow

-In terms of implementation coding for ERC-20 tokens, the six basic coding functions are:

**totalSupply()**
    Returns the amount of tokens in existence.
    
**balanceOf(account)**
    Returns the amount of tokens owned by account
    
**allowance(owner , spender)**
    Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner through transferFrom. 
    
**transfer(to , amount)**
    Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner through transferFrom. 
    
**approve(spender , amount)**
    Sets amount as the allowance of spender over the caller’s tokens.Returns a boolean value indicating whether the operation succeeded
    
**transferFrom(from , to , amount)**
    Moves amount tokens from from to to using the allowance mechanism. amount is then deducted from the caller’s allowance.Returns a boolean value indicating whether the operation succeeded.

