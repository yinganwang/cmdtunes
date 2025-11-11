# cmd-tunes

🎵 **cmd-tunes** is a lightweight command-line music player for your terminal.  
It automatically plays a random song from a specified folder if your terminal command runs longer than a set threshold. Stop the music, deactivate, or activate it anytime with simple commands.

---

## Features

- Automatically plays music after long-running terminal commands.
- Supports `.mp3`, `.wav`, and `.m4v` files.
- Works on macOS (`afplay`) and Linux (`mpg123`).
- Simple commands to activate, deactivate, or stop music.
- Hooks into Zsh for automatic pre-command and post-command behavior.

---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yinganwang/cmd-tunes.git
cd cmd-tunes
```

2. Source the script in your terminal (add this to your `~/.zshrc` for persistence):

```bash
source /path/to/cmdtunes.sh
```

## Usage

Activate cmd-tunes:

```bash
cmdtunes activate
```

Deactivate cmd-tunes:

```bash
cmdtunes deactivate
```

Stop currently playing music:

```bash
cmdtunes stop
```

Once activated, any terminal command that runs longer than the threshold (default 3 seconds) will trigger a random song from your music folder.

## Configuration

Edit the top of `cmdtunes.sh` to configure:

```bash
CMDTUNES_THRESHOLD=3                        # Minimum command duration (seconds) to trigger music
CMDTUNES_MUSIC_FOLDER="$HOME/Music/灿烂"   # Folder to pick songs from
```

## MIT License
