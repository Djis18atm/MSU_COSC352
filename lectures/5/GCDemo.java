//java -Xlog:gc GCDemo

import java.util.ArrayList;
import java.util.List;

public class GCDemo {
    public static void main(String[] args) {
        System.out.println("Starting GC Demo...");

        while (true) {
            generateGarbage();
        }
    }

    private static void generateGarbage() {
        // Create a short-lived large list of byte arrays
        List<byte[]> memoryHog = new ArrayList<>();

        for (int i = 0; i < 1000; i++) {
            memoryHog.add(new byte[1024 * 1024]); // Allocate 1MB chunks
        }

        // Explicitly drop the reference to encourage GC
        memoryHog = null;

        // Optional: Sleep to observe periodic GC behavior
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
