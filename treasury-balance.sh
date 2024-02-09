#!/bin/bash

# Initialize the running sum
total_sum=0
POKT=https://mainnet.rpc.grove.city/v1/43397ae8

# Loop through each line in the text file
while IFS= read -r addr; do
    # Run the command and capture the output, trimming the first 3 lines
    output=$(pocket query balance "$addr" --remoteCLIURL "$POKT" | sed 1d)

    
    # Extract the balance field using jq
    balance=$(echo "$output" | jq -r '.balance')

    # Debug: Echo the output and extracted balance
    echo "Output for address $addr: $output"
    echo "Extracted balance for address $addr: $balance"
    
    # Convert balance to numeric value
    balance=$((balance))
    echo "Found $balance uPOKT in balance"
   
    # get staked token amounts...
    output2=$(pocket query app "$addr" --remoteCLIURL "$POKT" | sed 1d)
    staked=$(echo "$output2" | jq -r '.staked_tokens')

    # convert staked to numeric
    staked=$((staked))
    echo "Found $staked staked uPOKT"

    # Add the balance to the total sum using bc for decimal arithmetic
    total_sum=$(echo "$total_sum + $balance" + "$staked" | bc)

    # Print the current total sum
    echo "Running total sum: $total_sum"
done < input.txt  # Change 'input.txt' to the name of your text file containing the list of addresses

