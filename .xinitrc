#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Notification server
/usr/bin/dunst &

# Hide the cursor after a period of inactivity.
unclutter -noevents &

# Set the default X cursor to the usual pointer.
xsetroot -cursor_name left_ptr

# Trayer
trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --width 8 --transparent true --alpha 4 --tint 0x000000 --height 30 --monitor "primary" &

# Network manager applet
nm-applet &

# Break timer
workrave &

# Emacs
/usr/bin/emacs --daemon &

# Start xmonad
exec xmonad
