#!/bin/bash

#Parametros
BACKUP_SOURCE="/mnt/dados"
BACKUP_DESTIN="/mnt/backup"
BACKUP_NAME="link-dados"

#Montando o nome dos arquivos
DATESTR=$(date +"%Y-%m-%d")

#Processo do backup incremental com tar.
echo "$(date +"%Y-%m-%d %H:%M:%S") Iniciando o backup..." >> /var/local/backup-files.log
#Faz um full-backup as segundas e incremental nos outros dias.
if [ $(date +"%u") -eq "1" ]
then
  echo "$(date +"%Y-%m-%d %H:%M:%S") Apagando arquivos antigos..." >> /var/local/backup-files.log
  rm -fv $BACKUP_DESTIN/$BACKUP_NAME*.* >>  /var/local/backup-files.log
fi
echo "$(date +"%Y-%m-%d %H:%M:%S") Fazendo o backup..." >> /var/local/backup-files.log
tar -g $BACKUP_DESTIN/$BACKUP_NAME.snar -cpf $BACKUP_DESTIN/$BACKUP_NAME-$(date +"%Y%m%d%H%M%S").tar $BACKUP_SOURCE >> /var/local/backup-files.log
echo "$(date +"%Y-%m-%d %H:%M:%S") Fim do backup..." >> /var/local/backup-files.log
