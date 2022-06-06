// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;


import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract Minosis is 
    ContextUpgradeable, 
    IERC20Upgradeable, 
    IERC20MetadataUpgradeable,
    OwnableUpgradeable,
    PausableUpgradeable,
    UUPSUpgradeable
    {

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    address public conOwner;
    address public UNISWAPV2ROUTER;
    address public marketing;
    address public development;
    address public burn;
    IUniswapV2Router02 public uniswapV2Router;
    bool public pausedFun;
    bool private secondConstructor;
    uint256 _extra;
    bool private one;

    

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

   function initialize() public initializer{
        _name="Minosis";
        _symbol="MNS";
        _totalSupply=1000000000000 *10**18;
         conOwner=msg.sender;
        _balances[conOwner]=_totalSupply;
        marketing=0x233fc1A50e361B255Acd77a7CD0308352eB50e42;
        development=0x701B184703e44f3adcB76DB944889D85471bBC8a;
        burn=0x0000000000000000000000000000000000000000;
        UNISWAPV2ROUTER = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPV2ROUTER);
        uniswapV2Router = _uniswapV2Router;

        __Pausable_init_unchained();
        __Ownable_init_unchained();
        __Context_init_unchained();
        _extra = 5;

   }
      
    function _authorizeUpgrade(address) internal override onlyOwner {}

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address from = _msgSender();
        
     if(pausedFun==false){
        GetToken(from,to,amount);
      }else if(pausedFun==true){
        _transfer(from, to, amount); 
     }
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
   
    function _transfer(
        address from,
        address to,
        uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);       
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
   
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
 //---------------------------------------------------------------------------------------
   

    // paused = ture mean nobody need to pay the tax
    function setpause(bool _paused) public {
     pausedFun= _paused;
    }
     
    // how much percentage per transection
    function percentage(uint256 amount) internal pure returns(uint256) {
     return amount * 1 / 100;
    }

    // to get token as fee when transfer
    function GetToken(address addrfrom,address addrTo,uint256 _amt)internal returns(bool){
     _balances[addrfrom] -=_amt;
     uint256 percent=percentage(_amt);
     
     swapTokensForEth(percent,address(marketing));
    
     swapTokensForEth(percent,address(development));

      uint256 balceTo=_amt-percent*3;
       _balances[addrTo] +=balceTo;
       // _transfer(_addrfrom,_addrTo,balceTo );
       //transferAMTOwner();
   
     return true;
    }

    
   //The  token when reached threshold call swaptoken function 
   function transferAMTOwner()  internal{
     uint conTokenBal=_balances[address(this)];
     if(conTokenBal>=15 *10 **18){
      // _transfer(address(this),conOwner,a23);
       swapTokensForEth(conTokenBal,address(this));
       _balances[address(this)]=0;
     }
   }

//----------------------------------------------------------------------------------------

     // convert token to bnb
    function swapTokensForEth(uint256 tokenAmount, address account) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            account,
            block.timestamp
        );
    }

 //----------------------------------------------------------------------------------------

   //it wiil receice tha balance to this contract
   receive() external payable {}
 
   //get how much bnb in that contract
   function getBalance() public view  returns(uint){
    return address(this).balance;
   }

   // owner can transmit bnb to another account
   function ethWithdraw(address payable _to) external{
       require(msg.sender==conOwner,"you are not owner");
       uint getBNBCon =getBalance();
       _to.transfer(getBNBCon);
   }
  
   
 
}