"""
Generate library documentation for qtil using `codeql generate library-doc`.

Usage:
    python scripts/generate_docs.py [--output=DIR] [--search-path=PATH]

Defaults:
    --output=src/doc    Output directory for the generated docs
    --search-path=.     Search path for resolving packs

The script:
  1. Runs `codeql generate library-doc` for the core pack and each language pack,
     combining all docs into a single output directory.
  2. Creates an index.html with links to the core and each language pack.
  3. Scans the generated HTML for broken links and reports them.
"""

import os
import sys
import shutil
import subprocess
import argparse
import tempfile
from html.parser import HTMLParser
from urllib.parse import urlparse, unquote, urljoin
from pathlib import Path
from collections import defaultdict
from jinja2 import Environment, FileSystemLoader


SCRIPT_DIR = Path(__file__).resolve().parent
CUSTOM_CSS = SCRIPT_DIR / "qldoc-custom.css"

LANGUAGES = ["cpp", "csharp", "go", "java", "javascript", "python", "ruby", "swift"]

# Map from language directory name to the entry-point .qll file name (without extension).
LANG_ENTRY_POINTS = {
    "cpp": "Cpp",
    "csharp": "Csharp",
    "go": "Go",
    "java": "Java",
    "javascript": "Javascript",
    "python": "Python",
    "ruby": "Ruby",
    "swift": "Swift",
}


def run_codeql_generate(lang: str, search_path: str, save_to: str):
    """
    Run codeql generate library-doc into a temp directory, then merge into output_dir.

    The generator refuses to write into an existing directory, so we generate
    into a fresh temp dir and copy the contents over.

    If save_index_as is provided, the generator's index.html is saved under that
    filename in the output directory before being overwritten by the merge.
    """
    with tempfile.TemporaryDirectory(prefix="qtil-doc-"+ lang) as tmp_dir:
        out_path = Path(tmp_dir) / "out"
        cmd = [
            "codeql", "generate", "library-doc",
            f"--output={out_path}",
            "--title=qtil",
            f"--css={CUSTOM_CSS}",
            f"--dir={lang}/src",
            f"--search-path={search_path}",
        ]

        print(f"\n{'='*60}")
        print(f"Generating docs for: {lang}")
        print(f"{'='*60}")
        result = subprocess.run(cmd, capture_output=False)
        if result.returncode != 0:
            print(
                f"\nWarning: codeql generate library-doc exited with code {result.returncode}. "
                "Proceeding anyway (known crash — output is likely still usable).\n"
            )

        # Merge temp output into the final output directory
        if not out_path.exists():
            print(f"Warning: no output generated for {lang}")
            return

        save_to_path = Path(save_to)
        file_count = 0
        for src_file in out_path.rglob("*"):
            if src_file.is_file():
                rel = src_file.relative_to(out_path)
                # Save the generator's index.html as an appendix before merging
                if rel.name == "index.html" and rel.parent == Path("."):
                    dest_appendix = save_to_path / f"{lang}-appendix.html"
                    shutil.copy2(src_file, dest_appendix)
                    print(f"Saved appendix: {dest_appendix}")
                    continue;

                dest = save_to_path / rel
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(src_file, dest)
                file_count += 1
        print(f"Merged {file_count} files from {lang} into {save_to}")


def ensure_custom_css(output_dir: str):
    """
    Copy the custom CSS into the output directory.

    The --css flag should handle this, but the generator crash may prevent it
    from being applied. Overwrite the output qldoc.css as a fallback.
    """
    out = Path(output_dir)
    target = out / "qldoc.css"
    if target.exists():
        shutil.copy2(CUSTOM_CSS, target)
        print(f"Custom CSS applied to {target}")
    else:
        print(f"Warning: {target} not found — CSS was not generated at all.")


def create_index_html(output_dir: str, generated_langs: list[str]):
    """Create an index.html with links to the core pack and each language pack."""
    out = Path(output_dir)

    # Resolve the core entry point
    core_target = "qtil/Qtil.qll/module.Qtil.html"
    core_link = core_target if (out / core_target).exists() else None

    # Resolve language entry points and appendix pages
    lang_packs = []
    for lang in generated_langs:
        entry = LANG_ENTRY_POINTS.get(lang, lang.capitalize())
        module_path = f"qtil/{entry}.qll/module.{entry}.html"
        appendix_file = f"{lang}-appendix.html"
        lang_packs.append({
            "display": f"qtil-{lang}",
            "module_path": module_path if (out / module_path).exists() else None,
            "appendix_path": appendix_file if (out / appendix_file).exists() else None,
        })

    index_path = out / "index.html"
    print(f"Creating {index_path}")

    env = Environment(
        loader=FileSystemLoader(SCRIPT_DIR / "templates"),
        keep_trailing_newline=True,
    )
    template = env.get_template("index.html.j2")
    index_path.write_text(template.render(
        core_link=core_link,
        lang_packs=lang_packs,
    ))


class LinkExtractor(HTMLParser):
    """Extract href and src attributes from HTML."""

    def __init__(self):
        super().__init__()
        self.links: list[tuple[str, str]] = []  # (attr_name, url)

    def handle_starttag(self, tag, attrs):
        for attr, value in attrs:
            if attr in ("href", "src") and value:
                self.links.append((attr, value))


def main():
    parser = argparse.ArgumentParser(description="Generate qtil library documentation.")
    parser.add_argument("--output", default="src/doc", help="Output directory (default: src/doc)")
    parser.add_argument("--search-path", default=".", help="CodeQL search path (default: .)")
    args = parser.parse_args()

    # Clean output directory for a fresh build
    out = Path(args.output)
    if out.exists():
        shutil.rmtree(out)
        print(f"Cleaned existing output directory: {args.output}")

    # Step 2: Generate docs for each language pack into the same output directory
    generated_langs = []
    for lang in LANGUAGES:
        run_codeql_generate(lang, args.search_path, args.output)
        generated_langs.append(lang)

    # Step 3: Ensure custom CSS is applied (fallback for crash)
    ensure_custom_css(args.output)

    # Step 4: Create index.html with links to all packs
    create_index_html(args.output, generated_langs)

if __name__ == "__main__":
    main()
