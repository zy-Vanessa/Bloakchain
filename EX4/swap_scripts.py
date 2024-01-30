from bitcoin.core.script import *

######################################################################
# This function will be used by Alice and Bob to send their respective
# coins to a utxo that is redeemable either of two cases:
# 1) Recipient provides x such that hash(x) = hash of secret 
#    and recipient signs the transaction.
# 2) Sender and recipient both sign transaction
# 
# TODO: Fill this in to create a script that is redeemable by both
#       of the above conditions.
# 
# See this page for opcode: https://en.bitcoin.it/wiki/Script
#
#

# This is the ScriptPubKey for the swap transaction
def coinExchangeScript(public_key_sender, public_key_recipient, hash_of_secret):
    return [
        # 推送接收方的公钥到栈上
        public_key_recipient,
        # 验证接收方的签名，并标记为验证结果（不移除）
        OP_CHECKSIGVERIFY,
        # 复制栈顶元素以备双重验证
        OP_DUP,
        # 检查密钥的哈希是否与提供的哈希匹配
        OP_HASH160,
        hash_of_secret,
        OP_EQUAL,
        # 如果条件满足，执行以下操作
        OP_IF,
            # 从栈中移除顶部元素
            OP_DROP,
            # 推送 '1' 到栈上，表示成功
            OP_1,
        # 如果条件不满足，执行以下操作
        OP_ELSE,
            # 检查是否为发送方的签名
            public_key_sender,
            OP_CHECKSIG,
        # 结束条件块
        OP_ENDIF
    ]

# 这是在接收者知道秘密 x 的情况下，赎回交易所需的 ScriptSig
def coinExchangeScriptSig1(sig_recipient, secret):
    return [
        # 推送密钥到栈上
        secret,
        # 推送接收方的签名到栈上
        sig_recipient
    ]

# 这是在发送方和接收方都签署事务的情况下，未被赎回时将币发送回发送方的 ScriptSig
def coinExchangeScriptSig2(sig_sender, sig_recipient):
    return [
        # 推送发送方的签名到栈上
        sig_sender,
        # 推送接收方的签名到栈上
        sig_recipient
    ]

#
#
######################################################################

