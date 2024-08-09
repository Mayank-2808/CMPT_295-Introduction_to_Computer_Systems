#include <stdint.h>
#include <stdlib.h>
#include "version2-master/vectorclass.h"
#include "lab11.h"

using namespace std;

double dot_double_vc(double* arr1, double* arr2, uint64_t n) 
{
    Vec4d sum = 0.0;

    for (uint64_t i = 0; i < n; i += 4) 
    {
        Vec4d vec1 = Vec4d().load(arr1 + i);
        Vec4d vec2 = Vec4d().load(arr2 + i);
        sum += vec1 * vec2;
    }

    return horizontal_add(sum);
}

float dot_single_vc(float* arr1, float* arr2, uint64_t n) 
{
    Vec8f sum = 0.0f;

    for (uint64_t i = 0; i < n; i += 8) 
    {
        Vec8f vec1 = Vec8f().load(arr1 + i);
        Vec8f vec2 = Vec8f().load(arr2 + i);
        sum += vec1 * vec2;
    }

    return horizontal_add(sum);
}

void map_poly_double_vc(double* input, double* output, uint64_t length, double a, double b, double c, double d) 
{
    Vec4d va = a, vb = b, vc = c, vd = d;

    for (uint64_t i = 0; i < length; i += 4) 
    {
        Vec4d x = Vec4d().load(input + i);
        Vec4d result = ((va * x + vb) * x + vc) * x + vd;
        result.store(output + i);
    }
}

void map_poly_single_vc(float* input, float* output, uint64_t length, float a, float b, float c, float d) 
{
    Vec8f va = a, vb = b, vc = c, vd = d;

    for (uint64_t i = 0; i < length; i += 8) 
    {
        Vec8f x = Vec8f().load(input + i);
        Vec8f result = ((va * x + vb) * x + vc) * x + vd;
        result.store(output + i);
    }
}

