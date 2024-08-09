#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <time.h>
#include "lab10.h"

void sin_stdlib(double* input, double* output, uint64_t length);
void sin_x87(double* input, double* output, uint64_t length);

int main() {

    uint64_t length = 1000000; 
    double* input = (double*)malloc(length * sizeof(double));
    double* output_x87 = (double*)malloc(length * sizeof(double));
    double* output_stdlib = (double*)malloc(length * sizeof(double));

    for (uint64_t i = 0; i < length; ++i) {
        input[i] = i * 0.01;
    }

    clock_t start = clock();
    sin_x87(input, output_x87, length);
    clock_t end = clock();
    double time_x87 = (double)(end - start) / CLOCKS_PER_SEC;

    start = clock();
    sin_stdlib(input, output_stdlib, length);
    end = clock();
    double time_stdlib = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Time for x87: %f seconds\n", time_x87);
    printf("Time for stdlib: %f seconds\n", time_stdlib);

    free(input);
    free(output_x87);
    free(output_stdlib);

    return 0;
}
