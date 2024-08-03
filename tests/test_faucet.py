import pytest
from ape import project


def test_faucet_creation(acct1, acct2, contract_faucet):
    contract_faucet.seedFunds("devcon", sender=acct1, value=100)
    assert contract_faucet.eventPayments("devcon") == 100
    # contract_faucet.drip(acct2, "devcon", sender=acct1)
    # assert contract_faucet.eventPayments("devcon") == (100 - 0.0001)
