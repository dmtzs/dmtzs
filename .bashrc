
# Es lo que agrego yo y no viene por default en .bashrc
# Algunos vienen de mi otro script de instalación
eval "$($HOME/.local/bin/oh-my-posh init bash --config "https://raw.githubusercontent.com/dmtzs/dmtzs/refs/heads/master/pythonvenv.omp.json")"
alias lls='logo-ls'

# Configuración de SSH Agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    # Si no hay un agente SSH corriendo, iniciarlo
    eval "$(ssh-agent -s)" > /dev/null
fi

# Agregar la llave SSH si existe y no está ya cargada
if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add -l &>/dev/null
    if [ $? == 2 ]; then
        # El agente está corriendo pero no tiene llaves cargadas
        ssh-add ~/.ssh/id_ed25519 &>/dev/null
    elif [ $? == 1 ]; then
        # El agente está corriendo, verificar si nuestra llave específica está cargada
        if ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519 2>/dev/null | awk '{print $2}' 2>/dev/null)"; then
            ssh-add ~/.ssh/id_ed25519 &>/dev/null
        fi
    fi
fi
