import sys


def repeat(name, count):
    for _ in range(count):
        print(f"hello {name}")


if __name__ == "__main__":
    name = sys.argv[1]
    count = int(sys.argv[2])
    repeat(name, count)
