#!/usr/bin/env sh
# agent-arena CLI installer. Downloads the right prebuilt `sensei` binary from the
# latest GitHub release and puts it on your PATH. Read before you run it.
#
#   curl -fsSL https://raw.githubusercontent.com/amarcu/agent-arena/main/install.sh | sh
set -eu

REPO="amarcu/agent-arena"
BINDIR="${SENSEI_BINDIR:-$HOME/.local/bin}"

os="$(uname -s)"
arch="$(uname -m)"
case "$os-$arch" in
  Darwin-arm64)  asset="sensei-macos-arm64" ;;
  Darwin-x86_64) asset="sensei-macos-x64" ;;
  Linux-x86_64)  asset="sensei-linux-x64" ;;
  Linux-aarch64) asset="sensei-linux-arm64" ;;
  *) echo "No prebuilt binary for $os-$arch. Build from source: git clone https://github.com/$REPO && cd agent-arena/engine && cargo build --release -p arena-cli" >&2; exit 1 ;;
esac

url="https://github.com/$REPO/releases/latest/download/$asset"
echo "Downloading $asset ..."
mkdir -p "$BINDIR"
if command -v curl >/dev/null 2>&1; then
  curl -fSL "$url" -o "$BINDIR/sensei"
else
  wget -qO "$BINDIR/sensei" "$url"
fi
chmod +x "$BINDIR/sensei"

echo "Installed sensei to $BINDIR/sensei"
case ":$PATH:" in
  *":$BINDIR:"*) ;;
  *) echo "Add it to your PATH:  echo 'export PATH=\"$BINDIR:\$PATH\"' >> ~/.profile && exec \$SHELL" ;;
esac
echo "Run 'sensei doctor' to check your setup."
