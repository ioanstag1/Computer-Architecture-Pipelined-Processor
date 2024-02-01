#include <stdio.h>

extern void fib(int n, int *fib_array);

int main() {
    int n = 10; // generate the first 10 Fibonacci numbers
    int fib_array[n];

    // Call the RISC-V assembly function to generate the Fibonacci numbers
    fib(n, fib_array);
}