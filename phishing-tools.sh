#!/bin/bash

# ألوان التنسيق
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

# عرض اللوغو (ASCII Art)
show_logo() {
    echo -e "${CYAN}"
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

# التحقق من المتطلبات
check_dependencies() {
    deps=("git" "php" "cloudflared")

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo -e "${RED}[!] الأداة $dep غير مثبتة!${RESET}"
            case $dep in
                cloudflared)
                    echo -e "${GREEN}[*] تحميل Cloudflare Tunnel...${RESET}"
                    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
                    chmod +x cloudflared && sudo mv cloudflared /usr/local/bin/
                    ;;


            esac
        fi
    done
}

# تشغيل الأدوات مع اختيار البورت
run_tool() {
    echo -ne "${CYAN}[?] أدخل البورت الذي تريد استخدامه: ${RESET}"
    read -r port

    case $1 in
        1)
            echo -e "${CYAN}[+] تشغيل zphisher على البورت ...${RESET}"
            cd zphisher || { echo -e "${RED}[!] المجلد غير موجود!${RESET}"; exit 1; }
            bash zphisher.sh
            ;;
        2)
            echo -e "${CYAN}[+] تشغيل camphish على البورت ...${RESET}"
            cd CamPhish || { echo -e "${RED}[!] المجلد غير موجود!${RESET}"; exit 1; }
            bash camphish.sh
            ;;
        3)
            sudo wifiphisher
            ;;
        4)
            echo -e "${CYAN}[+] تشغيل Cloudflare Tunnel على البورت $port...${RESET}"
            cloudflared tunnel --url "http://localhost:$port"
            ;;
        5)
            echo -e "${GREEN}[+] الخروج.${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}[!] اختيار غير صالح!${RESET}"
            ;;
    esac
}

# القائمة الرئيسية
main_menu() {
    show_logo
    check_dependencies

    while true; do
        echo -e "${BLUE}=====================================${RESET}"
        echo -e "${GREEN}   أداة الدمج: zphisher, camphish, wififishing, cloudflare${RESET}"
        echo -e "${BLUE}=====================================${RESET}"
        echo -e "${CYAN}[1] تشغيل zphisher${RESET}"
        echo -e "${CYAN}[2] تشغيل camphish${RESET}"
        echo -e "${CYAN}[3] تشغيل wififishing${RESET}"
        echo -e "${CYAN}[4] تشغيل Cloudflare Tunnel فقط${RESET}"
        echo -e "${CYAN}[5] خروج${RESET}"
        echo -ne "${GREEN}[*] اختر رقم الأداة: ${RESET}"
        read -r choice
        run_tool "$choice"
    done
}

# تشغيل القائمة
main_menu
# شد حيلك هاذي ادوات مالها فايدة اذا ماعرفت كيف تشتغل من الصفر ياوحش
