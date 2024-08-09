// Get modern behaviour out of time.h, per https://stackoverflow.com/a/40515669
#define _POSIX_C_SOURCE 199309L
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include <algorithm>
#include <cassert>
#ifdef USE_PDQSORT
    /*
    Want to try pdqsort too? https://github.com/orlp/pdqsort
    Get the header file: wget https://raw.githubusercontent.com/orlp/pdqsort/master/pdqsort.h
    And add "-DUSE_PDQSORT" when compiling.
    */
    #include "pdqsort.h"
#endif

/*
#define DATA_T int64_t
#define DATA_PRINTF "%ld"
#define RAND_EXPR (rand() % 256 - 128)
*/
#define DATA_T double
#define DATA_PRINTF "%g"
#define RAND_EXPR ((double)rand() / RAND_MAX - 0.5)


/*
*  Utility code to create appropriate arrays.
*/

enum array_ordering { RANDOM, SORTED, REVERSE_SORTED, ALMOST_SORTED };

void gently_shuffle_array(DATA_T* array, uint64_t length) {
    uint64_t limit = 10;
    // shuffle array indicies a little, with nearby values
    for (uint64_t i = 0; i < length - limit - 1; i++) {
        uint64_t offset = rand() % limit;
        DATA_T tmp = array[i + offset];
        array[i + offset] = array[i];
        array[i] = tmp;
    }
}

DATA_T* create_array(uint64_t length, array_ordering order) {
    DATA_T* array = (DATA_T*)malloc(length * sizeof(DATA_T));
    if (array == NULL) {
        return NULL;
    }
    for (uint64_t i = 0; i < length; i++) {
        array[i] = RAND_EXPR;
    }

    // order the array as requested
    switch (order) {
    case RANDOM:
        break;
    case SORTED:
        std::sort(array, array + length);
        break;
    case ALMOST_SORTED:
        std::sort(array, array + length);
        gently_shuffle_array(array, length);
        break;
    case REVERSE_SORTED:
        std::sort(array, array + length);
        std::reverse(array, array + length);
        break;
    }
    return array;
}


/*
*  Library sorting implementations, adapted to have the same (DATA_T*, uint64_t) signature.
*/

int data_cmp(const void* a, const void* b) {
    // comparator function for qsort, per https://en.cppreference.com/w/c/algorithm/qsort
    DATA_T arg1 = *(const DATA_T*)a;
    DATA_T arg2 = *(const DATA_T*)b;
    if (arg1 < arg2) return -1;
    if (arg1 > arg2) return 1;
    return 0;
}

void stdlib_qsort(DATA_T* array, uint64_t length) {
    qsort(array, length, sizeof(DATA_T), data_cmp);
}

void std_sort(DATA_T* array, uint64_t length) {
    // adapt std::sort to the same interface the other functions use
    std::sort(array, array + length);
}

#ifdef USE_PDQSORT
void pdq_sort(DATA_T* array, uint64_t length) {
    // adapt pdqsort to the interface the same other functions use
    pdqsort(array, array + length);
}
#endif


void bubble_sort(DATA_T* array, uint64_t length) 
{
    for (uint64_t i = 0; i < length - 1; i++) 
    {
        for (uint64_t j = i + 1; j < length; j++) 
        {
            if (array[i] > array[j]) 
            {
                DATA_T tmp = array[j];
                array[j] = array[i];
                array[i] = tmp;
            }
        }
    }
}

// Custom Quicksort Implementation
void quicksort(DATA_T* array, int64_t low, int64_t high) {
    if (low < high) {
        DATA_T pivot = array[high];
        int64_t i = low - 1;
        for (int64_t j = low; j <= high - 1; j++) {
            if (array[j] < pivot) {
                i++;
                std::swap(array[i], array[j]);
            }
        }
        std::swap(array[i + 1], array[high]);
        int64_t pi = i + 1;
        quicksort(array, low, pi - 1);
        quicksort(array, pi + 1, high);
    }
}

void quicksort_wrapper(DATA_T* array, uint64_t length) {
    quicksort(array, 0, length - 1);
}

// Mergesort Implementation
void merge(DATA_T* array, int64_t left, int64_t mid, int64_t right) {
    int64_t n1 = mid - left + 1;
    int64_t n2 = right - mid;

    DATA_T* L = (DATA_T*)malloc(n1 * sizeof(DATA_T));
    DATA_T* R = (DATA_T*)malloc(n2 * sizeof(DATA_T));

    for (int64_t i = 0; i < n1; i++)
        L[i] = array[left + i];
    for (int64_t j = 0; j < n2; j++)
        R[j] = array[mid + 1 + j];

    int64_t i = 0, j = 0, k = left;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            array[k] = L[i];
            i++;
        } else {
            array[k] = R[j];
            j++;
        }
        k++;
    }

    while (i < n1) {
        array[k] = L[i];
        i++;
        k++;
    }

    while (j < n2) {
        array[k] = R[j];
        j++;
        k++;
    }

    free(L);
    free(R);
}

