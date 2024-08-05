import pytest
from ape import project, convert

drip_amount = convert("0.0001 ETH", int)


def test_faucet_creation(acct1, contract_faucet):
    contract_faucet.seedFunds("devcon", sender=acct1, value=drip_amount * 10)
    assert contract_faucet.eventPayments("devcon") == drip_amount * 10


def test_faucet_drip(acct1, acct2, contract_faucet):
    original_balance = acct2.balance
    contract_faucet.seedFunds("devcon", sender=acct1, value=drip_amount * 10)
    contract_faucet.drip(acct2, "devcon", sender=acct1)
    assert contract_faucet.eventPayments("devcon") == drip_amount * 9
    assert acct2.balance == original_balance + drip_amount
