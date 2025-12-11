#!/bin/bash

# server_manager.sh - CS 1.6 Server Management Script
# Created for VPS server management
# Server path: ~/server_files/(server files like hlds...etc)

# Color codes for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Server configuration
SERVER_PATH="$HOME/server_files" # Server Files
SERVER_NAME="SERVER_CS" # Screen Name
SERVER_PORT="27015" # Server Port
DEFAULT_MAP="de_dust2" # Default Map

# Function to display header
display_header() {
    clear
    echo -e "${PURPLE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}    ${BOLD}CS 1.6 SERVER MANAGER & VPS Control Panel${NC}"
    echo -e "${PURPLE}    v1.0 Created By PowerSiderS.X DARK (KiLiDARK)${NC}"
    echo -e "${PURPLE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}    Server Path: ${BOLD}$SERVER_PATH${NC}"
    echo -e "${PURPLE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Function to display menu
display_menu() {
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}                         MAIN MENU${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "   ${GREEN}1${NC}. ${BOLD}Start Server${NC}"
    echo -e "        Start CS 1.6 Server on port $SERVER_PORT"
    echo ""
    echo -e "   ${GREEN}2${NC}. ${BOLD}View Server Console${NC}"
    echo -e "        Connect to and view server console output"
    echo ""
    echo -e "   ${GREEN}3${NC}. ${BOLD}Check Server Status${NC}"
    echo -e "        Check if server is running and show details"
    echo ""
    echo -e "   ${GREEN}4${NC}. ${BOLD}Force Restart Server${NC}"
    echo -e "        Kill crashed server and clean up"
    echo ""
    echo -e "   ${GREEN}5${NC}. ${BOLD}Exit Script${NC}"
    echo -e "        Close this management script"
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Function to check if server is running
check_server_status() {
    if screen -list | grep -q "$SERVER_NAME"; then
        return 0  # Server is running
    else
        return 1  # Server is not running
    fi
}

# Function to get current map from running server (if any)
get_current_map() {
    if check_server_status; then
        # Try to extract map from screen session (this is tricky without accessing console)
        echo "Unknown (view console to see)"
    else
        echo "Not running"
    fi
}

# Function to show server status details
show_server_status() {
    echo -e "${YELLOW}[INFO]${NC} Checking server status..."
    
    if check_server_status; then
        echo -e "${GREEN}[STATUS]${NC} Server is ${GREEN}${BOLD}RUNNING${NC}"
        
        # Get screen session info
        SCREEN_INFO=$(screen -list | grep "$SERVER_NAME")
        echo -e "${BLUE}[DETAILS]${NC}"
        echo -e "  • Screen session: ${BOLD}$SERVER_NAME${NC}"
        echo -e "  • Screen info: $SCREEN_INFO"
        echo -e "  • Server path: ${BOLD}$SERVER_PATH${NC}"
        echo -e "  • Port: ${BOLD}$SERVER_PORT${NC}"
        echo -e "  • Current map: ${BOLD}$(get_current_map)${NC}"
        
        # Check if server process is alive
        if ps aux | grep -v grep | grep -q "hlds_run"; then
            echo -e "  • HLDS process: ${GREEN}Active${NC}"
        else
            echo -e "  • HLDS process: ${RED}Not found${NC}"
        fi
    else
        echo -e "${RED}[STATUS]${NC} Server is ${RED}${BOLD}STOPPED${NC}"
        echo -e "${YELLOW}[TIP]${NC} Use option 1 to start the server"
    fi
    
    read -p "Press Enter to continue..."
}

# Function to get map name from user
get_map_name() {
    echo ""
    echo -e "${CYAN}══════════════════ MAP SELECTION ══════════════════${NC}"
    echo -e "${YELLOW}[INFO]${NC} Enter the map name without .bsp extension"
    echo -e "${YELLOW}[EXAMPLES]${NC} de_dust2, cs_office, de_nuke, de_inferno"
    echo -e "${YELLOW}[DEFAULT]${NC} Press Enter for default: ${BOLD}$DEFAULT_MAP${NC}"
    echo ""
    
    while true; do
        echo -ne "${BOLD}Write Map Name (Without .bsp): ${NC}"
        read -r map_input
        
        # If user pressed Enter without input, use default
        if [ -z "$map_input" ]; then
            selected_map="$DEFAULT_MAP"
            echo -e "${GREEN}[SELECTED]${NC} Using default map: ${BOLD}$selected_map${NC}"
            break
        fi
        
        # Remove any .bsp if user accidentally included it
        selected_map="${map_input%.bsp}"
        
        # Validate the map name (basic check)
        if [[ "$selected_map" =~ ^[a-zA-Z0-9_]+$ ]]; then
            echo -e "${GREEN}[SELECTED]${NC} Map: ${BOLD}$selected_map${NC}"
            break
        else
            echo -e "${RED}[ERROR]${NC} Invalid map name. Use only letters, numbers, and underscores."
            echo -e "${YELLOW}[EXAMPLE]${NC} de_dust2, cs_office, aim_map"
        fi
    done
    
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo ""
}

# Function to start server
start_server() {
    echo -e "${YELLOW}[INFO]${NC} Checking if server is already running..."
    
    if check_server_status; then
        echo -e "${RED}[ERROR]${NC} Server '$SERVER_NAME' is already running!"
        echo -e "${YELLOW}[TIP]${NC} Use option 2 to view console or 4 to restart."
        read -p "Press Enter to continue..."
        return
    fi
    
    # Check if server directory exists
    if [ ! -d "$SERVER_PATH" ]; then
        echo -e "${RED}[ERROR]${NC} Server directory not found: $SERVER_PATH"
        echo -e "${YELLOW}[SOLUTION]${NC} Create the directory or check the path."
        read -p "Press Enter to continue..."
        return
    fi
    
    # Check if hlds_run exists
    if [ ! -f "$SERVER_PATH/hlds_run" ]; then
        echo -e "${RED}[ERROR]${NC} hlds_run not found in $SERVER_PATH"
        echo -e "${YELLOW}[SOLUTION]${NC} Make sure HLDS files are installed correctly."
        read -p "Press Enter to continue..."
        return
    fi
    
    # Get map name from user
    get_map_name
    
    # Show popular map suggestions
    if [ "$selected_map" = "$DEFAULT_MAP" ]; then
        echo -e "${BLUE}[POPULAR MAPS]${NC}"
        echo -e "  Classic: de_dust2, de_inferno, de_nuke, de_train"
        echo -e "  Hostage: cs_office, cs_italy, cs_mansion"
        echo -e "  Zombie: ze_paradise, ze_lotr_minas_tirith, ze_potc"
        echo ""
    fi
    
    echo -e "${GREEN}[STARTING]${NC} Launching CS 1.6 Server..."
    echo -e "${BLUE}[PATH]${NC} Working directory: $SERVER_PATH"
    echo -e "${BLUE}[MAP]${NC} Selected map: ${BOLD}$selected_map${NC}"
    echo -e "${BLUE}[COMMAND]${NC} cd $SERVER_PATH && LD_LIBRARY_PATH=bin screen -dmS $SERVER_NAME ./hlds_run -console -game cstrike +port $SERVER_PORT +map $selected_map +maxplayers 32 +pingboost 2 +sys_ticrate 1000"
    
    echo ""
    echo -e "${YELLOW}[CONFIRMATION]${NC} Do you want to start the server?"
    echo -ne "${BOLD}Start server with map '$selected_map'? [Y/n]: ${NC}"
    read -r confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]] && [[ ! -z "$confirm" ]]; then
        echo -e "${YELLOW}[CANCELLED]${NC} Server start cancelled."
        read -p "Press Enter to continue..."
        return
    fi
    
    # Navigate to server directory and execute the server start command
    echo -e "${GREEN}[LAUNCHING]${NC} Starting server..."
    cd "$SERVER_PATH" && LD_LIBRARY_PATH=bin screen -dmS "$SERVER_NAME" ./hlds_run -console -game cstrike +port $SERVER_PORT +map "$selected_map" +maxplayers 32 +pingboost 2 +sys_ticrate 1000
    
    # Check if command was successful
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERROR]${NC} Failed to start server. Check permissions and paths."
        read -p "Press Enter to continue..."
        return
    fi
    
    # Wait a moment for server to initialize
    echo -ne "${YELLOW}[WAIT]${NC} Server initializing."
    for i in {1..3}; do
        sleep 1
        echo -n "."
    done
    echo ""
    
    if check_server_status; then
        echo -e "${GREEN}[SUCCESS]${NC} Server started successfully!"
        echo -e "${YELLOW}[DETAILS]${NC}"
        echo -e "  • Screen session: ${BOLD}$SERVER_NAME${NC}"
        echo -e "  • Working directory: ${BOLD}$SERVER_PATH${NC}"
        echo -e "  • Port: ${BOLD}$SERVER_PORT${NC}"
        echo -e "  • Map: ${BOLD}$selected_map${NC}"
        echo -e "  • Max Players: ${BOLD}32${NC}"
        echo -e "  • Screen detached (running in background)"
        echo -e "${YELLOW}[TIP]${NC} Use option 2 to view server console"
        echo -e "${YELLOW}[TIP]${NC} Players can connect with: ${BOLD}connect $(hostname -I | awk '{print $1}'):$SERVER_PORT${NC}"
    else
        echo -e "${RED}[ERROR]${NC} Server screen session not found. Server might have crashed on startup."
        echo -e "${YELLOW}[DEBUG]${NC} Check server logs in $SERVER_PATH"
        echo -e "${YELLOW}[DEBUG]${NC} Try running manually: cd $SERVER_PATH && ./hlds_run -console -game cstrike +port $SERVER_PORT +map $selected_map"
    fi
    
    read -p "Press Enter to continue..."
}

