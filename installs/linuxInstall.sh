#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo -e "❌ \e[31mError:\e[0m No ejecutes este script como root ni con sudo. Ejecuta como usuario normal."
    exit 1
fi
# 📦 instalar unzip
echo "🔄 Actualizando sistema..."
sudo apt update -y && sudo apt upgrade -y
sudo apt autoremove -y

# verifica si unzip está instalado
if command -v unzip &> /dev/null
then
    echo "✅ unzip ya está instalado."
else
    echo "📦 unzip no está instalado, instalando..."
    sudo apt install -y unzip
fi

echo "🎨 Instalando Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin

LINE='eval "$(/usr/local/bin/oh-my-posh init bash --config "https://raw.githubusercontent.com/dmtzs/dmtzs/refs/heads/master/pythonvenv.omp.json")"'
FILE=$HOME/.bashrc
ROOT_FILE=/root/.bashrc
ALIAS="alias lls='logo-ls'"

grep -qxF "$LINE" $FILE || echo -e "\n$LINE" >> $FILE
grep -qxF "$ALIAS" $FILE || echo -e "\n$ALIAS" >> $FILE

sudo su -c "
grep -qxF "$LINE" $ROOT_FILE || echo -e "\n$LINE" >> $ROOT_FILE
grep -qxF "$ALIAS" $ROOT_FILE || echo -e "\n$ALIAS" >> $ROOT_FILE
"

# Descomentar lo de abajo en cuanto le hagan merge al PR: https://github.com/Yash-Handa/logo-ls/pull/46#issue-1697870795
# wget https://github.com/Yash-Handa/logo-ls/releases/download/v1.3.7/logo-ls_Linux_x86_64.tar.gz
# tar -xzf logo-ls_Linux_x86_64.tar.gz
# cd logo-ls_Linux_x86_64
# sudo cp logo-ls /usr/local/bin

sudo su -c '
if ! command -v go &> /dev/null
then
    echo "🐹 go could not be found, installing..."
    apt update
    apt install -y golang-go
fi

echo "📁 Instalando logo-ls..."
curl https://raw.githubusercontent.com/UTFeight/logo-ls-modernized/master/INSTALL | bash
'

# Variables para el resumen
SUCCESS_MSG="✅ \e[32mÉxito:\e[0m"
FAIL_MSG="❌ \e[31mFallo:\e[0m"
SUMMARY=""

# Verificar instalación de oh-my-posh
if command -v oh-my-posh &> /dev/null
then
    SUMMARY+="$SUCCESS_MSG oh-my-posh instalado correctamente.\n"
else
    SUMMARY+="$FAIL_MSG oh-my-posh no se pudo instalar.\n"
fi

# Verificar configuración en .bashrc
if grep -qxF "$LINE" $FILE && grep -qxF "$ALIAS" $FILE
then
    SUMMARY+="$SUCCESS_MSG Configuración añadida a $FILE.\n"
else
    SUMMARY+="$FAIL_MSG Configuración no se pudo añadir a $FILE.\n"
fi

# Verificar configuración en /root/.bashrc
if sudo grep -qxF "$LINE" $ROOT_FILE && sudo grep -qxF "$ALIAS" $ROOT_FILE
then
    SUMMARY+="$SUCCESS_MSG Configuración añadida a $ROOT_FILE.\n"
else
    SUMMARY+="$FAIL_MSG Configuración no se pudo añadir a $ROOT_FILE.\n"
fi

# Verificar instalación de logo-ls
if command -v logo-ls &> /dev/null
then
    SUMMARY+="$SUCCESS_MSG logo-ls instalado correctamente.\n"
else
    SUMMARY+="$FAIL_MSG logo-ls no se pudo instalar.\n"
fi

# Mostrar resumen
echo -e "\n📋 Resumen de la instalación:\n$SUMMARY"
# 🧪 Falta probarlo en una pc con Ubuntu instalado