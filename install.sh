#!/bin/bash

# --- Terminal Colors ---
RED="\e[31m"
WHITE="\e[37m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# --- Helper Functions ---
log_info() { echo -e "${WHITE}[INFO] ${1}${RESET}"; }
log_success() { echo -e "${GREEN}[SUCCESS] ${1}${RESET}"; }
log_warning() { echo -e "${YELLOW}[WARNING] ${1}${RESET}"; }
log_error() { echo -e "${RED}[ERROR] ${1}${RESET}"; }

draw_line() {
  local char=${1:-"-"}
  local width=$(tput cols || echo 80)
  printf "${RED}%*s${RESET}\n" "${width}" " " | tr ' ' "${char}"
}

center_text() {
  local text="$1"
  local width=$(tput cols || echo 80)
  printf "${WHITE}%*s${RESET}\n" "$((${#text} + width)) / 2))" "${text}"
}

# --- Main Installation Script ---

clear
draw_line "="
center_text "rubyental Installation Script"
draw_line "="

log_info "Starting rubyental installation..."

# 1. Check for Ruby
log_info "Checking for Ruby installation..."
if ! command -v ruby &> /dev/null
then
    log_error "Ruby is not installed. Please install Ruby to run rubyental."
    log_info "You can download Ruby from https://www.ruby-lang.org/en/downloads/"
    exit 1
fi
log_success "Ruby found."

# 2. Define installation path
INSTALL_DIR="$HOME/.local/bin"
APP_SOURCE="$(dirname "$0")/rubyental_app.rb"
APP_NAME="rubyental"
INSTALL_PATH="$INSTALL_DIR/$APP_NAME"

# 3. Create installation directory if it doesn't exist
log_info "Checking if $INSTALL_DIR exists..."
if [ ! -d "$INSTALL_DIR" ]; then
    log_info "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
    if [ $? -ne 0 ]; then
        log_error "Failed to create $INSTALL_DIR. Aborting."
        exit 1
    fi
    log_success "Directory created."
else
    log_success "$INSTALL_DIR already exists."
fi

# 4. Copy the application script
log_info "Copying rubyental_app.rb to $INSTALL_PATH..."
cp "$APP_SOURCE" "$INSTALL_PATH"
if [ $? -ne 0 ]; then
    log_error "Failed to copy rubyental_app.rb. Aborting."
    exit 1
fi
log_success "Application copied."

# 5. Make the script executable
log_info "Making $APP_NAME executable..."
chmod +x "$INSTALL_PATH"
if [ $? -ne 0 ]; then
    log_error "Failed to make $APP_NAME executable. Aborting."
    exit 1
fi
log_success "Application is executable."

# 6. Check and advise on PATH
log_info "Checking PATH..."
if [[ ":$PATH:" != ":$INSTALL_DIR:" ]]
then
    log_warning "$INSTALL_DIR is not in your PATH."
    log_info "To run 'rubyental' from anywhere, you need to add the following to your shell's configuration file (e.g., ~/.bashrc, ~/.zshrc):"
    echo -e "${WHITE}    export PATH=\"$HOME/.local/bin:\$PATH\"${RESET}"
    log_info "Then, restart your terminal or run 'source ~/.bashrc' (or your respective config file)."
else
    log_success "$INSTALL_DIR is already in your PATH."
fi

draw_line "="
center_text "Installation Complete!"
draw_line "="
log_info "You can now run 'rubyental' from any directory (after refreshing your shell if needed)."
log_info "Thank you for installing rubyental!"

exit 0