void mergesort(DATA_T* array, int64_t left, int64_t right) {
    if (left < right) {
        int64_t mid = left + (right - left) / 2;
        mergesort(array, left, mid);
        mergesort(array, mid + 1, right);
        merge(array, left, mid, right);
    }
}

void mergesort_wrapper(DATA_T* array, uint64_t length) {
    mergesort(array, 0, length - 1);
}

// Insertion Sort Implementation
void insertion_sort(DATA_T* array, uint64_t length) {
    for (uint64_t i = 1; i < length; i++) {
        DATA_T key = array[i];
        int64_t j = i - 1;
        while (j >= 0 && array[j] > key) {
            array[j + 1] = array[j];
            j = j - 1;
        }
        array[j + 1] = key;
    }
}

/*
*  Testing code.
*/

bool is_sorted(DATA_T* array, uint64_t length) {
    for (uint64_t i = 0; i < length - 1; i++) {
        if (array[i] > array[i + 1]) {
            return false;
        }
    }
    return true;
}

void time_sort(const char* descr, void(*sort)(DATA_T*, uint64_t), uint64_t length, array_ordering order) {
    struct timespec start, end;

    DATA_T* array = create_array(length, order);
    if (array == NULL) {
        printf("Couldn't allocate.\n");
        return;
    }

    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
    sort(array, length);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
    assert(is_sorted(array, length));

    free(array);
    double elapsed = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    printf("%25s sorted %8lu values in %7.2f ms\n", descr, length, elapsed * 1000);
}

void time_them(uint64_t length) {
    time_sort("bubble_sort on random", bubble_sort, length, RANDOM);
    time_sort("bubble_sort on sorted", bubble_sort, length, SORTED);
    time_sort("bubble_sort on reverse", bubble_sort, length, REVERSE_SORTED);
    time_sort("bubble_sort on almost sorted", bubble_sort, length, ALMOST_SORTED);
    time_sort("qsort on random", stdlib_qsort, length, RANDOM);
    time_sort("qsort on sorted", stdlib_qsort, length, SORTED);
    time_sort("qsort on reverse", stdlib_qsort, length, REVERSE_SORTED);
    time_sort("qsort on almost sorted", stdlib_qsort, length, ALMOST_SORTED);
    time_sort("std::sort on random", std_sort, length, RANDOM);
    time_sort("std::sort on sorted", std_sort, length, SORTED);
    time_sort("std::sort on reverse", std_sort, length, REVERSE_SORTED);
    time_sort("std::sort on almost sorted", std_sort, length, ALMOST_SORTED);
    #ifdef USE_PDQSORT
    time_sort("pdqsort on random", pdq_sort, length, RANDOM);
    time_sort("pdqsort on sorted", pdq_sort, length, SORTED);
    #endif
    time_sort("quicksort on random", quicksort_wrapper, length, RANDOM);
    time_sort("quicksort on sorted", quicksort_wrapper, length, SORTED);
    time_sort("quicksort on reverse", quicksort_wrapper, length, REVERSE_SORTED);
    time_sort("quicksort on almost sorted", quicksort_wrapper, length, ALMOST_SORTED);
    time_sort("mergesort on random", mergesort_wrapper, length, RANDOM);
    time_sort("mergesort on sorted", mergesort_wrapper, length, SORTED);
    time_sort("mergesort on reverse", mergesort_wrapper, length, REVERSE_SORTED);
    time_sort("mergesort on almost sorted", mergesort_wrapper, length, ALMOST_SORTED);
    time_sort("insertion_sort on random", insertion_sort, length, RANDOM);
    time_sort("insertion_sort on sorted", insertion_sort, length, SORTED);
    time_sort("insertion_sort on reverse", insertion_sort, length, REVERSE_SORTED);
    time_sort("insertion_sort on almost sorted", insertion_sort, length, ALMOST_SORTED);
}

void just_sort(void(*sort)(DATA_T*, uint64_t), uint64_t length, array_ordering order) {
    DATA_T* array = create_array(length, order);
    if (array == NULL) {
        printf("Couldn't allocate.\n");
        return;
    }
    sort(array, length);
    assert(is_sorted(array, length));
    free(array);
}


int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Must give array size on command line.\n");
        return 1;
    }
    uint64_t length = atol(argv[1]);
    printf("Array size: %lu kB\n", length * sizeof(DATA_T) / 1024);
    
    // The real test...
    time_them(length);
    
    return 0;
}