# Function to view server console
view_console() {
    echo -e "${YELLOW}[INFO]${NC} Checking server status..."
    
    if ! check_server_status; then
        echo -e "${RED}[ERROR]${NC} Server '$SERVER_NAME' is not running!"
        echo -e "${YELLOW}[TIP]${NC} Use option 1 to start the server first."
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${GREEN}[CONNECTING]${NC} Attaching to server console..."
    echo -e "${BLUE}[PATH]${NC} Server directory: $SERVER_PATH"
    echo -e "${YELLOW}[INSTRUCTIONS]${NC}"
    echo -e "  • Press ${BOLD}Ctrl+A${NC} then ${BOLD}D${NC} to detach and return to menu"
    echo -e "  • Press ${BOLD}Ctrl+C${NC} to send commands to server"
    echo -e "  • Type 'quit' in server console to stop server properly"
    echo -e "  • Type 'exit' to leave server console"
    echo -e "  • Change map: ${BOLD}changelevel de_dust2${NC}"
    echo ""
    echo -e "${BLUE}═════════════════ SERVER CONSOLE (Ctrl+A+D to detach) ═════════════════${NC}"
    
    # Attach to screen session
    screen -r "$SERVER_NAME"
    
    echo ""
    echo -e "${BLUE}══════════════════════ CONSOLE DETACHED ══════════════════════${NC}"
    echo -e "${YELLOW}[INFO]${NC} Returned to management menu."
    
    # Check if server is still running after detaching
    if check_server_status; then
        echo -e "${GREEN}[STATUS]${NC} Server is still running in background."
    else
        echo -e "${RED}[STATUS]${NC} Server has stopped."
    fi
    
    read -p "Press Enter to continue..."
}

