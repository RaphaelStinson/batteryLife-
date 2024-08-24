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
    echo -e "${YELLOW}This script needs to be run as root. Trying again with su...${RESET}"
    exec su -c "$script_path"
fi

# Caminho dos arquivos
caminho_arquivo_bsoh="/efs/FactoryApp/bsoh"
caminho_arquivo_batt_discharge="/efs/FactoryApp/batt_discharge_level"

# Verifica e exibe o valor do primeiro arquivo
if [ -f "$caminho_arquivo_bsoh" ]; then
    valor_bsoh=$(cat "$caminho_arquivo_bsoh" | xargs)  # xargs remove espaços em branco extras

    # Verifica se o valor é numérico
    if echo "$valor_bsoh" | grep -E '^[0-9]+(\.[0-9]+)?$' > /dev/null; then
        # Se o valor é tratado como porcentagem direta
        porcentagem=$(echo "$valor_bsoh" | awk '{printf "%.2f", $1}')
        
        # Exibe o valor final em porcentagem com cores
        echo -e "${BLUE}The value of battery life is: ${RESET} ${GREEN}${porcentagem}%${RESET}"
    else
        echo -e "${RED}O valor '$valor_bsoh' no arquivo '${caminho_arquivo_bsoh}' não é um número válido.${RESET}"
    fi
else
    echo -e "${RED}The file was not found in the path: $caminho_arquivo_bsoh${RESET}"
fi

# Verifica e exibe o valor do segundo arquivo
if [ -f "$caminho_arquivo_batt_discharge" ]; then
    valor_batt_discharge=$(cat "$caminho_arquivo_batt_discharge" | xargs)  # xargs remove espaços em branco extras
    echo -e "${BLUE}The total number of cycles is: ${GREEN}${valor_batt_discharge}${RESET}"
else
    echo -e "${RED}The file was not found in the path: $caminho_arquivo_batt_discharge${RESET}"
fi