import click
from ape import accounts, project
from ape.cli import (
    ConnectedProviderCommand,
    network_option,
    select_account,
)

@click.command(cls=ConnectedProviderCommand)
@network_option()
def cli(ecosystem, network, provider):
    click.echo(f"You are connected to network '{ecosystem.name}:{network.name}' (chain ID: {provider.chain_id}).")
    account = select_account()
    contract = project.Faucet.deploy(account.address, sender=account)
    click.echo(f"Deployed Faucet contract to {contract.address} on {ecosystem.name}:{network.name}.")
