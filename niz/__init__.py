import argparse
import os
import shlex
import shutil
import sys
import textwrap

NEEDS_COMMAND = [
    "shell",
    "develop",
]

NEEDS_EXPR = [
    "repl",
]

NEEDS_NO_LOGS =[
    # nix repl breaks if you pass --log-format bar-with-logs >.>
    "repl",
]

def main():

    parser = argparse.ArgumentParser("niz", add_help=False)
    parser.add_argument("action", nargs="?")

    args, rest = parser.parse_known_args()

    # `niz with` is a wrapper around `niz shell` that prepends `qyriad#` for each word in its next argument.
    # e.g.: `niz with "gcc clang"` becomes `niz shell qyriad#gcc qyriad#clang`.
    if args.action == "with":

        # Remove the package list from the argument list, and split it.
        pkgs = shlex.split(rest.pop(0))

        # Replace the action with `shell`
        args.action = "shell"

        # Prepend the flakeref to each package in the package spec.
        shell_args = [f"qyriad#{pkg}" for pkg in pkgs]

        # Insert the shell args at the beginning of the argument list, like they would be for `niz shell`.
        rest[0:0] = shell_args

        # And then continue on the rest of the program as normal.


    nix_args = ["nix", "--log-format", "bar-with-logs", "--print-build-logs", "--verbose", args.action, *rest]
    nix_args = [arg for arg in nix_args if arg is not None]

    if args.action in NEEDS_COMMAND and "--command" not in rest:
        nix_args.extend(["--command", "xonsh"])

    if args.action in NEEDS_EXPR and "--expr" not in rest:
        nix_expr = textwrap.dedent(f"""
            {{
                pkgs = import (builtins.getFlake "nixpkgs") {{ }};
                lib = (import (builtins.getFlake "nixpkgs") {{ }}).lib;
                qyriad = builtins.getFlake "qyriad";
                f = builtins.getFlake "{os.getcwd()}";
            }}
        """)

        nix_args.extend([ "--expr", nix_expr])

    if args.action in NEEDS_NO_LOGS and "--log-format" not in rest:
        nix_args.remove("--log-format")
        nix_args.remove("bar-with-logs")

    quoted = " ".join([shlex.quote(arg) for arg in nix_args])
    print(f"\x1b[1m{quoted}\x1b[22m", file=sys.stderr)

    # Replace the Nix command with the full path.
    nix_cmd = shutil.which("nix")
    if nix_cmd is None:
        raise ValueError("nix: command not found")

    nix_args[0] = nix_cmd

    os.execv(nix_args[0], nix_args)


if __name__ == "__main__":
    main()
