#!/bin/bash

# Cria infra AWS-EC2 V1.0 - Ricardo Merces -  twitter.com/r_merces
# Pre requisitos:
# - aws cli configurada
# - arquivo.pem no mesmo diretório do script
# - Security group criado

##### CONFIGURAÇÕES
IMAGE_ID="ami-0d8f6eb4f641ef691"  # Cada Região da AWS tem um ID diferente para a mensama imagem
INSTANCE_TYPE="t2.micro"          # Tipo da instância
KEY_NAME="aws-ohio"               # Nome da chave de acesso ssh (sem .pem)
SECURITY_GROUP="acesso-ssh"       # Security Grupo com permissão para ssh 
USER_DATA="file://ec2-config.txt" # Arquivo com o setup da instância
###################

clear
echo "##### Provisiona Infra AWS-EC2 V1.0"
sleep 1.5
if [ -e "$KEY_NAME.pem" ]
then
    read -p "Quantas máquinas deseja provisionar? `echo $'\n> '`" QUANTIDADE
    read -p "Confirma o provisionamento de $QUANTIDADE Instâncias (s/n) `echo $'\n> '`" RESPOSTA
    if [ $RESPOSTA == "s" ]
    then
        echo "" > ec2-listagem.txt
        
	aws ec2 run-instances --image-id $IMAGE_ID --count $QUANTIDADE --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SECURITY_GROUP  --user-data $USER_DATA | grep InstanceId >> ec2-listagem.txt
        
	echo "##### Inventário das Instâncias"
        cat ec2-listagem.txt
        echo "##### Tome um CAFÉ e aguarde 5 minutos enquanto as instâncias estão sendo criadas!"
    else
        exit 0
    fi
else
    echo "Chave $KEY_NAME não encontrada !!!"
fi