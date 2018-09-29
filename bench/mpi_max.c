#include <stdio.h>
#include <time.h>

#include "mpi.h"

int main(int argc, char* argv[])
{
    int rank;
    int size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    long n = 10000000000;
    long m = n / size;

    time_t beg, end;
    beg = time(NULL);

    long i;
    long max = 0;
    for (i = rank * m; i < (rank + 1) * m; ++i) {
        long num = ((i + 1) * (i - 1)) / 2;
        if (num > max) {
            max = num;
        }
    }
    printf("max: %d\n", max);

    end = time(NULL);
    printf("time: %d secs\n", end - beg);

    MPI_Finalize();
}
