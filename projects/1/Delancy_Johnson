import sys

def main():
    if len(sys.argv) != 3:
        print("Usage: python hello.py <name> <number>")
        sys.exit(1)

    name = sys.argv[1]
    try:
        number = int(sys.argv[2])
        if number < 1:
            raise ValueError
    except ValueError:
        print("Error: <number> must be a positive integer.")
        sys.exit(1)

    for _ in range(number):
        print(f"Hello {name}")

if __name__ == "__main__":
    main()
