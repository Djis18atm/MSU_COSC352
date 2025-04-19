public class Mandelbrot {
    public static int mandelbrot(double real, double imag, int maxIter) {
        double zReal = 0, zImag = 0;
        int iter;
        for (iter = 0; iter < maxIter; iter++) {
            double zReal2 = zReal * zReal - zImag * zImag + real;
            double zImag2 = 2 * zReal * zImag + imag;
            zReal = zReal2;
            zImag = zImag2;
            if (zReal * zReal + zImag * zImag > 4) {
                break;
            }
        }
        return iter;
    }

    public static void mandelbrotSet(int width, int height, int maxIter) {
        double realMin = -2.0, realMax = 1.0;
        double imagMin = -1.5, imagMax = 1.5;
        double realStep = (realMax - realMin) / width;
        double imagStep = (imagMax - imagMin) / height;

        int[][] result = new int[height][width];
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                double real = realMin + j * realStep;
                double imag = imagMin + i * imagStep;
                result[i][j] = mandelbrot(real, imag, maxIter);
            }
        }
    }

    public static void main(String[] args) {
        int width = 2000, height = 2000, maxIter = 1000;
        long startTime = System.currentTimeMillis();
        mandelbrotSet(width, height, maxIter);
        long endTime = System.currentTimeMillis();
        System.out.println("Execution Time: " + (endTime - startTime) / 1000.0 + " seconds");
    }
}
