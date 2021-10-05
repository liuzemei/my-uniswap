//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./UniswapV2Pair.sol";
import "./interfaces/IUniswapV2Factory.sol";

contract UniswapV2Factory is IUniswapV2Factory {
    address public feeTo; // 收税地址
    address public feeToSetter; // 收税权限控制地址
    // 配对映射
    mapping(address => mapping(address => address)) public getPair;
    // 所有配对数组
    address[] public allPairs;
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    // 构造函数，手术开关权限控制
    constructor(address _feeToSetter) {
        console.log("Deploying a Greeter with greeting:", _feeToSetter);
        feeToSetter = _feeToSetter;
    }

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair)
    {
        require(tokenA != tokenB, "UniswapV2: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0), "UniswapV2: ZERO_ADDRESS");
        require(
            getPair[token0][token1] == address(0),
            "UniswapV2: PAIR_EXISTS"
        );

        //给 bytecode 变量赋值 UniswapV2Pair 合约的创建字节码
        bytes memory bytecode = type(UniswapV2Pair).creationCode;
        // 将 token0 和 token1 打包后创建哈希
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        // 内敛汇编
        // solium-disable-next-line
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        // 调用 pair 地址的合约中的 initialize 方法，传入变量 token0, token1
        IUniswapV2Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
        allPairs.push(pair);

        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeTo, "UniswapV2: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
