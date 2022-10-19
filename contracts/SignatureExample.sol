// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SignatureExample {
    using ECDSA for bytes32;

    // User => nonce => hash
    mapping(address => mapping(uint256 => bool)) public processedNonces;

    function tryRecover(
        uint256 nonce,
        address user,
        bytes memory signature
    ) external {
        require(user != address(0), "Zero address user");
        require(!processedNonces[user][nonce], "Nonce already processed");
        bytes32 messageHash = keccak256(abi.encodePacked(user, nonce)).toEthSignedMessageHash();

        (address signer, ) = messageHash.tryRecover(signature);
        require(signer == user, "Signer is invalid");

        processedNonces[user][nonce] = true;
    }

    function tryRecover(
        uint256 nonce,
        address user,
        bytes32 r,
        bytes32 vs
    ) external {
        require(user != address(0), "Zero address user");
        require(!processedNonces[user][nonce], "Nonce already processed");
        bytes32 messageHash = keccak256(abi.encodePacked(user, nonce)).toEthSignedMessageHash();

        (address signer, ) = messageHash.tryRecover(r, vs);
        require(signer == user, "Signer is invalid");

        processedNonces[user][nonce] = true;
    }

    function tryRecover(
        uint256 nonce,
        address user,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(user != address(0), "Zero address user");
        require(!processedNonces[user][nonce], "Nonce already processed");
        bytes32 messageHash = keccak256(abi.encodePacked(user, nonce)).toEthSignedMessageHash();

        (address signer, ) = messageHash.tryRecover(v, r, s);
        require(signer == user, "Signer is invalid");

        processedNonces[user][nonce] = true;
    }

    function recover(
        uint256 nonce,
        address user,
        bytes memory signature
    ) external {
        require(user != address(0), "Zero address user");
        require(!processedNonces[user][nonce], "Nonce already processed");
        bytes32 messageHash = keccak256(abi.encodePacked(user, nonce)).toEthSignedMessageHash();

        messageHash.recover(signature);
        processedNonces[user][nonce] = true;
    }

    function recover(
        uint256 nonce,
        address user,
        bytes32 r,
        bytes32 vs
    ) external {
        require(user != address(0), "Zero address user");
        require(!processedNonces[user][nonce], "Nonce already processed");
        bytes32 messageHash = keccak256(abi.encodePacked(user, nonce)).toEthSignedMessageHash();

        messageHash.recover(r, vs);
        processedNonces[user][nonce] = true;
    }

    function recover(
        uint256 nonce,
        address user,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(user != address(0), "Zero address user");
        require(!processedNonces[user][nonce], "Nonce already processed");
        bytes32 messageHash = keccak256(abi.encodePacked(user, nonce)).toEthSignedMessageHash();

        messageHash.recover(v, r, s);
        processedNonces[user][nonce] = true;
    }
}
