import qtil.fn.Tp
import qtil.testing.Qnit
import qtil.fn.testlib

class TestCountOne extends Test, Case {
  override predicate run(Qnit test) {
    if Tp1<int, one/1>::doCount() = 1
    then test.pass("Count of one() is 1")
    else test.fail("Count of one() is not 1")
  }
}

class TestCountMultiple extends Test, Case {
  override predicate run(Qnit test) {
    if Tp1<int, oneToThree/1>::doCount() = 3
    then test.pass("Count of oneToThree() is 3")
    else test.fail("Count of oneToThree() is not 3")
  }
}

class TestFirst extends Test, Case {
  override predicate run(Qnit test) {
    if concat(Tp2<string, string, person/2>::first()) = "AdaAlanAlbertGraceMarie"
    then test.pass("First gets all first names")
    else test.fail("First gets incorrect names")
  }
}

class TestSecond extends Test, Case {
  override predicate run(Qnit test) {
    if concat(Tp2<string, string, person/2>::second()) = "CurieEinsteinHopperLovelaceTuring"
    then test.pass("Second gets all last names")
    else test.fail("Second gets incorrect names")
  }
}

class TestMap extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(Tp2<string, string, person/2>::Map<string, spaceJoin/2>::find()) = 5 and
      Tp2<string, string, person/2>::Map<string, spaceJoin/2>::find() = "Marie Curie" and
      Tp2<string, string, person/2>::Map<string, spaceJoin/2>::find() = "Albert Einstein" and
      Tp2<string, string, person/2>::Map<string, spaceJoin/2>::find() = "Ada Lovelace" and
      Tp2<string, string, person/2>::Map<string, spaceJoin/2>::find() = "Alan Turing" and
      Tp2<string, string, person/2>::Map<string, spaceJoin/2>::find() = "Grace Hopper"
    then test.pass("Map gets all names")
    else test.fail("Map gets incorrect names")
  }
}

class TestRelate extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(Tp2<string, string, person/2>::Relate<string, getElementNamedAfter/2>::find()) = 2 and
      Tp2<string, string, person/2>::Map<string, getElementNamedAfter/2>::find() = "Curium" and
      Tp2<string, string, person/2>::Map<string, getElementNamedAfter/2>::find() = "Einsteinium"
    then test.pass("Relate gets all names")
    else test.fail("Relate gets incorrect names")
  }
}

class TestProject1 extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string j | Tp2<string, string, person/2>::Project1<string, spaceJoin/2>::tp(j)) = 5 and
      Tp2<string, string, person/2>::Project1<string, spaceJoin/2>::tp("Marie Curie") and
      Tp2<string, string, person/2>::Project1<string, spaceJoin/2>::tp("Albert Einstein") and
      Tp2<string, string, person/2>::Project1<string, spaceJoin/2>::tp("Ada Lovelace") and
      Tp2<string, string, person/2>::Project1<string, spaceJoin/2>::tp("Alan Turing") and
      Tp2<string, string, person/2>::Project1<string, spaceJoin/2>::tp("Grace Hopper")
    then test.pass("Project1 gets all names")
    else test.fail("Project1 gets incorrect names")
  }
}

class TestProjectRelate1 extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string j |
        Tp2<string, string, person/2>::ProjectRelate1<string, getElementNamedAfter/2>::tp(j)
      ) = 2 and
      Tp2<string, string, person/2>::ProjectRelate1<string, getElementNamedAfter/2>::tp("Curium") and
      Tp2<string, string, person/2>::ProjectRelate1<string, getElementNamedAfter/2>::tp("Einsteinium")
    then test.pass("ProjectRelate1 gets all names")
    else test.fail("ProjectRelate1 gets incorrect names")
  }
}

