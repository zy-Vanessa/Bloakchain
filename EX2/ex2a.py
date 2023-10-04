from sys import exit
from bitcoin.core.script import *

from utils import *
from config import my_private_key, my_public_key, my_address, faucet_address
from ex1 import send_from_P2PKH_transaction
from bitcoin.wallet import CBitcoinSecret


cust1_private_key = CBitcoinSecret(
    'cPbgYuEDMmnRgqXB3YH1qYmhUttXBqoiyKTg7C2WQDv6tTCkNr55')
cust1_public_key = cust1_private_key.pub
cust2_private_key = CBitcoinSecret(
    'cTdj36ujHi1JofzsXqxybuWjMqfXNdwzwkdVfZmz9aQ2vcbZpJzG')
cust2_public_key = cust2_private_key.pub
cust3_private_key = CBitcoinSecret(
    'cUWJj9wL85ewVbynWSKFoxv2d7Ym7cUG2ghsNzTdheduno5tNiF9')
cust3_public_key = cust3_private_key.pub


######################################################################
# TODO: Complete the scriptPubKey implementation for Exercise 2

# You can assume the role of the bank for the purposes of this problem
# and use my_public_key and my_private_key in lieu of bank_public_key and
# bank_private_key.

ex2a_txout_scriptPubKey = [my_public_key,     #银行公钥
OP_CHECKSIGVERIFY,
OP_1,
cust1_public_key,
cust2_public_key,
cust3_public_key,       #三个客户的公钥
OP_3,
OP_CHECKMULTISIG]
######################################################################

if __name__ == '__main__':
    ######################################################################
    # TODO: set these parameters correctly
    amount_to_send = 0.0008
    txid_to_spend = (
        'c26d91f819ba03038c8936c56830a3996448cfd7dad7a67243ea8e5b95b799eb')
    utxo_index = 2
    ######################################################################

    response = send_from_P2PKH_transaction(
        amount_to_send, txid_to_spend, utxo_index,
        ex2a_txout_scriptPubKey)
    print(response.status_code, response.reason)
    print(response.text)
