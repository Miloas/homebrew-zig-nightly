import re
import urllib.request
import json

res = urllib.request.urlopen('https://ziglang.org/download/index.json')
res_body = res.read()

data = json.loads(res_body.decode("utf-8"))

aarch64_macos = data["master"]["aarch64-macos"]
x86_64_macos = data["master"]["x86_64-macos"]

# Extrai informações para Linux
aarch64_linux = data["master"]["aarch64-linux"]
x86_64_linux = data["master"]["x86_64-linux"]


sha = data["master"]["src"]["shasum"][:9]
version_hash = sha

content = open('Formula/zig.rb', "r", encoding="utf-8").read()

content = re.sub(
    r'version \".*?\"',
    f'version \"{version}.{version_hash}\"',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'arm\?\n +url \".*?macos.*?\"\n +sha256 \".*?\"',
    f'arm?\n      url \"{aarch64_macos["tarball"]}\"\n      sha256 \"{aarch64_macos["shasum"]}\"',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'intel\?\n +url \".*?macos.*?\"\n +sha256 \".*?\"',
    f'intel?\n      url \"{x86_64_macos["tarball"]}\"\n      sha256 \"{x86_64_macos["shasum"]}\"',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'arm\? #Linux arm\n +url \".*?linux.*?\"\n +sha256 \".*?\"',
    f'arm? #Linux arm\n      url \"{aarch64_linux["tarball"]}\"\n      sha256 \"{aarch64_linux["shasum"]}\"',
    content,
    flags=re.DOTALL
)

print(content)

content = re.sub(
    r'intel\? #Linux intel\n +url \".*?linux.*?\"\n +sha256 \".*?\"',
    f'intel? #Linux intel\n      url \"{x86_64_linux["tarball"]}\"\n      sha256 \"{x86_64_linux["shasum"]}\"',
    content,
    flags=re.DOTALL
)

open('Formula/zig.rb', 'w', encoding="utf-8").write(content)
