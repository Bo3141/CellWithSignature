const { expect } = require("chai");
const { ethers } = require("hardhat");
const { signValues, signValues_r_s_v, signValues_r_vs } = require("../utils/signature");

describe("SignatureExample", () => {
    let signatureExample, deployer, user;

    before(async () => {
        [deployer, user] = await ethers.getSigners();
        signatureExample = await (await ethers.getContractFactory("SignatureExample")).deploy();
    });

    it("Should validate signature: tryRecover + signature", async () => {
        const types = ["address", "uint256"];
        const nonce = 1;
        const values = [user.address, nonce];
        const signature = await signValues(user, types, values);

        await signatureExample["tryRecover(uint256,address,bytes)"](nonce, user.address, signature);
        expect(await signatureExample.processedNonces(user.address, nonce)).to.be.true;
    });

    it("Should validate signature: recover + signature", async () => {
        const types = ["address", "uint256"];
        const nonce = 2;
        const values = [user.address, nonce];
        const signature = await signValues(user, types, values);

        await signatureExample["recover(uint256,address,bytes)"](nonce, user.address, signature);
        expect(await signatureExample.processedNonces(user.address, nonce)).to.be.true;
    });

    it("Should validate signature: tryRecover + r s v", async () => {
        const types = ["address", "uint256"];
        const nonce = 3;
        const values = [user.address, nonce];
        const splittedSignature = await signValues_r_s_v(user, types, values);

        await signatureExample["tryRecover(uint256,address,uint8,bytes32,bytes32)"](
            nonce,
            user.address,
            splittedSignature.v,
            splittedSignature.r,
            splittedSignature.s
        );
        expect(await signatureExample.processedNonces(user.address, nonce)).to.be.true;
    });

    it("Should validate signature: recover + r s v", async () => {
        const types = ["address", "uint256"];
        const nonce = 4;
        const values = [user.address, nonce];
        const splittedSignature = await signValues_r_s_v(user, types, values);

        await signatureExample["recover(uint256,address,uint8,bytes32,bytes32)"](
            nonce,
            user.address,
            splittedSignature.v,
            splittedSignature.r,
            splittedSignature.s
        );
        expect(await signatureExample.processedNonces(user.address, nonce)).to.be.true;
    });

    it("Should validate signature: tryRecover + r vs", async () => {
        const types = ["address", "uint256"];
        const nonce = 5;
        const values = [user.address, nonce];
        const splittedSignature = await signValues_r_vs(user, types, values);

        await signatureExample["tryRecover(uint256,address,bytes32,bytes32)"](
            nonce,
            user.address,
            splittedSignature.r,
            splittedSignature.vs
        );
        expect(await signatureExample.processedNonces(user.address, nonce)).to.be.true;
    });

    it("Should validate signature: recover + r vs", async () => {
        const types = ["address", "uint256"];
        const nonce = 6;
        const values = [user.address, nonce];
        const splittedSignature = await signValues_r_vs(user, types, values);

        await signatureExample["recover(uint256,address,bytes32,bytes32)"](
            nonce,
            user.address,
            splittedSignature.r,
            splittedSignature.vs
        );
        expect(await signatureExample.processedNonces(user.address, nonce)).to.be.true;
    });
});
