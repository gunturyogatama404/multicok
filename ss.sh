#!/bin/bash

# Warna untuk output
RED='\033[0;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No color

print_banner() {
  clear
  echo -e """
    ____                       
   / __ \\____ __________ ______
  / / / / __ \`/ ___/ __ \`/ ___/
 / /_/ / /_/ (__  ) /_/ / /    
/_____/_\\__,_/____/\\__,_/_/      

    ____                       __
   / __ \\___  ____ ___  __  __/ /_  ______  ____ _
  / /_/ / _ \\/ __ \`__ \\/ / / / / / / / __ \\/ __ \`/
 / ____/  __/ / / / / / /_/ / / /_/ / / / / /_/ / 
/_/    \\___/_/ /_/ /_/\\__,_/_/\\__,_/_/ /_/\\__, /  
                                         /____/    

====================================================
     Automation         : Auto Install Node 
     Telegram Channel   : @dasarpemulung
     Telegram Group     : @parapemulung
====================================================
"""
}
# Cetak banner
print_banner
sleep 5

# Memeriksa arsitektur sistem
echo -e "${YELLOW}🖥️ Memeriksa arsitektur sistem...${NC}"
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
elif [[ "$ARCH" == "aarch64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
else
    echo -e "${RED}❌ Arsitektur sistem tidak didukung: $ARCH${NC}"
    exit 1
fi
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Mengunduh client
echo -e "${YELLOW}🔽 Mengunduh client dari $CLIENT_URL...${NC}"
wget $CLIENT_URL -O multipleforlinux.tar
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Mengekstrak file
echo -e "${YELLOW}📦 Mengekstrak file...${NC}"
tar -xvf multipleforlinux.tar
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Berpindah ke direktori hasil ekstraksi
cd multipleforlinux || { echo -e "${RED}❌ Ekstraksi gagal. Direktori tidak ditemukan.${NC}"; exit 1; }
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Mengatur izin eksekusi
echo -e "${YELLOW}🔧 Mengatur izin eksekusi...${NC}"
chmod +x ./multiple-cli
chmod +x ./multiple-node
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Menambahkan PATH lokal ke profile user
echo -e "${YELLOW}⚙️ Menambahkan direktori ke PATH...${NC}"
echo "PATH=\$PATH:$(pwd)" >> ~/.bash_profile
source ~/.bash_profile
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Mengatur izin penuh untuk direktori kerja
echo -e "${YELLOW}🔧 Mengatur izin penuh untuk direktori kerja...${NC}"
chmod -R 777 $(pwd)
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Menyiapkan folder log
echo -e "${YELLOW}📂 Menyiapkan folder log...${NC}"
if [ ! -d "logs" ]; then
    mkdir logs
fi
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Menjalankan multiple-node
echo -e "${YELLOW}🚀 Menjalankan multiple-node...${NC}"
nohup ./multiple-node > logs/output.log 2>&1 &
sleep 3
NODE_PID=$(pgrep -f multiple-node)
if [[ -n "$NODE_PID" ]]; then
    echo -e "${LIGHT_GREEN}✅ multiple-node berjalan dengan PID: $NODE_PID.${NC}"
else
    echo -e "${RED}❌ multiple-node tidak berjalan. Periksa logs untuk detail.${NC}"
    exit 1
fi

# Membaca nilai dari config.json
IDENTIFIER="MC61A72Y"
STORAGE="2000"
PIN="030302"
DOWNLOAD="200"
UPLOAD="200"
# Validasi input dari config.json
if [[ -z "$IDENTIFIER" || -z "$PIN" ]]; then
    echo -e "${RED}❌ ERROR: Account ID dan PIN tidak boleh kosong.${NC}"
    exit 1
fi

# Melakukan binding account
echo -e "${YELLOW}🔗 Mengikat akun dengan ID dan PIN...${NC}"
./multiple-cli bind --bandwidth-download 200 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 200
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"

# Menyelesaikan instalasi
echo -e "${CYAN}======================================${NC}"
echo -e "${LIGHT_GREEN}✅ Instalasi selesai!${NC}"
echo -e "${CYAN}Telegram Channel: https://t.me/dasarpemulung${NC}"
echo -e "${CYAN}======================================${NC}"
