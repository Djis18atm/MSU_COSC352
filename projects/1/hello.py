import sys

def main():
    # Check if the correct number of arguments are passed
    if len(sys.argv) < 2:
        print("Usage: python hello.py <name> [<number>]")
        sys.exit(1)
    
    # Extract the name argument
    name = sys.argv[1]

    # Default to printing once if no number is provided
    num_times = 1
    if len(sys.argv) > 2:
        try:
            num_times = int(sys.argv[2])
        except ValueError:
            print("Error: <number> must be an integer.")
            sys.exit(1)
    
    # Print "Hello <name>" the specified number of times
    for _ in range(num_times):
        print(f"Hello {name}")

if __name__ == "__main__":
    main()
