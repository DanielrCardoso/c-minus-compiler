int factorial(int n) {
    if (n == 0)
        return 1;
    else
        return n * factorial(n - 1);
}

void main(void) {
    int f;
    f = factorial(5);
}
