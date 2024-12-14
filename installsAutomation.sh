#!/bin/bash

# Verificar si se pasaron parámetros
if [ "$#" -eq 0 ]; then
    echo "No se proporcionaron archivos para descargar y ejecutar."
    exit 1
fi

# Repositorio y rama de GitHub
REPO_URL="https://raw.githubusercontent.com/dmtzs/dmtzs/refs/heads/master/installs"

# Descargar y ejecutar cada archivo pasado como parámetro
for script in "$@"
do
    # Descargar el script
    curl -O "$REPO_URL/$script.sh"

    # Verificar si la descarga fue exitosa
    if [ ! -f "$script" ]; then
        echo "Error al descargar $script"
        continue
    fi

    # Dar permisos de ejecución al script
    chmod +x "$script"

    # Ejecutar el script
    ./"$script"
done