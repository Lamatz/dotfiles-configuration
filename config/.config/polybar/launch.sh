#!/usr/bin/env bash

# --- Polybar Launch Script ---
# This script terminates existing Polybar instances and then
# launches a new one for each connected monitor.

# 1. Terminate already running bar instances
#    `killall -q polybar` sends a SIGTERM signal to all running polybar processes.
killall -q polybar

# 2. Wait until the processes have been shut down
#    `pgrep -u $UID -x polybar` checks if any polybar processes for the current user ($UID)
#    are still running. `sleep 1` pauses for 1 second before checking again.
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 3. Define the directory where your Polybar config files are
#    This makes it easy to reference your config.ini
DIR="$HOME/.config/polybar"
CONFIG="$DIR/config.ini" # The main config file the script will use

# 4. Check if the config file exists
if [ ! -f "$CONFIG" ]; then
    echo "Error: Polybar config file not found at $CONFIG"
    echo "Please create or copy an example config to this location."
    echo "Polybar will not launch."
    exit 1
fi

# 5. Launch Polybar on each connected monitor
#    `xrandr --query` lists all connected monitors.
#    `grep " connected"` filters for only active monitors.
#    `awk '{print $1}'` extracts just the monitor name (e.g., "eDP-1", "HDMI-A-0").
#    The `for m in ...` loop iterates over each connected monitor.
#    `MONITOR=$m polybar -q main -c "$CONFIG" &` launches a new polybar instance.
#       - `MONITOR=$m`: This exports the current monitor name as an environment variable
#         that Polybar can use (e.g., in `[bar/main]` you can use `monitor = ${env:MONITOR}`).
#       - `-q`: Suppress warnings (optional, remove for verbose output).
#       - `main`: This is the *name* of the bar as defined in your `config.ini` (e.g., `[bar/main]`).
#       - `-c "$CONFIG"`: Specifies the path to your Polybar configuration file.
#       - `&`: Runs the command in the background, so the script can finish.
if type "xrandr" > /dev/null; then
  for m in $(xrandr --query | grep " connected" | awk '{print $1}'); do
    MONITOR=$m polybar -q main -c "$CONFIG" &
  done
else
  # Fallback for systems without xrandr or if xrandr doesn't find connected displays.
  # This typically launches a single bar without explicit monitor assignment.
  polybar -q main -c "$CONFIG" &
fi

echo "Polybar launched!"
