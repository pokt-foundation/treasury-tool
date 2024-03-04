# Treasury Tool

Bash script that adds all balances and staked tokens from a list of POKT addresses.

The output is in uPOKT and POKT.

# Reequired Packages

- [PocketCore](https://github.com/pokt-network/pocket-core)
- [jq](https://jqlang.github.io/jq/)
- [Parallel](https://savannah.gnu.org/projects/parallel/)


# How to Use

Ensure that the bash file `treasury-balance.sh` has permissions

`chmod +x treasury-balance.sh`

Add all addresses you'd like to scan in `input.txt`

Update the value of $POKT in `treasury-balance.sh` to a valid endpoint.
(Get one free at https://portal.grove.city)

Execute the script: `./treasury-balance.sh`
