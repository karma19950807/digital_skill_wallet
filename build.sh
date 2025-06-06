#!/bin/bash

# Set paths
CIRCUIT_DIR="./backend/zk/circuits"
COMPILED_DIR="./backend/zk/compiled"
KEYS_DIR="./backend/zk/keys"
INPUT_FILE="$COMPILED_DIR/input.json"
WITNESS_FILE="$COMPILED_DIR/witness.wtns"
PROOF_FILE="$COMPILED_DIR/proof.json"
PUBLIC_FILE="$COMPILED_DIR/public.json"
ZKEY_FILE="$KEYS_DIR/skillcoin_final.zkey"

# Step 1: Compile circuit
echo "🔨 Compiling circuit..."
circom "$CIRCUIT_DIR/skillcoin.circom" --wasm --r1cs --sym --output "$COMPILED_DIR"

# Step 2: Check if input.json exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ ERROR: input.json not found in $COMPILED_DIR"
    exit 1
fi

# Step 3: Generate witness
echo "⚙️ Generating witness..."
node "$COMPILED_DIR/skillcoin_js/generate_witness.js" \
    "$COMPILED_DIR/skillcoin_js/skillcoin.wasm" \
    "$INPUT_FILE" \
    "$WITNESS_FILE"

# Step 4: Generate proof
echo "✅ Generating proof..."
snarkjs groth16 prove "$ZKEY_FILE" "$WITNESS_FILE" "$PROOF_FILE" "$PUBLIC_FILE"

echo "🎉 Done! Proof written to $PROOF_FILE and public signals to $PUBLIC_FILE"

