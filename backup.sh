#!/bin/bash

#Parametros
BACKUP_SOURCE="/mnt/dados"
BACKUP_DESTIN="/mnt/backup"
BACKUP_NAME="link-dados"

#Montando o nome dos arquivos
DATESTR=$(date +"%Y-%m-%d")

#Processo do backup incremental com tar.
echo "$(date +"%H:%M:%S") Iniciando o backup..." > $BACKUP_DESTIN/log-$DATESTR.log
#echo "$(date +"%H:%M:%S") Apagando arquivos antigos..." >> $BACKUP_DESTIN/log-$DATESTR.log
#rm -fv $BACKUP_DESTIN/$BACKUP_NAME*.* >>  $BACKUP_DESTIN/log-$DATESTR.log
echo "$(date +"%H:%M:%S") Fazendo o backup..." >> $BACKUP_DESTIN/log-$DATESTR.log
tar -g $BACKUP_DESTIN/$BACKUP_NAME.snar -cpf $BACKUP_DESTIN/$BACKUP_NAME-$(date +"%Y%m%d%H%M%S").tar $BACKUP_SOURCE >> $BACKUP_DESTIN/log-$DATESTR.log
echo "$(date +"%H:%M:%S") Fim do backup..." >> $BACKUP_DESTIN/log-$DATESTR.log
