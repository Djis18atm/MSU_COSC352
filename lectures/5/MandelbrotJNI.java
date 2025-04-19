public class MandelbrotJNI {
    static {
        System.loadLibrary("mandelbrot"); // Loads the compiled shared library
    }

    // Native method declaration
    public native void computeMandelbrot(int width, int height, int maxIter);

    public static void main(String[] args) {
        MandelbrotJNI mandelbrot = new MandelbrotJNI();
        long start = System.currentTimeMillis();
        mandelbrot.computeMandelbrot(1000, 1000, 1000);
        long end = System.currentTimeMillis();
        System.out.println("Execution time: " + (end - start) + " ms");
    }
}
