#LOGO_DIR="$HOME/.config/fastfetch/logo"
#/home/xander/.config/fastfetch


LOGO_DIR="$HOME/.config/fastfetch/assets"

if [ -d "$LOGO_DIR" ] && command -v kitty >/dev/null 2>&1; then
    RANDOM_LOGO=$(find "$LOGO_DIR" -type f -name "*logo*" \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1)
    if [ -n "RANDON_LOGO" ]; then
       echo "$RANDOM_LOGO"
    fi
fi
