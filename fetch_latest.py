import re
import urllib.request
import json

# https://docs.python.org/3/library/urllib.request.html#examples
# https://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html
res = urllib.request.urlopen('https://ziglang.org/download/index.json')
res_body = res.read()

# https://docs.python.org/3/library/json.html
data = json.loads(res_body.decode("utf-8"))

aarch64_macos = data["master"]["aarch64-macos"]
x86_64_macos = data["master"]["x86_64-macos"]

version_match = re.search(r"macos-aarch64-(.*?)-dev\.(.*?)\.tar\.xz",aarch64_macos["tarball"])
version = version_match.group(1)
version_hash = version_match.group(2)

content = open('Formula/zig.rb', "r", encoding="utf-8").read()
content = re.sub(
	r'version \".*?\"',
	f'version \"{version}-dev.{version_hash}\"',
    content,
    flags=re.DOTALL
)
content = re.sub(
    r'arm\?\n +url \".*?\"\n +sha256 \".*?\"',
    f'arm?\n      url \"{aarch64_macos["tarball"]}\"\n      sha256 \"{aarch64_macos["shasum"]}\"',
    content,
    flags=re.DOTALL
)
content = re.sub(
    r'intel\?\n +url \".*?\"\n +sha256 \".*?\"',
    f'intel?\n      url \"{x86_64_macos["tarball"]}\"\n      sha256 \"{x86_64_macos["shasum"]}\"',
    content,
    flags=re.DOTALL
)
open('Formula/zig.rb', 'w', encoding="utf-8").write(content)
