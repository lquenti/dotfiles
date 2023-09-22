# scripts when starting i3

# Keyboard layout stuff
setxkbmap us
setxkbmap -option caps:escape

# stuff
flameshot &
xscreensaver -no-splash &
/home/lquenti/code/randrem/target/release/randrem /home/lquenti/code/randrem/example.json &
owncloud &

# Toggle touch with ESC
toggle_touchpad() {
  TOUCHPAD_ID=$(xinput list | grep Touchpad | grep -o 'id=[0-9]*' | sed 's/id=//')
  ACTIVE=$(xinput list-props 11 | grep -i enabled | grep -o ".$")
  if [ $ACTIVE -eq 1 ]; then
    xinput --disable $TOUCHPAD_ID
  else
    xinput --enable $TOUCHPAD_ID
  fi
}
# TODO bind to key

# wallpaper
feh --bg-scale ~/oC/pics/wp/el-captain.webp
