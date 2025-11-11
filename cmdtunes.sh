CMDTUNES_ACTIVE=0
CMDTUNES_THRESHOLD=3
CMDTUNES_MUSIC_FOLDER="$HOME/Music/Music/Media.localized/Music/陈小虎/灿烂"
CMDTUNES_PID=0
CMDTUNES_HOOKS_ADDED=0

# ==========================
# Pre-exec hook (before command)
# ==========================
function cmdtunes_preexec() {
    if [[ $CMDTUNES_ACTIVE -eq 1 && $CMDTUNES_PID -gt 0 ]]; then
        cmdtunes_stop
    fi
    if [[ $CMDTUNES_ACTIVE -eq 1 ]]; then
        export CMDTUNES_START_TIME=$(date +%s)
    fi
}

# ==========================
# Precmd hook (after command)
# ==========================
function cmdtunes_precmd() {
    if [[ $CMDTUNES_ACTIVE -eq 1 ]]; then
        local end_time=$(date +%s)
        local duration=$((end_time - CMDTUNES_START_TIME))

        if (( duration >= CMDTUNES_THRESHOLD )); then
            local IFS=$'\n'
            local songs=($(find "$CMDTUNES_MUSIC_FOLDER" -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.m4v" \) -print0 | xargs -0 -n1 echo))
            unset IFS

            songs=(${songs[@]:-})
            if (( ${#songs[@]} > 0 )); then
                local song="${songs[RANDOM % ${#songs[@]}]}"
                echo "🎶 Playing: $(basename "$song") ($duration sec)"

                if [[ "$OSTYPE" == "darwin"* ]]; then
                    afplay "$song" >/dev/null 2>&1 &
                else
                    mpg123 -q "$song" >/dev/null 2>&1 &
                fi

                CMDTUNES_PID=$!
            else
                echo "⚠️ No songs found in $CMDTUNES_MUSIC_FOLDER"
            fi
        fi
    fi
}

if [[ $CMDTUNES_HOOKS_ADDED -eq 0 && -n $ZSH_VERSION ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook preexec cmdtunes_preexec
    add-zsh-hook precmd cmdtunes_precmd
    CMDTUNES_HOOKS_ADDED=1
fi


# ==========================
# Cmdtunes commands
# ==========================
function cmdtunes() {
    case "$1" in
        activate)
            cmdtunes_activate
            ;;
        deactivate)
            cmdtunes_deactivate
            ;;
        stop)
            cmdtunes_stop
            ;;
        *)
            echo "Usage: cmdtunes {activate|deactivate|stop}"
            ;;
    esac
}

function cmdtunes_activate() {
    CMDTUNES_ACTIVE=1
    echo "🎵 ~~ cmdtunes activated! ~~ 🎵"

    # Save the last prompt command
    export CMDTUNES_START_TIME=$(date +%s)
}

function cmdtunes_stop() {
    if [[ $CMDTUNES_PID -gt 0 ]]; then
        pkill afplay 2>/dev/null
        pkill mpg123 2>/dev/null
        CMDTUNES_PID=0
        echo "🛑 cmdtunes stopped."
    elif [[ $CMDTUNES_ACTIVE -eq 1 ]]; then
        echo "⚠️ no music playing."
    fi
}

function cmdtunes_deactivate() {
    CMDTUNES_ACTIVE=0
    cmdtunes_stop
    echo "~~ cmdtunes deactivated! ~~"
}