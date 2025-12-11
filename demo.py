#!/usr/bin/env python3
"""
BB84 Quantum Key Distribution Demo

This script demonstrates the BB84 protocol:
1. Secure key exchange without eavesdropping
2. Key exchange with Eve intercepting - showing detection

Run: python demo.py
"""

from qkd import BB84Protocol


def main():
    # Create protocol with 500 bits
    # Using seed for reproducible results
    protocol = BB84Protocol(
        num_bits=500,
        sample_fraction=0.15,  # Use 15% of bits for error checking
        detection_threshold=0.11,  # 11% error rate triggers detection
        seed=42
    )

    # Run the full demonstration
    protocol.demonstrate()

    # Additional: Show what the keys look like
    print("\n" + "=" * 60)
    print("DETAILED KEY INFORMATION")
    print("=" * 60)

    # Run once more to get detailed results
    result = protocol.run(eavesdropper=False)

    print(f"\nAlice's first 20 bits: {result.alice_bits[:20]}")
    print(f"Alice's first 20 bases: {[b.value for b in result.alice_bases[:20]]}")
    print(f"Bob's first 20 bases:   {[b.value for b in result.bob_bases[:20]]}")
    print(f"Bob's first 20 results: {result.bob_measurements[:20]}")

    # Show which bits matched
    matches = [
        "✓" if a == b else "✗"
        for a, b in zip(result.alice_bases[:20], result.bob_bases[:20])
    ]
    print(f"Basis match:            {matches}")

    print(f"\nFinal shared key (first 64 bits as hex): ", end="")
    from qkd.analysis import key_to_hex
    print(key_to_hex(result.final_key[:64]))


if __name__ == "__main__":
    main()
