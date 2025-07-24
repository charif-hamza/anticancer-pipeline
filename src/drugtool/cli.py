# src/drugtool/cli.py
import typer
from .generator import hello

app = typer.Typer(name="drugtool")

@app.command()
def ping() -> None:
    """Return a one‑word heartbeat to prove the CLI wiring."""
    typer.echo(hello())

@app.command()
def version() -> None:
    """Show version information."""
    typer.echo("drugtool v1.0.0")

if __name__ == "__main__":
    app()
