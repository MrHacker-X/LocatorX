<div align="center">

<img src="https://i.ibb.co/KLwZHHy/ic2.png" width="150" alt="LocatorX logo">

# ⃤ &nbsp;L O C A T O R X&nbsp; ⃤

### *⚡ Trace any IP. See everything. In style.*

<br>

<img src="https://img.shields.io/github/stars/MrHacker-X/LocatorX?style=for-the-badge&color=orange">
<img src="https://img.shields.io/github/forks/MrHacker-X/LocatorX?style=for-the-badge&color=purple">
<img src="https://img.shields.io/github/issues/MrHacker-X/LocatorX?style=for-the-badge&color=red">
<img src="https://img.shields.io/github/license/MrHacker-X/LocatorX?style=for-the-badge&color=blue">

<br>

![Platform](https://img.shields.io/badge/Platform-Termux%20%7C%20Linux-2ea44f?style=flat-square&logo=linux&logoColor=white)
![Runtime](https://img.shields.io/badge/Runtime-python%203-3776AB?style=flat-square&logo=python&logoColor=white)
![Dependencies](https://img.shields.io/badge/Dependencies-NONE-success?style=flat-square)
![UI](https://img.shields.io/badge/UI-Neon%20Terminal-red?style=flat-square)
![Data](https://img.shields.io/badge/Data-ip--api.com-8A2BE2?style=flat-square)

[Features](#-features) · [Install](#-installation) · [Usage](#-usage) · [Smart Ports](#-smart-ports) · [Tech Stack](#-tech-stack)

</div>

---

## 🎯 Why LocatorX?

> Paste an IP. Get **everything** - location, ISP, ASN, security flags, timezone,
> currency - on a glowing neon dashboard with a live map.
>
> **No PHP. No Node. No build step.** If your machine has `python3`,
> you already have everything LocatorX needs.

## 🖼 Preview

<div align="center">

![LocatorX dashboard](https://i.ibb.co/XRNBx6W/Screenshot-From-2026-09-28-22-48-34.png)

*Matrix rain · result cards · security badges · live Google Map*

</div>

---

## 🚀 Quick Start

```bash
git clone https://github.com/MrHacker-X/LocatorX.git
cd LocatorX
bash install.sh        # auto-detects Termux or Linux - zero questions
locatorx start         # server up + browser opens automatically 🎉
```

<div align="center">

**…that's the whole tutorial.**

</div>

---

## 📦 Installation

The installer **auto-detects your system**. No prompts, no config files.

| Your System | Status | Package Manager |
|---|:---:|---|
| 🤖 **Termux** (Android) | ✅ Supported | `pkg` |
| 🐧 **Linux** (Debian / Arch / Fedora / openSUSE) | ✅ Supported | `apt` `dnf` `yum` `pacman` `zypper` |
| 🍎 macOS / 🪟 Windows / BSD | ❌ Refused | - installer exits with a clear message |

<details>
<summary><b>🤖 Termux - step by step</b></summary>

```bash
apt install git -y
git clone https://github.com/MrHacker-X/LocatorX.git
cd LocatorX
bash install.sh            # or: bash install.sh termux
```

</details>

<details>
<summary><b>🐧 Linux - step by step</b></summary>

```bash
git clone https://github.com/MrHacker-X/LocatorX.git
cd LocatorX
bash install.sh            # or: bash install.sh linux
```

</details>

<details>
<summary><b>🔍 What the installer actually does</b></summary>

- Installs **python3** if it's missing (via your system's package manager)
- Copies the dashboard into `~/.locatorx/`
- Places the `locatorx` command in `/usr/local/bin`
  - or `~/.local/bin` with a PATH hint if system-wide isn't permitted
- Always performs a **fresh install**: old files are wiped first

</details>

---

## 🎮 Usage

| Command | What it does |
|---|---|
| `locatorx start` | 🚀 Starts the server **and opens your browser** |
| `locatorx status` | 👀 Shows the running server + its URL |
| `locatorx stop` | 🛑 Stops the server |

**A real session:**

```txt
┌──(alex㉿vritrasec)-[~/Desktop/temp-dir/LocatorX]
└─$ locatorx start  

[+] LocatorX Server started on port 31415.
[-] URL: http://127.0.0.1:31415
[-] Opening browser...
[-] Stop it with: locatorx stop
                                                                                
┌──(alex㉿vritrasec)-[~/Desktop/temp-dir/LocatorX]
└─$ locatorx status

[+] LocatorX server is running.
[-] URL: http://127.0.0.1:31415
                                                                                
┌──(alex㉿vritrasec)-[~/Desktop/temp-dir/LocatorX]
└─$ locatorx stop  

[+] Server stopped.
                                                                                
┌──(alex㉿vritrasec)-[~/Desktop/temp-dir/LocatorX]
└─$ 

```

Once it's open:

1. 🎯 Type the target IP and hit **Trace**
2. 📊 Read the full report - every value is **click-to-copy**
3. 🗺 Scroll for the live map, or hit **Open in Google Maps**
4. ⬇ Export the whole report as **JSON** with one click

---

## ✨ Features

| | Feature | What you get |
|:---:|---|---|
| 🌍 | **Full Geolocation** | Continent, country, region, city, district, ZIP, lat/lon |
| 🏢 | **Network Intel** | ISP, organization, AS number, AS name, reverse DNS |
| 🛡 | **Security Badges** | Instant `PROXY` `HOSTING` `MOBILE` `CLEAN` flags |
| 💰 | **Extras** | Currency, timezone + UTC offset |
| 🗺 | **Live Map** | Embedded Google Map with approximate location |
| 🖥 | **Neon Terminal UI** | Matrix rain, scanlines, cards, country flag |
| 📋 | **Copy & Export** | Click any value to copy · full report as `.json` |
| 🕘 | **Trace History** | Last 8 lookups saved locally - one click to re-trace |
| 🔌 | **Zero Dependencies** | Stock `python3` only - no PHP, no npm, no CDN calls |

---

## 🔌 Smart Ports

LocatorX **never fights for common dev ports** (`3000` / `5000` / `8000` / `8080`...).
Every start picks a **random free port** from its own dedicated pool:

<div align="center">

`27182` · `31415` · `16180` · `14142` · `57721`

</div>

- ✅ Ports already owned by another tool are **skipped automatically**
- ✅ Already running? `locatorx start` just **re-opens the existing server** in your browser
- ✅ `stop` / `status` scan the pool and **only touch servers that actually serve LocatorX** -
  another tool's process on a pool port is never harmed

---

## 🧰 Tech Stack

| Layer | Tech |
|---|---|
| 🖥 Server | `python3 -m http.server` - loopback only (`127.0.0.1`) |
| 🎨 Frontend | One self-contained `index.html` - vanilla HTML/CSS/JS |
| 📡 Data | [ip-api.com](http://ip-api.com) · Google Maps embed · flagcdn |
| ⚙️ Control & Install | Pure bash, colored CLI output |

---

## ⚠️ Disclaimer

> LocatorX is provided for **educational and informational purposes only**.
> The developers are not responsible for any misuse or illegal activities
> conducted using this tool. Use it responsibly and ensure you have the
> necessary permissions before tracing any IP address.

## 🤝 Contributing

Found a bug? Have a wild idea? Open an [issue](https://github.com/MrHacker-X/LocatorX/issues)
or fire off a pull request - contributions are always welcome.

## 📜 License

Released under the [Boost Software License 1.0](https://github.com/MrHacker-X/LocatorX/blob/main/LICENSE).

---

<div align="center">

**⃤ LocatorX** - crafted with 🔴⚫ by **[MrHacker-X](https://github.com/MrHacker-X)**

[![GitHub](https://img.shields.io/badge/GitHub-MrHacker--X-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/MrHacker-X)

⭐ **Found it useful? Star the repo - it helps more than you know.** ⭐

</div>
