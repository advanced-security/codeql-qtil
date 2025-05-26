public class Test {
    public static void f1() {
        int a = 1;
        int b = 2;
        f2(a + a);
        f2(a + b);
        f2(b + a);
        f2(b + b);
    }

    public static void f2(int x) {}
}