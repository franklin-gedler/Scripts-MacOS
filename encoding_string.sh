#!/bin/bash


# para encriptar necesitas la password y la key ambas en texto plano
# para desencriptar necesitas la key en texto plano y el random generado por la encriptacion

# ---- Para Encriptar

    # encodeamos la llave
    key=$(echo 'aqui pegas el string que desees para tu llave' | base64)

    # para usar dicha key en un script
    key=$(echo 'random generada por el encode de la key' | base64 --decode)

    # encodeamos la password
    pass=$(echo 'aqui pegamos la password' | openssl enc -base64 -e -aes-256-cbc -pass pass:$key 'esta key debe de estar en texto plano')

# ---- Para Desencriptar
    
    # recuerda pasarle la key en texto plano
    pass=$(echo "random generada por la encriptacion" | openssl enc -base64 -d -aes-256-cbc -pass pass:$key 'esta key debe de estar en texto plano')

# Nota: 
# En el script solo va a estar reflejado las random, el script debe decodearla en memoria para pasarla por texto plano
# a los comandos que necesiten dicha password, en el script de Prepare-MacOS linea 535 esta un ejemplo claro de su uso
# 