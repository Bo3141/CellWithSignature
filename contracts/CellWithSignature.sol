// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CellWithSignature {
    using Counters for Counters.Counter;
    // _______________ Storage _______________
    Counters.Counter private _cellIds;

    mapping(address => uint256[]) public UserToCellIds;
    // cellVault[_cellId][_token] = _amount;
    // cellID => tokne => tokenAmount
    mapping(uint256 => mapping(IERC20 => uint256)) public cellVault;

    // _______________ Events _______________


    // _______________ Constructor _______________
    /**
     * @notice Constructor.
     *

     */
    constructor() {

    }

    // _______________ External functions _______________
    function depositToken(IERC20 _token, uint256 _amount, uint256 _cellId) external{
        uint256 [] memory cellsIds  = UserToCellIds[msg.sender];
        bool isCallerCell = false;
        for(uint256 i = 0; i < cellsIds.length; i++){
           if (cellsIds[i] == _cellId){
               isCallerCell = true;
               break;
           } 
        }
        require(isCallerCell, "This is not your cell");
        _token.transferFrom(msg.sender, address(this), _amount);
        cellVault[_cellId][_token] = _amount;
    }

    function createCell() external returns(uint256){
        _cellIds.increment();
        UserToCellIds[msg.sender].push(_cellIds.current());
        return _cellIds.current();
    }

}
