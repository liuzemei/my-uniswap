# my uniswap
1. 旨在学习 uniswap 智能合约。
2. 顺便部署一个 uniswap

# uniswap 运行逻辑
1. uniswap 核心合约分为 3 个合约，工厂合约，配对合约，ERC20合约
2. 核心合约部署时只需要部署工厂合约
3. 工厂合约部署时构造函数只需要设定一个手续费管理员
4. 在工厂合约部署之后，就可以进行创建配对的操作
5. 要在交易所中进行交易，操作顺序是：创建交易对，添加流动性，交易。
6. 添加配对时需要提供两个 token 的地址，随后工厂合约会为这个交易对部署一个新的配对合约。
7. 配对合约的部署是通过 create2 的方法
8. 两个 token 地址按 2 禁止大小排序后一起进行 hash，以这个 hash 值作为 create2 的 salt 进行部署
9. 所以配对合约的地址是可以通过两个 token 地址进行 create2 计算的
10. 用户可以将两个 token 存入到配对合约中，然后再配对合约中为用户生成一种兼容 ERC20 的 TOKEN。
11.  配对合约中生成的 ERC20 TOKEN 可以成为流动性
12. 用户可以将自己的流动性余额兑换成配对合约中的任何一种 token。
13. 用户也可以取出流动性，配对合约将销毁流动性，并将两种 token 同时返还用户。
14. 返还的数量将根据流动性数量和两种 token 的储备量重新计算，如果有手续费收益，用户也将得到收益。
15. 用户可以通过一种 token 交换另一种 token，配对合约将扣除千分之 3 的手续费
16. 在 uniswap 核心合约基础上，还有一个路由合约用来更好的操作核心合约
17. 路由合约拥有 3 部分操作方法，添加流动性，移除流动性，交换
18. 虽然配对合约已经可以完成所有的交易操作，但路由合约将所有操作整合，配合前端更好的完成交易
19. 因为路由合约的代码量较多，部署时会超过 gas 限制，所以路由合约被分为两个版本，功能互相补充。

