void f1()
{ // B1
  // Single basic block function.
}

void f2(bool p1)
{ // B1
    f1();
    if (p1)
    { // B2
        f1();
    }
    else
    { // B3
        f1();
    }
    // B4
    f1();
}

void f3(bool p1)
{ // B1
    f1();
    while (p1) // B2
    { // B3
        f1();
    }
    // B4
    f1();
}

void f4(bool p1) // B4 -- Not sure why this is assigned block 4
{ // B1
    f1();
    if (p1)
    { // B2
        f1();
        return;
    }
    // B3
    f1();
    if (p1)
    { // B5
        f1();
        return;
    }
    // B6
    f1();
}

void f5(bool p1)
{ // B1
    f1();
    if (p1)
    { // B2
        f1();
        if (p1)
        { // B4
            f1();
        }
        else
        { // B5
            f1();
        }
    }
    else
    { // B3
        f1();
    }
    // B6
    f1();
}

void f6()
{ // B1
    f1();
    if (true)
    { // B2
        if (false)
        { // Unreachable, no ID.
            f1();
        }
        else
        { // B3
            f1();
        }
    }
    else
    { // Unreachable, no ID.
        f1();
    }
    // B4
    f1();
}

void f7()
{ // B1
    f1();
    for (int i = 0; i < 10; i++) // B2
    { // B3
        f1();
        if (i % 2 == 0)
        { // B5
            f1();
        }
        else
        { // B6
            f1();
        }
        // B7
        f1();
    }
    // B4
    f1();
}

void f8()
{ // B1
    f1();
    if (true)
    { // B2
        f1();
        for (int i = 0; i < 5; i++) // B3
        { // B4
            f1();
        }
        // B5
        f1();
    }
    else
    { // unreachable
        f1();
    }
    // B6
    f1();
}

void f9()
{ // B1
    f1();
    while (true) // B2
    { // B3
        f1();
        if (true)
        { // B4
            f1();
            break;
        }
        // B5
        f1();
    }
    // Unreachable, no block id
    f1();
}