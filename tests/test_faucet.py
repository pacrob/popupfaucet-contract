import pytest
from ape import project, convert
from ape.exceptions import ContractLogicError
from web3 import Web3

drip_amount = convert("0.0001 ETH", int)
hashed_code = Web3.keccak(text="devcon")


def test_faucet_creation(acct1, contract_faucet):
    contract_faucet.seedFunds("devcon", sender=acct1, value=drip_amount * 10)
    assert contract_faucet.eventFunds(hashed_code) == drip_amount * 10


def test_faucet_drip(acct1, acct2, contract_faucet):
    original_balance = acct2.balance
    contract_faucet.seedFunds("devcon", sender=acct1, value=drip_amount * 10)
    contract_faucet.drip(acct2, "devcon", sender=acct1)
    assert contract_faucet.eventFunds(hashed_code) == drip_amount * 9
    assert acct2.balance == original_balance + drip_amount


def test_no_drip_if_no_code(acct1, acct2, contract_faucet):
    original_balance = acct2.balance
    contract_faucet.seedFunds("devcon", sender=acct1, value=drip_amount * 10)
    with pytest.raises(ContractLogicError):
        contract_faucet.drip(acct2, "wrong code", sender=acct1)
    assert contract_faucet.eventFunds(hashed_code) == drip_amount * 10
    assert acct2.balance == original_balance


def test_owner_can_withdraw():
    pass


def test_not_owner_cannot_withdraw():
    pass
