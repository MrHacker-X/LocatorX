#!/bin/bash
# By MrHacker-X
# github.com/MrHacker-X/LocatorX
#
# Auto-detects the system: Termux and Linux are supported.
# Any other system (macOS, Windows, BSD, ...) prints a fallback message and exits.
# Optional: force a mode with `bash install.sh termux` or `bash install.sh linux`.

set -u

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$HOME/.locatorx"
SUDO=""

# ---------- colors (disabled when not a terminal or NO_COLOR is set) ----------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    RD=$'\e[31m'; GR=$'\e[32m'; YL=$'\e[33m'; CY=$'\e[36m'; BW=$'\e[1m'; DM=$'\e[2m'; XX=$'\e[0m'
else
    RD=""; GR=""; YL=""; CY=""; BW=""; DM=""; XX=""
fi

info() { printf '%s[*]%s %s\n' "$CY" "$XX" "$1"; }
ok()   { printf '%s[+]%s %s\n' "$GR" "$XX" "$1"; }
warn() { printf '%s[!]%s %s\n' "$YL" "$XX" "$1"; }
err()  { printf '%s[x]%s %s\n' "$RD" "$XX" "$1" >&2; }
fail() { err "$1"; exit 1; }

# ---------- privilege helper (Linux only needs this) ----------
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
fi

# ---------- system detection ----------
detect_system() {
    # Termux sets TERMUX_VERSION and lives under /data/data/com.termux
    if [ -n "${TERMUX_VERSION:-}" ] || case "$HOME" in /data/data/com.termux*) true;; *) false;; esac; then
        echo "termux"
        return
    fi

    case "$(uname -s)" in
        Linux*)               echo "linux" ;;
        Darwin*)              echo "darwin" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)                    echo "unknown" ;;
    esac
}

SYSTEM="${1:-}"
if [ -z "$SYSTEM" ]; then
    SYSTEM="$(detect_system)"
fi
SYSTEM="$(printf '%s' "$SYSTEM" | tr '[:upper:]' '[:lower:]')"

echo
case "$SYSTEM" in
    termux)
        ok "Termux detected."
        ;;
    linux)
        ok "Linux detected."
        ;;
    darwin|windows|unknown|*)
        err "LocatorX is not available for this system."
        warn "Supported systems: Termux and Linux only."
        echo
        exit 1
        ;;
esac
echo

# ---------- Python installation ----------

install_python_termux() {
    command -v python3 >/dev/null 2>&1 && return 0
    info "Installing Python..."
    pkg install -y python || fail "Python install failed."
    command -v python3 >/dev/null 2>&1 || fail "Python still missing."
}

install_python_linux() {
    command -v python3 >/dev/null 2>&1 && return 0
    warn "python3 not found. Installing..."

    if [ -z "$SUDO" ] && [ "$(id -u)" -ne 0 ]; then
        err "Installing python3 requires root privileges."
        warn "Install python3 manually (e.g. 'sudo apt install python3'), then re-run this installer."
        exit 1
    fi

    if command -v apt-get >/dev/null 2>&1; then
        $SUDO apt-get update -y || true
        $SUDO apt-get install -y python3
    elif command -v dnf >/dev/null 2>&1; then
        $SUDO dnf install -y python3
    elif command -v yum >/dev/null 2>&1; then
        $SUDO yum install -y python3
    elif command -v pacman >/dev/null 2>&1; then
        $SUDO pacman -S --noconfirm python
    elif command -v zypper >/dev/null 2>&1; then
        $SUDO zypper --non-interactive install python3
    else
        err "No supported package manager found (apt/dnf/yum/pacman/zypper)."
        warn "Install python3 manually, then re-run this installer."
        exit 1
    fi

    command -v python3 >/dev/null 2>&1 || fail "Python install failed."
}

# ---------- file installation ----------

install_files() {
    info "Installing files..."

    # Candidate bin dir (refined below per system); needed before the wipe check
    BIN_DIR="${PREFIX:-/usr/local/bin}"

    # Fresh install: silently clear any previous installation.
    # Removal goes through $SUDO because old copies may be root-owned.
    [ -d "$APP_DIR" ] && rm -rf "$APP_DIR"
    if [ -f "$BIN_DIR/locatorx" ] || [ -f "$HOME/.local/bin/locatorx" ]; then
        $SUDO rm -f "$BIN_DIR/locatorx" "$HOME/.local/bin/locatorx" 2>/dev/null
    fi

    mkdir -p "$APP_DIR/web" || fail "Cannot create $APP_DIR/web"

    cp "$REPO_DIR/core/index.html" "$APP_DIR/web/index.html" \
        || fail "Failed to copy index.html"

    if [ "$SYSTEM" = "termux" ]; then
        if [ -z "${PREFIX:-}" ]; then
            err "PREFIX is not set — are you really running inside Termux?"
            exit 1
        fi
        BIN_DIR="$PREFIX/bin"
        cp "$REPO_DIR/core/locatorx" "$BIN_DIR/locatorx" \
            || fail "Failed to copy locatorx to $BIN_DIR"
        chmod +x "$BIN_DIR/locatorx"
    else
        if [ -w /usr/local/bin ]; then
            BIN_DIR="/usr/local/bin"
            cp "$REPO_DIR/core/locatorx" "$BIN_DIR/locatorx" \
                || fail "Failed to copy locatorx to $BIN_DIR"
            chmod +x "$BIN_DIR/locatorx"
        elif [ -n "$SUDO" ]; then
            BIN_DIR="/usr/local/bin"
            if ! $SUDO cp "$REPO_DIR/core/locatorx" "$BIN_DIR/locatorx" 2>/dev/null; then
                warn "Could not write to $BIN_DIR (permission denied)."
                info "Falling back to user install in ~/.local/bin ..."
                BIN_DIR="$HOME/.local/bin"
                mkdir -p "$BIN_DIR"
                cp "$REPO_DIR/core/locatorx" "$BIN_DIR/locatorx" \
                    || fail "Failed to copy locatorx to $BIN_DIR"
                chmod +x "$BIN_DIR/locatorx"
                case ":$PATH:" in
                    *":$BIN_DIR:"*) ;;
                    *)
                        warn "$BIN_DIR is not in your PATH."
                        info "Add it:  ${BW}echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc && source ~/.bashrc${XX}"
                        ;;
                esac
            else
                $SUDO chmod +x "$BIN_DIR/locatorx"
            fi
        else
            # No root and no sudo: install to the user's local bin instead
            BIN_DIR="$HOME/.local/bin"
            mkdir -p "$BIN_DIR"
            cp "$REPO_DIR/core/locatorx" "$BIN_DIR/locatorx" \
                || fail "Failed to copy locatorx to $BIN_DIR"
            chmod +x "$BIN_DIR/locatorx"
            case ":$PATH:" in
                *":$BIN_DIR:"*) ;;
                *)
                    warn "$BIN_DIR is not in your PATH."
                    info "Add it:  ${BW}echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc && source ~/.bashrc${XX}"
                    ;;
            esac
        fi
    fi
}

# ---------- run ----------

if [ "$SYSTEM" = "termux" ]; then
    install_python_termux
else
    install_python_linux
fi

install_files

echo
echo "${RD}<========================================>${XX}"
echo "${GR}  LocatorX installed successfully${XX}"
echo "${BW}  Usage: locatorx [start|stop|status]${XX}"
echo "${RD}<========================================>${XX}"
echo "${DM}          Created by: MrHacker-X${XX}"
echo "${RD}<========================================>${XX}"
echo
