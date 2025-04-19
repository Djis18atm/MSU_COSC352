#include <jni.h>
#include <stdio.h>
#include <stdlib.h>
#include <complex.h>
#include "MandelbrotJNI.h"

void mandelbrot(int width, int height, int maxIter) {
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            double cr = (x - width / 2.0) * 4.0 / width;
            double ci = (y - height / 2.0) * 4.0 / height;
            double complex z = 0 + 0 * I;
            int iter = 0;

            while (cabs(z) < 2.0 && iter < maxIter) {
                z = z * z + cr + ci * I;
                iter++;
            }
        }
    }
}

JNIEXPORT void JNICALL Java_MandelbrotJNI_computeMandelbrot
  (JNIEnv *env, jobject obj, jint width, jint height, jint maxIter) {
    mandelbrot(width, height, maxIter);
}
