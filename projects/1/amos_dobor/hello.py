# Import the sys module to read command-line arguments
import sys

# Define a function to greet the user 'times' number of times
def greet(name, times):
    for _ in range(times):  # Loop 'times' number of times
        print(f"Hello {name}")  # Print the greeting message

# Main function that handles command-line arguments
if __name__ == "__main__":
    # Ensure the correct number of arguments are provided
    if len(sys.argv) != 3:
        print("Usage: python hello.py <name> <number>")
        sys.exit(1)
    
    # Retrieve the name and number from the command-line arguments
    name = sys.argv[1]
    try:
        # Try to convert the second argument to an integer
        number = int(sys.argv[2])
    except ValueError:
        # Handle case where the second argument isn't an integer
        print("The second argument must be an integer representing the number of times to greet.")
        sys.exit(1)
    
    # Call the greet function with the user's name and number
    greet(name, number)


