#!/bin/bash

# Get available windows
#windows=$(swaymsg -t get_tree | jq -r '.nodes[1].nodes[].nodes[] | .. | (.id|tostring) + " " + .name?' | grep -e "[0-9]* ."  )

windows=$(swaymsg -t get_tree | jq -r '
	recurse(.nodes[]?) |
		recurse(.floating_nodes[]?) |
		select(.type=="con"), select(.type=="floating_con") |
			(.id | tostring) + " " + .app_id + ": " + .name')


# Select window with rofi
selected=$(echo "$windows" | rofi -dmenu -i -p "Switch to:" | awk '{print $1}')

# Tell sway to focus said window
swaymsg [con_id="$selected"] focus
