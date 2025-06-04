import argparse
import os
import subprocess
import glob
import json

def get_workspace_packs(root):
    # Find the packs by globbing using the 'provide' patterns in the manifest.
    os.chdir(root)
    with open('.codeqlmanifest.json') as manifest_file:
        manifest = json.load(manifest_file)
    packs = []
    for pattern in manifest['provide']:
        packs.extend(glob.glob(pattern, recursive=True))

    return packs

def install_pack(pack_path, codeql_executable, mode):
    # Run `codeql pack install` to install dependencies.
    command = [codeql_executable, 'pack', 'install', '--allow-prerelease', '--mode', mode, pack_path]
    print(f'Running `{" ".join(command)}`')
    subprocess.check_call(command)

parser = argparse.ArgumentParser(description="Install CodeQL library pack dependencies.")
parser.add_argument('--mode', required=False, choices=['use-lock', 'update', 'verify', 'no-lock'], default="use-lock", help="Installation mode, identical to the `--mode` argument to `codeql pack install`")
parser.add_argument('--codeql', required=False, default='codeql', help="Path to the `codeql` executable.")
parser.add_argument('--language', required=False, help="Which language (or 'common') to install pack dependencies for.")
args = parser.parse_args()

# Find the root of the repo
root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

packs = get_workspace_packs(root)

# Always install the qtil source pack, which is used by all languages.
install_pack(os.path.join(root, 'src'), args.codeql, args.mode)
if args.language == 'common':
  # common means we want to run test/.
  install_pack(os.path.join(root, 'test'), args.codeql, args.mode)
else:
  # Otherwise, we need to install the language-specific src and test packs.
  install_pack(os.path.join(root, args.language, 'src'), args.codeql, args.mode)
  install_pack(os.path.join(root, args.language, 'test'), args.codeql, args.mode)