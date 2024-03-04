#!/bin/bash

# conversion factor for uPOKT -> POKT
conversion=1000000

# Modify to a valid POKT RPC url. Get one for free at https://portal.grove.city
POKT="https://mainnet.rpc.grove.city/v1/your-id"

# Create a temporary file for parallel output
temp_file=$(mktemp)

# Export POKT variable so it's available in the subprocess
export POKT

# Define the function to process each address
process_address() {
    addr="$1"
    temp_file="$2"
    # Fetch balance
    output=$(pocket query balance "$addr" --remoteCLIURL "$POKT" | sed 1d)
    balance=$(echo "$output" | jq -r '.balance')
    balance=$((balance))

    # Fetch app staked tokens
    output2=$(pocket query app "$addr" --remoteCLIURL "$POKT" | sed 1d)
    appstaked=$(echo "$output2" | jq -r '.staked_tokens')
    appstaked=$((appstaked))

    # Fetch node staked tokens
    output3=$(pocket query node "$addr" --remoteCLIURL "$POKT" | sed 1d)
    nodestaked=$(echo "$output3" | jq -r '.tokens')
    nodestaked=$((nodestaked))

    # Output balance and staked tokens for later aggregation
    echo "$balance $appstaked $nodestaked" >> "$temp_file"
}

# Export the function so it can be used by parallel
export -f process_address

# Use parallel to read each line from the file and call process_address with the line and temp_file as arguments
cat input.txt | parallel process_address {} $temp_file

# Initialize the running sum
total_sum=0

# Aggregate results from the temporary file
while read -r balance appstaked nodestaked; do
    total_sum=$(echo "$total_sum + $balance + $appstaked + $nodestaked" | bc)
done < "$temp_file"

# Convert total sum to POKT
total_sum_POKT=$(echo "scale=2 ; $total_sum / $conversion" | bc)

# Cleanup
rm "$temp_file"

# Final output
echo "Final total sum: $total_sum uPOKT"
echo "Final total sum in POKT: $total_sum_POKT POKT"