class TestProject2 extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string j, string k |
        Tp2<string, string, person/2>::Project2<string, string, spaceJoin/2, rspaceJoin/2>::tp(j, k)
      ) = 5 and
      Tp2<string, string, person/2>::Project2<string, string, spaceJoin/2, rspaceJoin/2>::tp("Marie Curie",
        "Curie Marie") and
      Tp2<string, string, person/2>::Project2<string, string, spaceJoin/2, rspaceJoin/2>::tp("Albert Einstein",
        "Einstein Albert") and
      Tp2<string, string, person/2>::Project2<string, string, spaceJoin/2, rspaceJoin/2>::tp("Ada Lovelace",
        "Lovelace Ada") and
      Tp2<string, string, person/2>::Project2<string, string, spaceJoin/2, rspaceJoin/2>::tp("Alan Turing",
        "Turing Alan") and
      Tp2<string, string, person/2>::Project2<string, string, spaceJoin/2, rspaceJoin/2>::tp("Grace Hopper",
        "Hopper Grace")
    then test.pass("Project2 gets all names")
    else test.fail("Project2 gets incorrect names")
  }
}

class TestProjectRelate2 extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string j, string k |
        Tp2<string, string, person/2>::ProjectRelate2<string, string, getElementNamedAfter/2, getInitials/2>::tp(j,
          k)
      ) = 2 and
      Tp2<string, string, person/2>::ProjectRelate2<string, string, getElementNamedAfter/2, getInitials/2>::tp("Curium",
        "MC") and
      Tp2<string, string, person/2>::ProjectRelate2<string, string, getElementNamedAfter/2, getInitials/2>::tp("Einsteinium",
        "AE")
    then test.pass("ProjectRelate2 gets all elements and names")
    else test.fail("ProjectRelate2 gets incorrect elements and/or names")
  }
}

class TestMapFirst extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(Tp2<string, string, person/2>::MapFirst<string, toUpperCase/1>::find()) = 5 and
      Tp2<string, string, person/2>::MapFirst<string, toUpperCase/1>::find() = "MARIE" and
      Tp2<string, string, person/2>::MapFirst<string, toUpperCase/1>::find() = "ALBERT" and
      Tp2<string, string, person/2>::MapFirst<string, toUpperCase/1>::find() = "ADA" and
      Tp2<string, string, person/2>::MapFirst<string, toUpperCase/1>::find() = "ALAN" and
      Tp2<string, string, person/2>::MapFirst<string, toUpperCase/1>::find() = "GRACE"
    then test.pass("MapFirst gets all names")
    else test.fail("MapFirst gets incorrect names")
  }
}

class TestMapSecond extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(Tp2<string, string, person/2>::MapSecond<string, toUpperCase/1>::find()) = 5 and
      Tp2<string, string, person/2>::MapSecond<string, toUpperCase/1>::find() = "CURIE" and
      Tp2<string, string, person/2>::MapSecond<string, toUpperCase/1>::find() = "EINSTEIN" and
      Tp2<string, string, person/2>::MapSecond<string, toUpperCase/1>::find() = "LOVELACE" and
      Tp2<string, string, person/2>::MapSecond<string, toUpperCase/1>::find() = "TURING" and
      Tp2<string, string, person/2>::MapSecond<string, toUpperCase/1>::find() = "HOPPER"
    then test.pass("MapSecond gets all names")
    else test.fail("MapSecond gets incorrect names")
  }
}

class TestMapRelateFirst extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(Tp2<string, string, person/2>::MapRelateFirst<string, mightHaveLastName/1>::find()) = 5 and
      Tp2<string, string, person/2>::MapRelateFirst<string, mightHaveLastName/1>::find() = "Curie" and
      Tp2<string, string, person/2>::MapRelateFirst<string, mightHaveLastName/1>::find() =
        "Einstein" and
      Tp2<string, string, person/2>::MapRelateFirst<string, mightHaveLastName/1>::find() =
        "Lovelace" and
      Tp2<string, string, person/2>::MapRelateFirst<string, mightHaveLastName/1>::find() = "Turing" and
      Tp2<string, string, person/2>::MapRelateFirst<string, mightHaveLastName/1>::find() = "Hopper"
    then test.pass("MapRelateFirst gets all names")
    else test.fail("MapRelateFirst gets incorrect names")
  }
}

