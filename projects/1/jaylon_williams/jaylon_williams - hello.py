import sys
 
def main():
    if len(sys.argv) != 3:
        print("Usage: python hello.py <name> <number>")
        return
 
    name = sys.argv[1]
    try:
        number = int(sys.argv[2])
    except ValueError:
        print("<number> must be an integer.")
        return
 
    for _ in range(number):
        print(f"Hello {name}")
 
if __name__ == "__main__":
    main()
