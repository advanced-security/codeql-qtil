### This script generates unicode_data.yaml from UnicodeData.txt, DerivedNormalizationProps.txt,
### and DerivedCoreProperties.txt files in the scripts/unicode directory.
###
### Usage:
###   python generate_unicode.py ${unicode_version}
###
### Requires the latest Unicode data files from: https://www.unicode.org/Public/UCD/latest/ucd/
### are downloaded and placed in the scripts/unicode directory before running this script.

import os
import sys

# Check that the user provided a Unicode version argument
if len(sys.argv) != 2:
    print("Usage: python generate_unicode.py ${unicode_version}")
    sys.exit(1)

unicode_version = sys.argv[1]

unicode_common_properties = []
unicode_boolean_properties = []
unicode_numeric_properties = []



def add_common_property(code_point, name, value):
    if value != '':
        unicode_common_properties.append({
            'code_point': code_point,
            'name': name,
            'value': value
        })

def add_boolean_property(code_point, name, value):
    if value == 'Y':
        unicode_boolean_properties.append({
            'code_point': code_point,
            'name': name
        })

def add_numeric_property(code_point, name, value):
    # handle fractional values like '1/5'
    if '/' in value:
        # Convert '1/5' to a float
        parts = value.split('/')
        numeric_value = float(parts[0]) / float(parts[1])
    else:
        numeric_value = float(value)
    unicode_numeric_properties.append({
        'code_point': code_point,
        'name': name,
        'value': numeric_value
    })

# Trim comments (starting with '#') and whitespace from the line
def parse_line(line):
    return line.split('#')[0].strip()

def parse_unicode_data_txt():
    if not os.path.exists('scripts/unicode/UnicodeData.txt'):
        raise FileNotFoundError("UnicodeData.txt not found in scripts/unicode directory.")

    with open('scripts/unicode/UnicodeData.txt', 'r', encoding='utf-8') as f:
        lines = f.readlines()

    for line in lines:
        line = parse_line(line)
        if not line:
            continue

        parts = line.split(';')
        code_point_hex = parts[0].strip()
        code_point = int(code_point_hex, 16)
        name = parts[1].strip()
        general_category = parts[2].strip()
        canonical_combining_class = parts[3].strip()
        bidi_class = parts[4].strip()
        decomposition_data = parts[5].strip()
        numeric_part_a = parts[6].strip()
        numeric_part_b = parts[7].strip()
        numeric_part_c = parts[8].strip()
        bidi_mirrored = parts[9].strip()
        # Not captured: Unicode_1_Name, ISO_Comment
        simple_uppercase_mapping = parts[12].strip()
        simple_lowercase_mapping = parts[13].strip()
        simple_titlecase_mapping = parts[14].strip()

        # exclude <label> entries
        if not name.startswith('<') and not name.endswith('>'):
            add_common_property(code_point, 'Name', name)
        add_common_property(code_point, 'General_Category', general_category)
        add_common_property(code_point, 'Canonical_Combining_Class', canonical_combining_class)
        add_common_property(code_point, 'Bidi_Class', bidi_class)
        if not numeric_part_c == '':
            add_numeric_property(code_point, 'Numeric_Value', numeric_part_c)
            if numeric_part_a == numeric_part_c:
                add_common_property(code_point, 'Numeric_Type', 'Decimal')
            elif numeric_part_b == numeric_part_c:
                add_common_property(code_point, 'Numeric_Type', 'Digit')
            else:
                add_common_property(code_point, 'Numeric_Type', 'Numeric')
        add_boolean_property(code_point, 'Bidi_Mirrored', bidi_mirrored)
        add_common_property(code_point, 'Simple_Uppercase_Mapping', simple_uppercase_mapping)
        add_common_property(code_point, 'Simple_Lowercase_Mapping', simple_lowercase_mapping)
        add_common_property(code_point, 'Simple_Titlecase_Mapping', simple_titlecase_mapping)

