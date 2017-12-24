# change shell
# chsh -s /bin/zsh

# Unityconfigureshit
# related https://askubuntu.com/questions/879104/determine-current-keyboard-shortcuts-in-gnome-terminal-using-gsettings
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 3
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 3

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Down']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Left']"

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Shift>Up']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Super><Shift>Right']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Shift>Down']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Super><Shift>Left']"
# ITS NOWHERE DOCUMENTED HOW TO CHANGE THE UNITY BAR SIZE FUCKING GCONF
