private import codeql.util.Location

/**
 * A signature module that allows cross language support for locatable elements in a query language,
 * for instance C++ or Java.
 *
 * This module, and `qtil` modules that depend on it, should already have preexisting
 * language-specific implementations in the `qtil` modules for each language, so that you don't have
 * to implement it yourself, for instance, in `qtil.Cpp` or `qtil.Java`. However, implementing this
 * module allows you to add qtil support for new languages.
 */
signature module LocatableConfig<LocationSig Location> {
  class Locatable {
    Location getLocation();

    string toString();
  }
}
