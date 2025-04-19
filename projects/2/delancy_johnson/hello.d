import std.stdio;
import std.conv;
import std.exception;

void main(string[] args) {
    if (args.length != 3) {
        writeln("Usage: ./hello <name> <number>");
        return;
    }

    string name = args[1];
    int number;

    try {
        number = to!int(args[2]);
        if (number < 1) {
            throw new Exception("Number must be a positive integer.");
        }
    } catch (Exception) {
        writeln("Error: <number> must be a positive integer.");
        return;
    }

    foreach (i; 0 .. number) {
        writeln("Hello ", name);
    }
}
