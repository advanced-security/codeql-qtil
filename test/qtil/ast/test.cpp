void f1(long plong, int pint) {
    plong + plong; // Not constant plus integer
    plong + pint; // Not constant plus integer
    plong + 1l; // Not constant plus integer
    plong + 1; // Not constant plus integer
    pint + plong; // Not constant plus integer
    pint + pint; // Not constant plus integer
    pint + 1l; // Constant plus integer
    pint + 1; // Constant plus integer
    1l + plong; // Not constant plus integer
    1l + pint; // Constant plus integer
    1l + 1l; // Not constant plus integer
    1l + 1; // Constant plus integer
    1 + plong; // Not constant plus integer
    1 + pint; // Constant plus integer
}