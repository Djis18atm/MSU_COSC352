import sys
if len(sys.argv) != 3:
    print("Usage: python script.py <var1> <var2>")
    sys.exit(1)
elif not sys.argv[2].isdigit():
    print("Second argument must be a number")
    sys.exit(1)

var1 = sys.argv[1]
var2 = int(sys.argv[2])
for i in range(var2):
    print(f"Hello, {var1}!")