import qtil.list.ListBuilder
import qtil.inheritance.UnderlyingString
import qtil.testing.Qnit

class TestBasicListBuilder extends Test, Case {
  override predicate run(Qnit test) {
    if
      ListBuilder<Separator::comma/0>::of1("a") = "a" and
      ListBuilder<Separator::colon/0>::of1("a") = "a" and
      ListBuilder<Separator::comma/0>::of2("a", "b") = "a,b" and
      ListBuilder<Separator::colon/0>::of2("a", "b") = "a:b" and
      ListBuilder<Separator::comma/0>::of3("a", "b", "c") = "a,b,c" and
      ListBuilder<Separator::colon/0>::of3("a", "b", "c") = "a:b:c" and
      ListBuilder<Separator::comma/0>::of4("a", "b", "c", "d") = "a,b,c,d" and
      ListBuilder<Separator::colon/0>::of4("a", "b", "c", "d") = "a:b:c:d" and
      ListBuilder<Separator::comma/0>::of5("a", "b", "c", "d", "e") = "a,b,c,d,e" and
      ListBuilder<Separator::colon/0>::of5("a", "b", "c", "d", "e") = "a:b:c:d:e" and
      ListBuilder<Separator::comma/0>::of6("a", "b", "c", "d", "e", "f") = "a,b,c,d,e,f" and
      ListBuilder<Separator::colon/0>::of6("a", "b", "c", "d", "e", "f") = "a:b:c:d:e:f" and
      ListBuilder<Separator::comma/0>::of7("a", "b", "c", "d", "e", "f", "g") = "a,b,c,d,e,f,g" and
      ListBuilder<Separator::colon/0>::of7("a", "b", "c", "d", "e", "f", "g") = "a:b:c:d:e:f:g" and
      ListBuilder<Separator::comma/0>::of8("a", "b", "c", "d", "e", "f", "g", "h") =
        "a,b,c,d,e,f,g,h" and
      ListBuilder<Separator::colon/0>::of8("a", "b", "c", "d", "e", "f", "g", "h") =
        "a:b:c:d:e:f:g:h"
    then test.pass("Basic list builder works")
    else test.fail("Basic list builder does not work")
  }
}

bindingset[this]
class TestExtendsString extends string {
  bindingset[this, s]
  predicate isEqualTo(string s) { this = s }
}

class TestTypedListBuilder extends Test, Case {
  override predicate run(Qnit test) {
    if
      TypedListBuilder<Separator::comma/0, TestExtendsString>::of1("a").isEqualTo("a") and
      TypedListBuilder<Separator::colon/0, TestExtendsString>::of1("a").isEqualTo("a") and
      TypedListBuilder<Separator::comma/0, TestExtendsString>::of2("a", "b").isEqualTo("a,b") and
      TypedListBuilder<Separator::colon/0, TestExtendsString>::of2("a", "b").isEqualTo("a:b") and
      TypedListBuilder<Separator::comma/0, TestExtendsString>::of3("a", "b", "c").isEqualTo("a,b,c") and
      TypedListBuilder<Separator::colon/0, TestExtendsString>::of3("a", "b", "c").isEqualTo("a:b:c") and
      TypedListBuilder<Separator::comma/0, TestExtendsString>::of4("a", "b", "c", "d")
          .isEqualTo("a,b,c,d") and
      TypedListBuilder<Separator::colon/0, TestExtendsString>::of4("a", "b", "c", "d")
          .isEqualTo("a:b:c:d") and
      TypedListBuilder<Separator::comma/0, TestExtendsString>::of5("a", "b", "c", "d", "e")
          .isEqualTo("a,b,c,d,e") and
      TypedListBuilder<Separator::colon/0, TestExtendsString>::of5("a", "b", "c", "d", "e")
          .isEqualTo("a:b:c:d:e") and
      TypedListBuilder<Separator::comma/0, TestExtendsString>::of6("a", "b", "c", "d", "e", "f")
          .isEqualTo("a,b,c,d,e,f") and
      TypedListBuilder<Separator::colon/0, TestExtendsString>::of6("a", "b", "c", "d", "e", "f")
          .isEqualTo("a:b:c:d:e:f") and
      TypedListBuilder<Separator::comma/0, TestExtendsString>::of7("a", "b", "c", "d", "e", "f", "g")
          .isEqualTo("a,b,c,d,e,f,g") and
      TypedListBuilder<Separator::colon/0, TestExtendsString>::of7("a", "b", "c", "d", "e", "f", "g")
          .isEqualTo("a:b:c:d:e:f:g") and
      TypedListBuilder<Separator::comma/0, TestExtendsString>::of8("a", "b", "c", "d", "e", "f",
        "g", "h").isEqualTo("a,b,c,d,e,f,g,h") and
      TypedListBuilder<Separator::colon/0, TestExtendsString>::of8("a", "b", "c", "d", "e", "f",
        "g", "h").isEqualTo("a:b:c:d:e:f:g:h")
    then test.pass("Typed list builder works")
    else test.fail("Typed list builder does not work")
  }
}