class TestMapRelateSecond extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(Tp2<string, string, person/2>::MapRelateSecond<string, mightHaveFirstName/1>::find()) =
        5 and
      Tp2<string, string, person/2>::MapRelateSecond<string, mightHaveFirstName/1>::find() = "Marie" and
      Tp2<string, string, person/2>::MapRelateSecond<string, mightHaveFirstName/1>::find() =
        "Albert" and
      Tp2<string, string, person/2>::MapRelateSecond<string, mightHaveFirstName/1>::find() = "Ada" and
      Tp2<string, string, person/2>::MapRelateSecond<string, mightHaveFirstName/1>::find() = "Alan" and
      Tp2<string, string, person/2>::MapRelateSecond<string, mightHaveFirstName/1>::find() = "Grace"
    then test.pass("MapRelateSecond gets all names")
    else test.fail("MapRelateSecond gets incorrect names")
  }
}

class TestExtendIntersect extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string f, string l, string i |
        Tp2<string, string, person/2>::ExtendIntersect<string, personInitialed/3>::tp(f, l, i)
      ) = 5 and
      Tp2<string, string, person/2>::ExtendIntersect<string, personInitialed/3>::tp("Marie",
        "Curie", "MC") and
      Tp2<string, string, person/2>::ExtendIntersect<string, personInitialed/3>::tp("Albert",
        "Einstein", "AE") and
      Tp2<string, string, person/2>::ExtendIntersect<string, personInitialed/3>::tp("Ada",
        "Lovelace", "AL") and
      Tp2<string, string, person/2>::ExtendIntersect<string, personInitialed/3>::tp("Alan",
        "Turing", "AT") and
      Tp2<string, string, person/2>::ExtendIntersect<string, personInitialed/3>::tp("Grace",
        "Hopper", "GH")
    then test.pass("ExtendIntersect gets all names")
    else test.fail("ExtendIntersect gets incorrect names")
  }
}

class TestExtendByFn extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string f, string l, string j |
        Tp2<string, string, person/2>::ExtendByFn<string, spaceJoin/2>::tp(f, l, j)
      ) = 5 and
      Tp2<string, string, person/2>::ExtendByFn<string, spaceJoin/2>::tp("Marie", "Curie",
        "Marie Curie") and
      Tp2<string, string, person/2>::ExtendByFn<string, spaceJoin/2>::tp("Albert", "Einstein",
        "Albert Einstein") and
      Tp2<string, string, person/2>::ExtendByFn<string, spaceJoin/2>::tp("Ada", "Lovelace",
        "Ada Lovelace") and
      Tp2<string, string, person/2>::ExtendByFn<string, spaceJoin/2>::tp("Alan", "Turing",
        "Alan Turing") and
      Tp2<string, string, person/2>::ExtendByFn<string, spaceJoin/2>::tp("Grace", "Hopper",
        "Grace Hopper")
    then test.pass("ExtendByFn gets all names")
    else test.fail("ExtendByFn gets incorrect names")
  }
}

class TestExtendByRelation extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string f, string l, string j |
        Tp2<string, string, person/2>::ExtendByRelation<string, getElementNamedAfter/2>::tp(f, l, j)
      ) = 2 and
      Tp2<string, string, person/2>::ExtendByRelation<string, getElementNamedAfter/2>::tp("Marie",
        "Curie", "Curium") and
      Tp2<string, string, person/2>::ExtendByRelation<string, getElementNamedAfter/2>::tp("Albert",
        "Einstein", "Einsteinium")
    then test.pass("ExtendByRelation gets all names")
    else test.fail("ExtendByRelation gets incorrect names")
  }
}

