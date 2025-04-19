import time
import numpy as np

def mandelbrot(c, max_iter):
    z = 0
    for i in range(max_iter):
        z = z * z + c
        if abs(z) > 2:
            return i
    return max_iter

def mandelbrot_set(width, height, max_iter):
    real_min, real_max = -2.0, 1.0
    imag_min, imag_max = -1.5, 1.5
    real_vals = np.linspace(real_min, real_max, width)
    imag_vals = np.linspace(imag_min, imag_max, height)
    
    result = np.zeros((height, width))
    for i in range(height):
        for j in range(width):
            result[i, j] = mandelbrot(complex(real_vals[j], imag_vals[i]), max_iter)
    return result

if __name__ == "__main__":
    width, height, max_iter = 2000, 2000, 1000
    start_time = time.time()
    mandelbrot_set(width, height, max_iter)
    end_time = time.time()
    print(f"Execution Time: {end_time - start_time:.2f} seconds")