# Function to force restart server (close crashed server)
force_restart() {
    echo -e "${YELLOW}[INFO]${NC} Checking server status..."
    
    if ! check_server_status; then
        echo -e "${RED}[WARNING]${NC} Server '$SERVER_NAME' is not currently running."
    else
        echo -e "${RED}[ACTION]${NC} Force stopping server '$SERVER_NAME'..."
        
        # Get screen PID before killing
        SCREEN_PID=$(screen -list | grep "$SERVER_NAME" | awk -F'.' '{print $1}' | tr -d ' \t\n\r')
        
        # Kill the screen session
        screen -S "$SERVER_NAME" -X quit 2>/dev/null
        
        # Force kill if still running
        if [ ! -z "$SCREEN_PID" ]; then
            kill -9 "$SCREEN_PID" 2>/dev/null
        fi
        
        # Kill any remaining hlds processes
        pkill -f "hlds_run" 2>/dev/null
        
        # Kill processes in the server directory
        pkill -f "$SERVER_PATH/hlds_run" 2>/dev/null
        
        echo -e "${GREEN}[SUCCESS]${NC} Server has been terminated."
    fi
    
    # Cleanup screen sessions (remove dead ones)
    screen -wipe > /dev/null 2>&1
    
    echo ""
    echo -e "${YELLOW}[NEXT STEP]${NC} You can now start the server again using option 1."
    read -p "Press Enter to continue..."
}

# Function to display exit message
exit_script() {
    clear
    echo -e "${PURPLE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}                         SESSION SUMMARY${NC}"
    echo -e "${PURPLE}════════════════════════════════════════════════════════════════${NC}"
    
    if check_server_status; then
        echo -e "   Server Status:  ${GREEN}${BOLD}RUNNING${NC}"
        echo -e "   Screen Session: ${BOLD}$SERVER_NAME${NC}"
        echo -e "   Server Path:    ${BOLD}$SERVER_PATH${NC}"
        echo -e "   To view console: ${YELLOW}screen -r $SERVER_NAME${NC}"
        echo -e "   To stop server:  ${YELLOW}./server_manager.sh (option 4)${NC}"
    else
        echo -e "   Server Status:  ${RED}${BOLD}STOPPED${NC}"
        echo -e "   Server Path:    ${BOLD}$SERVER_PATH${NC}"
    fi
    
    echo ""
    echo -e "   ${GREEN}Thank you for using Server Manager!${NC}"
    echo -e "   ${GREEN}YouTube && GitHub -> PowerSiderS CS!${NC}"
    echo -e "   ${YELLOW}Script terminated.${NC}"
    echo -e "${PURPLE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    exit 0
}

# Main script loop
while true; do
    display_header
    display_menu
    
    # Get user choice with validation
    echo -ne "${BOLD}Select option [1-5]: ${NC}"
    read -r choice
    
    case $choice in
        1)
            start_server
            ;;
        2)
            view_console
            ;;
        3)
            show_server_status
            ;;
        4)
            force_restart
            ;;
        5)
            exit_script
            ;;
        *)
            echo -e "${RED}[ERROR]${NC} Invalid option! Please choose 1, 2, 3, 4, or 5."
            echo -e "${YELLOW}[TIP]${NC} Press Enter and try again."
            read -p "Press Enter to continue..."
            ;;
    esac
done