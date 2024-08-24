#!/system/bin/sh

# Definindo cores
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
RESET='\033[0m'

# Caminho do script
script_path="$0"

# Verifica se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${YELLOW}Este script precisa ser executado como root. Tentando novamente com su...${RESET}"
    exec su -c "$script_path"
fi

# Caminho do arquivo
caminho_arquivo="/efs/FactoryApp/bsoh"

# Verifica se o arquivo existe
if [ -f "$caminho_arquivo" ]; then
    # Lê o valor do arquivo
    valor=$(cat "$caminho_arquivo" | xargs)  # xargs remove espaços em branco extras
    
    # Verifica se o valor é numérico
    if echo "$valor" | grep -E '^[0-9]+(\.[0-9]+)?$' > /dev/null; then
        # Se o valor é tratado como porcentagem direta
        porcentagem=$(echo "$valor" | awk '{printf "%.2f", $1}')
        
        # Exibe o valor final em porcentagem com cores
        echo -e "${BLUE}The value of battery life is:${RESET} ${GREEN}${porcentagem}%${RESET}"
    else
        echo -e "${RED}O valor '$valor' no arquivo não é um número válido.${RESET}"
    fi
else
    echo -e "${RED}The file was not found in the path: $caminho_arquivo${RESET}"
fi