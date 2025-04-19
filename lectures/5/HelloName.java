public class HelloName {
    public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Usage: java HelloName <name> <number>");
            return;
        }

        String name = args[0];
        int count;

        try {
            count = Integer.parseInt(args[1]);
        } catch (NumberFormatException e) {
            System.out.println("Error: The second argument must be a valid integer.");
            return;
        }

        for (int i = 0; i < count; i++) {
            System.out.println("Hello " + name);
        }
    }
}
