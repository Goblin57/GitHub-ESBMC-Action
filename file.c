int main() {
    int x = 0;
    x = x + 1;
    __ESBMC_assert (x==1);
}