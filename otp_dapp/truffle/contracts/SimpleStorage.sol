// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SimpleStorage {
  uint256 value;
  function read() public view returns (uint256) {
    uint256 randomnumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 101;
    return randomnumber;
}

   function write(uint256 newValue) public {
     value = newValue;
   }



}