bindingset[i]
bindingset[result]
string intToString(int i) {
  result = i.toString() and
  i = result.toInt()
}

class TestListBuilderOf extends Test, Case {
  override predicate run(Qnit test) {
    if
      ListBuilderOf<Separator::comma/0, int, intToString/1>::of1(1) = "1" and
      ListBuilderOf<Separator::colon/0, int, intToString/1>::of1(1) = "1" and
      ListBuilderOf<Separator::comma/0, int, intToString/1>::of2(1, 2) = "1,2" and
      ListBuilderOf<Separator::colon/0, int, intToString/1>::of2(1, 2) = "1:2" and
      ListBuilderOf<Separator::comma/0, int, intToString/1>::of3(1, 2, 3) = "1,2,3" and
      ListBuilderOf<Separator::colon/0, int, intToString/1>::of3(1, 2, 3) = "1:2:3" and
      ListBuilderOf<Separator::comma/0, int, intToString/1>::of4(1, 2, 3, 4) = "1,2,3,4" and
      ListBuilderOf<Separator::colon/0, int, intToString/1>::of4(1, 2, 3, 4) = "1:2:3:4" and
      ListBuilderOf<Separator::comma/0, int, intToString/1>::of5(1, 2, 3, 4, 5) = "1,2,3,4,5" and
      ListBuilderOf<Separator::colon/0, int, intToString/1>::of5(1, 2, 3, 4, 5) = "1:2:3:4:5" and
      ListBuilderOf<Separator::comma/0, int, intToString/1>::of6(1, 2, 3, 4, 5, 6) = "1,2,3,4,5,6" and
      ListBuilderOf<Separator::colon/0, int, intToString/1>::of6(1, 2, 3, 4, 5, 6) = "1:2:3:4:5:6" and
      ListBuilderOf<Separator::comma/0, int, intToString/1>::of7(1, 2, 3, 4, 5, 6, 7) =
        "1,2,3,4,5,6,7" and
      ListBuilderOf<Separator::colon/0, int, intToString/1>::of7(1, 2, 3, 4, 5, 6, 7) =
        "1:2:3:4:5:6:7" and
      ListBuilderOf<Separator::comma/0, int, intToString/1>::of8(1, 2, 3, 4, 5, 6, 7, 8) =
        "1,2,3,4,5,6,7,8" and
      ListBuilderOf<Separator::colon/0, int, intToString/1>::of8(1, 2, 3, 4, 5, 6, 7, 8) =
        "1:2:3:4:5:6:7:8"
    then test.pass("ListBuilderOf works")
    else test.fail("ListBuilderOf does not work")
  }
}

module TypedListBuilderOfComma =
  TypedListBuilderOf<Separator::comma/0, TestExtendsString, int, intToString/1>;

module TypedListBuilderOfColon =
  TypedListBuilderOf<Separator::colon/0, TestExtendsString, int, intToString/1>;

class TestTypedListBuilderOf extends Test, Case {
  override predicate run(Qnit test) {
    if
      TypedListBuilderOfComma::of1(1).isEqualTo("1") and
      TypedListBuilderOfColon::of1(1).isEqualTo("1") and
      TypedListBuilderOfComma::of2(1, 2).isEqualTo("1,2") and
      TypedListBuilderOfColon::of2(1, 2).isEqualTo("1:2") and
      TypedListBuilderOfComma::of3(1, 2, 3).isEqualTo("1,2,3") and
      TypedListBuilderOfColon::of3(1, 2, 3).isEqualTo("1:2:3") and
      TypedListBuilderOfComma::of4(1, 2, 3, 4).isEqualTo("1,2,3,4") and
      TypedListBuilderOfColon::of4(1, 2, 3, 4).isEqualTo("1:2:3:4") and
      TypedListBuilderOfComma::of5(1, 2, 3, 4, 5).isEqualTo("1,2,3,4,5") and
      TypedListBuilderOfColon::of5(1, 2, 3, 4, 5).isEqualTo("1:2:3:4:5") and
      TypedListBuilderOfComma::of6(1, 2, 3, 4, 5, 6).isEqualTo("1,2,3,4,5,6") and
      TypedListBuilderOfColon::of6(1, 2, 3, 4, 5, 6).isEqualTo("1:2:3:4:5:6") and
      TypedListBuilderOfComma::of7(1, 2, 3, 4, 5, 6, 7).isEqualTo("1,2,3,4,5,6,7") and
      TypedListBuilderOfColon::of7(1, 2, 3, 4, 5, 6, 7).isEqualTo("1:2:3:4:5:6:7") and
      TypedListBuilderOfComma::of8(1, 2, 3, 4, 5, 6, 7, 8).isEqualTo("1,2,3,4,5,6,7,8") and
      TypedListBuilderOfColon::of8(1, 2, 3, 4, 5, 6, 7, 8).isEqualTo("1:2:3:4:5:6:7:8")
    then test.pass("TypedListBuilderOf works")
    else test.fail("TypedListBuilderOf does not work")
  }
}
