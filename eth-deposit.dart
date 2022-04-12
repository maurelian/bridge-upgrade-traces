// Trace modified from: https://dashboard.tenderly.co/tx/mainnet/0x3609641de0ea9f3273253a6139db59026b4e42cccaea312da095b54399c103a9?trace=0.1.0
// Which is an eth deposit.
// call graph was simplified to remove proxies
- depositETH in L1StandardBridge -> emits ETHDepositInitiated()
  - JUMP: _initiateETHDeposit in L1StandardBridge
    - INLINE: code constructs calldata for CrossDomainMessenger to forward // can probably get rid of this step
    - JUMP: LIB_CrossDomainEnabled.sendCrossDomainMessage in L1StandardBridge
      - CALL: sendMessage in L1CrossDomainMessenger -> emits SentMessage()
        - CALL: getQueueLength in CanonicalTransactionChain // used as nonce
        - JUMP: Lib_CrossDomainUtils.encodeXDomainCalldata in L1CrossDomainMessenger
        - JUMP: _sendXDomainMessage in L1CrossDomainMessenger
          - CALL: enqueue in CanonicalTransactionChain -> emits TransactionEnqueued()

// Here is the L2 side of the deposit
// https://dashboard.tenderly.co/tx/optimistic/0x9ba16a48a659cc03c27793f3d81e1bb6c09b40e31d034448797c545a9bdec00f
- relayMessage in OVM_L2CrossDomainMessenger
  - JUMP: require(AddressAliasHelper.undoL1ToL2Alias(msg.sender) == l1CrossDomainMessenger) // Validates the L1 caller address
  - CALL: finalizeDeposit in OVM_L2StandardBridge -> emits DepositFinalized()
    - CALL: mint in OVM_ETH
      - JUMP: _mint in OVM_ETH -> emits Mint(), emits Transfer()