# 🎨 Design Your SSH Banner ✨

Add style and fun to your SSH login with cows, colors, and quotes!

---

## 🐄 What is This?

Tired of boring SSH logins? Spice up your terminal with a **random ASCII cow**, **a witty fortune**, and **a rainbow of colors** every time you connect via SSH!

This mini-project uses:

* 🧠 `fortune` for random quotes
* 🐮 `cowsay` for fun ASCII animals
* 🌈 `lolcat` for colorful output

---

## Installation & Setup

#### 1. Install Required Packages

```bash
sudo apt install cowsay fortune lolcat -y
```

---

#### 2. Create the Banner Script

```bash
sudo nano /etc/ssh/ssh-banner.sh
```

##### Paste this content:

```bash
#!/bin/bash

# Path to cowsay cowfiles (may vary by distro)
COWPATH="/usr/share/cowsay/cows"

# Pick a random .cow file
COWFILE=$(ls "$COWPATH" | shuf -n1)

# Generate the banner
fortune | cowsay -f "${COWFILE%.*}" | lolcat
```

---

#### 3. Make the Script Executable

```bash
sudo chmod +x /etc/ssh/ssh-banner.sh
```

---

#### 4. Trigger the Banner on SSH Login

Open your Bash config:

```bash
nano ~/.bashrc
```

Add this to the end:

```bash
if [ -n "$SSH_CONNECTION" ]; then
    /etc/ssh/ssh-banner.sh
fi
```

---

#### 5. Reload Bash Configuration

```bash
source ~/.bashrc
```

Or just disconnect and SSH back in!

---

## Demo Output

```bash
 _______________________________________
/ There is no reason anyone would want  \
| a computer in their home.            |
| -- Ken Olson, President, Chairman    |
\ and Founder of Digital Equipment Corp/
 ---------------------------------------
         \   ^__^
          \  (oo)\_______
             (__)\       )\/\
                 ||----w |
                 ||     ||
```

*(now with rainbow colors thanks to `lolcat`!)*

---

## Customize Your Banner

* Use specific cows: `cowsay -f tux`, `cowsay -f dragon`
* Use your own quotes: `echo "Hello, hacker!" | cowsay | lolcat`
* Make your own `.cow` file and add it to `/usr/share/cowsay/cows/`

---

## To Remove 🧼

Just delete the `.bashrc` entry and/or remove the script:

```bash
sudo rm /etc/ssh/ssh-banner.sh
```