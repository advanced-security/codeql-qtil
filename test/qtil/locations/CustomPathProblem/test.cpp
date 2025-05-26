class C1 {
    public: C1() {}
};

class C2 {
    public: C2() {}
};

class C3 {
    public: C3() {}
    int m1() {
        return 1;
    }
};

int f1() {
    C1 c1;
    return 1;
}

int f2() {
    return f1();
}

int f3() {
    return 1;
}

int f4() {
    return f3();
}

int g1 = f1(); // NON_COMPLIANT
int g2 = f2(); // NON_COMPLIANT
int g3 = f3(); // COMPLIANT
int g4 = f4(); // COMPLIANT
C1 c1; // NON_COMPLIANT
int g5 = C3().m1(); // NON_COMPLIANT
int g6 = f3() + f2(); // NON_COMPLIANT
