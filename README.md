# CS 1.6 Server Manager — Bash Script

A simple and powerful **HLDS server control panel** written in pure **Bash**.  
Designed for VPS hosting and CS 1.6 server owners.

---

## 🚀 Features
- Start HLDS server with custom map  
- View live server console (`screen -r SERVER_NAME`)  
- Check server status (screen process, map, HLDS status)  
- Force restart (kills broken sessions && hlds_run processes)  
- Colorful UI and clean menu system  
- Safe validation && prompts before running server  
- Works on every Linux VPS

---

## 📂 File

`server_manager.sh`

Make it executable:

```bash
chmod +x server_manager.sh
```

Run it:

```bash
./server_manager.sh
```

---

## 📦 Requirements

Install screen:

```bash
sudo apt install screen -y
```

Default HLDS path:

```
~/server_files/
```

---

## ⚙️ Configuration (inside script)

```bash
SERVER_PATH="$HOME/server_files"
SERVER_NAME="SERVER_CS"
SERVER_PORT="27015"
DEFAULT_MAP="de_dust2"
```

---

## 🧭 Menu Options

1. **Start Server**  
2. **View Server Console**  
3. **Check Server Status**  
4. **Force Restart Server**  
5. **Exit Script**

---

## 📜 Social Media

Made by **PowerSiderS.X Dark (KiLiDARK)**
Subscribe On YouTube: https://www.youtube.com/@moha_kun

If you liked the script. Give it a star or fork it.