class TestExtendMapFirst extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string f, string l, string j |
        Tp2<string, string, person/2>::ExtendMapFirst<string, toUpperCase/1>::tp(f, l, j)
      ) = 5 and
      Tp2<string, string, person/2>::ExtendMapFirst<string, toUpperCase/1>::tp("Marie", "Curie",
        "MARIE") and
      Tp2<string, string, person/2>::ExtendMapFirst<string, toUpperCase/1>::tp("Albert", "Einstein",
        "ALBERT") and
      Tp2<string, string, person/2>::ExtendMapFirst<string, toUpperCase/1>::tp("Ada", "Lovelace",
        "ADA") and
      Tp2<string, string, person/2>::ExtendMapFirst<string, toUpperCase/1>::tp("Alan", "Turing",
        "ALAN") and
      Tp2<string, string, person/2>::ExtendMapFirst<string, toUpperCase/1>::tp("Grace", "Hopper",
        "GRACE")
    then test.pass("ExtendMapFirst gets all names")
    else test.fail("ExtendMapFirst gets incorrect names")
  }
}

class TestExtendRelateFirst extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string f, string l, string j |
        Tp2<string, string, person/2>::ExtendRelateFirst<string, mightHaveLastName/1>::tp(f, l, j)
      ) = 5 and
      Tp2<string, string, person/2>::ExtendRelateFirst<string, mightHaveLastName/1>::tp("Marie",
        "Curie", "Curie") and
      Tp2<string, string, person/2>::ExtendRelateFirst<string, mightHaveLastName/1>::tp("Albert",
        "Einstein", "Einstein") and
      Tp2<string, string, person/2>::ExtendRelateFirst<string, mightHaveLastName/1>::tp("Ada",
        "Lovelace", "Lovelace") and
      Tp2<string, string, person/2>::ExtendRelateFirst<string, mightHaveLastName/1>::tp("Alan",
        "Turing", "Turing") and
      Tp2<string, string, person/2>::ExtendRelateFirst<string, mightHaveLastName/1>::tp("Grace",
        "Hopper", "Hopper")
    then test.pass("ExtendRelateFirst gets all names")
    else test.fail("ExtendRelateFirst gets incorrect names")
  }
}

class TestExtendMapSecond extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string f, string l, string j |
        Tp2<string, string, person/2>::ExtendMapSecond<string, toUpperCase/1>::tp(f, l, j)
      ) = 5 and
      Tp2<string, string, person/2>::ExtendMapSecond<string, toUpperCase/1>::tp("Marie", "Curie",
        "CURIE") and
      Tp2<string, string, person/2>::ExtendMapSecond<string, toUpperCase/1>::tp("Albert",
        "Einstein", "EINSTEIN") and
      Tp2<string, string, person/2>::ExtendMapSecond<string, toUpperCase/1>::tp("Ada", "Lovelace",
        "LOVELACE") and
      Tp2<string, string, person/2>::ExtendMapSecond<string, toUpperCase/1>::tp("Alan", "Turing",
        "TURING") and
      Tp2<string, string, person/2>::ExtendMapSecond<string, toUpperCase/1>::tp("Grace", "Hopper",
        "HOPPER")
    then test.pass("ExtendMapSecond gets all names")
    else test.fail("ExtendMapSecond gets incorrect names")
  }
}

class TestExtendRelateSecond extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string f, string l, string j |
        Tp2<string, string, person/2>::ExtendRelateSecond<string, mightHaveFirstName/1>::tp(f, l, j)
      ) = 5 and
      Tp2<string, string, person/2>::ExtendRelateSecond<string, mightHaveFirstName/1>::tp("Marie",
        "Curie", "Marie") and
      Tp2<string, string, person/2>::ExtendRelateSecond<string, mightHaveFirstName/1>::tp("Albert",
        "Einstein", "Albert") and
      Tp2<string, string, person/2>::ExtendRelateSecond<string, mightHaveFirstName/1>::tp("Ada",
        "Lovelace", "Ada") and
      Tp2<string, string, person/2>::ExtendRelateSecond<string, mightHaveFirstName/1>::tp("Alan",
        "Turing", "Alan") and
      Tp2<string, string, person/2>::ExtendRelateSecond<string, mightHaveFirstName/1>::tp("Grace",
        "Hopper", "Grace")
    then test.pass("ExtendRelateSecond gets all names")
    else test.fail("ExtendRelateSecond gets incorrect names")
  }
}
