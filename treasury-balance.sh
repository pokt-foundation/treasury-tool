#!/bin/bash

# Initialize the running sum
total_sum=0
total_sum_POKT=0

# conversion factor for uPOKT -> POKT
conversion=1000000

# modify to a valid pocket RPC url. get one FREE: https://portal.grove.city
POKT="Get an endpoint: https://portal.grove.city"

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
    echo ""
   
    # get app staked token amounts...
    output2=$(pocket query app "$addr" --remoteCLIURL "$POKT" | sed 1d)
    appstaked=$(echo "$output2" | jq -r '.staked_tokens')

    # convert staked to numeric
    appstaked=$((appstaked))
    echo "Found $appstaked staked uPOKT (AppStake)"
    echo ""

    # get node staked token amounts...
    output2=$(pocket query node "$addr" --remoteCLIURL "$POKT" | sed 1d)
    nodestaked=$(echo "$output2" | jq -r '.tokens')

    # convert staked to numeric
    nodestaked=$((nodestaked))
    echo "Found $nodestaked staked uPOKT (NodeStake)"
    echo ""

    # Add the balance to the total sum using bc for decimal arithmetic
    total_sum=$(echo "$total_sum + $balance" + "$appstaked" + "$nodestaked" | bc)

    # Print the current total sum
    echo "Running total sum: $total_sum uPOKT"
    total_sum_POKT=$(echo "scale=2 ; $total_sum / $conversion" | bc)
    echo "Running total sum: $total_sum_POKT POKT"

done < input.txt  # Change 'input.txt' to the name of your text file containing the list of addresses

