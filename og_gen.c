// gcc -O3 -o gen gen.c
#include<stdio.h>
#include<stdlib.h>

int mot[1000000], tm[1000], i, size, x, a, b, n, d, p, count;

int ceiling(int a, int b) { return (a + b - 1) / b; }

int rep(int *m, int i, int n, int d, int plus) {
    int y, z, lon;
    for (lon = 1; (z = ceiling(lon * n + plus, d)) <= i + 1; lon++) {
        for (y = i - lon; (y >= 0) && (m[y] == m[y + lon]); y--);
        if (i - y >= z) return 0;
    }
    return 1;
}//*/

int pp(int *m, int i) {// checks pseudoperiodicity and power-freeness
    if (i >= b && m[i] != m[i - a] && m[i] != m[i - b]) return 0;
    return rep(m, i, n, d, p);
}

int ok1() {// checks h(00)
    for (x = 0; x < size; x++) {
        mot[size + x] = mot[x];
        if (!pp(mot, size + x)) return 0;
    }
    return 1;
}

int ok2() {// checks h(tm[0..99]). Take larger values of 100 for extra confidence
    for (x = 2 * size; x < 100 * size; x++) {
        mot[x] = mot[x % size + size * (tm[x / size])];
        if (!pp(mot, x)) return 0;
    }
    return 1;
}

int
display() {// the morphism is displayed in reversed order because we test "x[n] = x[n-a] or x[n-b]" instead of "x[n] = x[n+a] or x[n+b]"
    printf("OK pseudoperiod (%d,%d) (%d/%d%s)-free size=%d\n", a, b, n, d, p ? "+" : "", size);
    for (x = 0; x < size; x++) printf("%d", mot[size - 1 - x]);
    printf("\n");
    for (x = 0; x < size; x++) printf("%d", mot[2 * size - 1 - x]);
    printf("\n");


    char fName[40];
    snprintf(fName,sizeof fName,"./genOut/%d_%d_311_S%d.txt", a, b, count);

    FILE *fileSeq = fopen(fName, "w");
    if (fileSeq == NULL) {
        printf("Error opening file!\n");
        exit(1);
    }

    fprintf(fileSeq, "morphism sha%d \"0->", count);
    for (x = 0; x < size; x++) fprintf(fileSeq, "%d", mot[size - 1 - x]);
    fprintf(fileSeq, " 1->");
    for (x = 0; x < size; x++) fprintf(fileSeq, "%d", mot[2 * size - 1 - x]);
    fprintf(fileSeq, "\":\n");

    fprintf(fileSeq, "image S%d sha%d T:\n", count, count);

    fprintf(fileSeq, "eval pp%d_%d_checkS%d \"An (S%d[n]=S%d[n+%d]|S%d[n]=S%d[n+%d])\":\n", a, b, count, count, count, a, count, count, b);

    fprintf(fileSeq, "eval cubeplusfree_S%d \"Ei,n n>0 & Aj (j<=2*n) => S%d[i+j] = S%d[i+j+n]\":\n", count, count, count);

    fclose(fileSeq);

    exit(0);
}

int A() {// backtracking to get mot[0..2*size-1] = h(01)
    printf("size=%d\n", size);
    for (*mot = i = 0;;)
        if (!pp(mot, i) || (i == size - 1 && !ok1()) || (i == 2 * size - 1 && !ok2())) {
            while (mot[i]) if (!(--i)) return 1;
            mot[i]++;
        } else if (i == 2 * size - 1) display(); else mot[++i] = 0;
}

void usage() {
    printf("To compile and run:\n");
    printf("gcc -O3 -o gen gen.c\n");
    printf("./gen a b n d p count\n");
    printf("pseudoperiod (a,b) with a < b\n");
    printf("forces n/d-freeness if p = 0\n");
    printf("forces (n/d^+)-freeness if p = 1\n");
    printf("count is a number that will be used to label walnut statements and output file name");
    exit(0);
}

int main(int ac, char **av) {
    if (ac != 7) usage();
    a = atoi(av[1]);
    b = atoi(av[2]);
    n = atoi(av[3]);
    d = atoi(av[4]);
    p = atoi(av[5]);
    count = atoi(av[6]);
    for (*tm = x = 0; x < 1000; x++) tm[x] = x & 1 ? !tm[x - 1] : tm[x / 2]; // building thue-morse
    for (size = 1; A() && size < 1000; size++);
}
