#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

# Function to update system
update_system() {
    sudo apt update
    sudo apt upgrade -y
}

docker_install() {
	sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	echo "" | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt update
	sudo apt install docker-ce -y
	sudo docker --version
	sudo systemctl status docker > /dev/null
}	

docker_compose_install() {
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version
}

traceroute_install() {
	sudo apt -y install traceroute
}

net-tools_install() {
	sudo apt install -y net-tools
}

enable_firewall() {
	status=$(sudo ufw status | grep "Status: inactive")

	if [ -n "$status" ]; then
		echo -e "${GREEN}UFW is inactive. Enabling...${NC}\n"
		sudo ufw  enable
	else
		echo -e "${GREEN}UFW is already active.${NC}\n"
	fi

	echo -e "${GREEN}Adding port 22 as a rule${NC}\n"
	sudo ufw allow 22/tcp

	echo -e "${GREEN}Cheking all open ports${NC}\n"
	sudo ufw status
}



# Function to draw a square border around text
draw_square() {
    local text="$1"
    local length=${#text}

    # Print the top border
    printf "${GREEN}"
    printf "+"
    for ((i=0; i<length+4; i++)); do printf "-"; done
    printf "+\n"

    # Print the middle border and text
    printf "|  ${text}  |\n"

    # Print the bottom border
    printf "+"
    for ((i=0; i<length+4; i++)); do printf "-"; done
    printf "+\n"
    printf "${NC}\n"
}

# Main function
main() {
    draw_square "Updating the system..."
    update_system
    draw_square "Installing and enabling docker..."
    docker_install
    draw_square "Installing docker compose..."
    docker_compose_install
    draw_square "Install tracert..."
    traceroute_install
    draw_square "Installing net-tools..."
    net-tools_install
    draw_square "Enabling firewall"
    enable_firewall

}

# Call the main function
main

