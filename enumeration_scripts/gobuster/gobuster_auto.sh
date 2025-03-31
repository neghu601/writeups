#!/bin/bash

# Color codes
RED='\033[0;31m'       # Errors/Warnings
GREEN='\033[0;32m'     # Success/Completion
YELLOW='\033[0;33m'    # Default Values/Emphasis
BLUE='\033[0;34m'      # Prompts/Instructions
CYAN='\033[0;36m'      # Command Output
RESET='\033[0m'        # Reset to default color

# Banner
echo -e "${GREEN}═══════════════════════════════════════════════"
echo -e "           ${CYAN}Gobuster Automation Tool${GREEN}       "
echo -e "        ${MAGENTA}Version: 1.0${GREEN} | ${YELLOW}Author: neghu601${GREEN}"
echo -e "${GREEN}═══════════════════════════════════════════════"
echo -e "${YELLOW}         Leave blank for default values"
echo -e "${CYAN}───────────────────────────────────────────────${RESET}" 

# Prompt for target
echo -ne "${BLUE}Enter the target domain or IP:${RESET} "
read TARGET

# Check if target is empty, and if so, exit with a message
if [ -z "$TARGET" ]; then
  echo -e "${RED}Error: Target is required! Exiting...${RESET}"
  exit 1  # Exit with a non-zero status
fi

# Prompt for port (default to 80)
echo -ne "${BLUE}Enter the port (${YELLOW}default: 80${BLUE}):${RESET} "
read PORT
PORT=${PORT:-80}

# Prompt for wordlist path (with tab autocomplete)
echo -e "${BLUE}Default Wordlist:${RESET} ${YELLOW}/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt${RESET}"
echo -ne "${BLUE}Enter the path to the wordlist:${RESET} "
read -e WORDLIST
WORDLIST=${WORDLIST:-"/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"}

# Prompt for file extensions (comma-separated, e.g., php,html,txt)
echo -ne "${BLUE}Enter file extensions (comma-separated e.g. php,html,txt):${RESET} "
read EXTENSIONS

# Prompt for thread count
echo -ne "${BLUE}Enter thread count (${YELLOW}default: 10${BLUE}):${RESET} "
read THREADS
THREADS=${THREADS:-10}

# Prompt for output file name (with tab autocomplete)
echo -ne "${BLUE}Enter output file name (${YELLOW}default: gobuster_$TARGET.txt${BLUE}):${RESET} "
read -e OUTFILE
OUTFILE=${OUTFILE:-"gobuster_$(echo $TARGET | tr -d '/').txt"}

# Construct Gobuster command
CMD="gobuster dir -u http://$TARGET:$PORT -w $WORDLIST -t $THREADS"

# Add extensions if provided
if [ ! -z "$EXTENSIONS" ]; then
    CMD="$CMD -x $EXTENSIONS"
fi

# Display final command
echo -e "${CYAN}[*] Running: ${YELLOW}$CMD${RESET}"

# Run Gobuster
$CMD | tee "$OUTFILE"

# Completion message
echo -e "${GREEN}[+] Scan complete! Results saved in ${YELLOW}$OUTFILE${RESET}"
