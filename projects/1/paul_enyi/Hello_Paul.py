import sys 

def main(name, count):
    """Main function to print a greeting multiple times based on user input."""
    if not name.strip():
        print("Error: <name> cannot be empty.")
        return

    try:
        count = int(count)  # Convert argument to integer
        if count < 0:
            print("Error: <number> must be a non-negative integer.")
            return
    except ValueError:
        print("Error: <number> must be an integer.")
        return

    if count == 0:
        print("No greetings to display.")
    else:
        for _ in range(count):
            print(f"Hello {name}")

if __name__ == "__main__":
    # Ensure the program is run with exactly two command-line arguments
    if len(sys.argv) != 3:
        print("Usage: python Hello_Paul.py <name> <number>")
        sys.exit(1)

    name = sys.argv[1]  # First argument: name
    count = sys.argv[2]  # Second argument: number

    main(name, count)