def parse_derived_normalization_props_txt():
    if not os.path.exists('scripts/unicode/DerivedNormalizationProps.txt'):
        raise FileNotFoundError("DerivedNormalizationProps.txt not found in scripts/unicode directory.")

    with open('scripts/unicode/DerivedNormalizationProps.txt', 'r', encoding='utf-8') as f:
        lines = f.readlines()

    for line in lines:
        line = parse_line(line)
        if not line:
            continue

        parts = line.split(';')
        if len(parts) < 3:
            # Skip boolean properties, which have only two parts, but are all either deprecated or redundant.
            continue

        code_point_hex_pair = parts[0].strip()
        if '..' not in code_point_hex_pair:
            code_point_start = code_point_end = int(code_point_hex_pair, 16)
        else:
        # handle ranges like '00A0..00A7'
            code_point_hex_start, code_point_hex_end = code_point_hex_pair.split('..')
            code_point_start, code_point_end = int(code_point_hex_start, 16), int(code_point_hex_end, 16)
        prop = parts[1].strip()
        value = parts[2].strip()

        # Not handling properties Full_Composition_Exclusion (redundant), Expands_On_* (deprecated),
        # FC_NFKC_Closure (deprecated), Changes_When_NFKC_Casefolded (redundant).
        if prop in ['NFD_QC', 'NFKD_QC', 'NFC_QC', 'NFKC_QC', 'NFKC_CF', 'NFKC_SCF']:
            for code_point in range(code_point_start, code_point_end + 1):
                add_common_property(code_point, prop, value)

def parse_derived_core_properties_txt():
    if not os.path.exists('scripts/unicode/DerivedCoreProperties.txt'):
        raise FileNotFoundError("DerivedCoreProperties.txt not found in scripts/unicode directory.")

    with open('scripts/unicode/DerivedCoreProperties.txt', 'r', encoding='utf-8') as f:
        lines = f.readlines()

    for line in lines:
        line = parse_line(line)
        if not line:
            continue

        parts = line.split(';')
        code_point_hex_pair = parts[0].strip()
        if '..' not in code_point_hex_pair:
            code_point_start = code_point_end = int(code_point_hex_pair, 16)
        else:
        # handle ranges like '00A0..00A7'
            code_point_hex_start, code_point_hex_end = code_point_hex_pair.split('..')
            code_point_start, code_point_end = int(code_point_hex_start, 16), int(code_point_hex_end, 16)

        prop = parts[1].strip()

        # skip properties Grapheme_Link (deprecated), Indic_Conjuct_Break (for simplicity, not binary)
        if not prop in ['Grapheme_Link', 'Indic_Conjunct_Break']:
            for code_point in range(code_point_start, code_point_end + 1):
                add_boolean_property(code_point, prop, 'Y')

def write_unicode_data_yaml():
    with open('src/qtil/strings/generated/unicode.yaml', 'w', encoding='utf-8') as f:
        f.write(
'''extensions:
  - addsTo:
      pack: advanced-security/qtil
      extensible: unicodeVersion
    data:
      - ["''' + unicode_version + '''"]
  - addsTo:
      pack: advanced-security/qtil
      extensible: unicodeHasProperty
    data:''')
        for entry in unicode_common_properties:
            f.write(f"""
      - [{entry['code_point']}, '{entry['name']}', '{entry['value']}']""")

        f.write('''
  - addsTo:
      pack: advanced-security/qtil
      extensible: unicodeHasBooleanProperty
    data:''')
        for entry in unicode_boolean_properties:
            f.write(f"""
      - [{entry['code_point']}, '{entry['name']}']""")

        f.write('''
  - addsTo:
      pack: advanced-security/qtil
      extensible: unicodeHasNumericProperty
    data:''')
        for entry in unicode_numeric_properties:
            f.write(f"""
      - [{entry['code_point']}, '{entry['name']}', {entry['value']}]""")

if __name__ == "__main__":
    print("""
This script generates unicode_data.yaml from UnicodeData.txt, DerivedNormalizationProps.txt,
and DerivedCoreProperties.txt files in the scripts/unicode directory.

Download the latest Unicode data files from:
https://www.unicode.org/Public/UCD/latest/ucd/

Place the downloaded files in the scripts/unicode directory before running this script.

Running....
    """)

    parse_unicode_data_txt()
    parse_derived_normalization_props_txt()
    parse_derived_core_properties_txt()
    write_unicode_data_yaml()

    print("SUCCESS! Unicode data has been successfully generated in 'src/qtil/strings/generated/unicode.yaml'.")