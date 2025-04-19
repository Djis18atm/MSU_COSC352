def main():
    name = input("Enter your name: ")
    number = input("Enter the number of times to greet: ")

    if not number.isdigit():
        print("Error: Number must be an integer.")
        return

    number = int(number)
    for _ in range(number):
        print(f"Hello {name}")

if __name__ == "__main__":
    main()