const ChequeSystem = artifacts.require("ChequeSystem");

contract("ChequeSystem", (accounts) => {
  let chequeSystem;

  before(async () => {
    chequeSystem = await ChequeSystem.deployed();
  });

  it("should generate a cheque", async () => {
    const receiver = "Alice";
    const amount = 100;
    const timestamp = Math.floor(Date.now() / 1000);
    const digitalSignature = "signature";

    await chequeSystem.generateCheque(receiver, amount, timestamp, digitalSignature);

    const storedHash = await chequeSystem.Hash(receiver);
    const expectedHash = web3.utils.soliditySha3(receiver, amount, timestamp, digitalSignature);

    assert.equal(storedHash, expectedHash, "Cheque hash doesn't match expected value");
  });

  it("should clear a cheque", async () => {
    const receiver = "Alice";
    const amount = 100;
    const timestamp = Math.floor(Date.now() / 1000);
    const digitalSignature = "signature";

    const chequeHash = web3.utils.soliditySha3(receiver, amount, timestamp, digitalSignature);
    await chequeSystem.generateCheque(receiver, amount, timestamp, digitalSignature);
    await chequeSystem.clearCheque(chequeHash);

    const isCleared = await chequeSystem.isChequeCleared(chequeHash);
    assert.isTrue(isCleared, "Cheque was not cleared");
  });

  it("should verify a cheque", async () => {
    const receiver = "Alice";
    const amount = 100;
    const timestamp = Math.floor(Date.now() / 1000);
    const digitalSignature = "signature";

    const chequeHash = web3.utils.soliditySha3(receiver, amount, timestamp, digitalSignature);
    await chequeSystem.generateCheque(receiver, amount, timestamp, digitalSignature);

    const [sender, chequeReceiver, chequeAmount, chequeTimestamp, chequeSignature] = await chequeSystem.verifyCheque(chequeHash);

    assert.equal(sender, accounts[0], "Sender address is incorrect");
    assert.equal(chequeReceiver, receiver, "Receiver is incorrect");
    assert.equal(chequeAmount.toNumber(), amount, "Amount is incorrect");
    assert.equal(chequeTimestamp.toNumber(), timestamp, "Timestamp is incorrect");
    assert.equal(chequeSignature, digitalSignature, "Signature is incorrect");
  });
});
