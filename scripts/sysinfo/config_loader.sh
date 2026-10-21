#!/bin/bash

CONFIG_FILE="config.conf"

DEFAULT_COLUMN1_BG=6
DEFAULT_COLUMN1_FG=1
DEFAULT_COLUMN2_BG=2
DEFAULT_COLUMN2_FG=4

load_config() {

    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi

    column1_background=${column1_background:-$DEFAULT_COLUMN1_BG}
    column1_font_color=${column1_font_color:-$DEFAULT_COLUMN1_FG}
    column2_background=${column2_background:-$DEFAULT_COLUMN2_BG}
    column2_font_color=${column2_font_color:-$DEFAULT_COLUMN2_FG}
}