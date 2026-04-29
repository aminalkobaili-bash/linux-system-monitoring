#!/bin/bash

get_font_color() {
    case $1 in
        1) echo 37 ;; # white
        2) echo 31 ;; # red
        3) echo 32 ;; # green
        4) echo 34 ;; # blue
        5) echo 35 ;; # purple
        6) echo 30 ;; # black
    esac
}

get_bg_color() {
    case $1 in
        1) echo 47 ;; # white
        2) echo 41 ;; # red
        3) echo 42 ;; # green
        4) echo 44 ;; # blue
        5) echo 45 ;; # purple
        6) echo 40 ;; # black
    esac
}