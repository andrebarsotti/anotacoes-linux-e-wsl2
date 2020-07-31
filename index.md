# Liberar memória WSL2

Passo-a-passo para limpeza de cache:

1. No seu _bash_ do WSL execute: 
  ~~~ terminal
  $ sudo crontab -e -u root
  ~~~
  e adcione a linha abaixo :
  ~~~
  */15 * * * * sync; echo 3 > /proc/sys/vm/drop_caches; touch /root/drop_caches_last_run
  ~~~
  Esse "\*/15" significa que a execução será a cada 15 minutos. Você pode modificar se desejar.

1. Para iniciar automáticamente o cron no WSL, altere seu arquivo **~/.bashrc** adicionando a seguinte linha:
  ~~~
  [ -z "$(ps -ef | grep cron | grep -v grep)" ] && sudo /etc/init.d/cron start &> /dev/null
  ~~~
  isso pode ser feito executando o comando:
  ~~~ terminal
  $ echo '[ -z "$(ps -ef | grep cron | grep -v grep)" ] && sudo /etc/init.d/cron start &> /dev/null' >> ~/.bashrc
  ~~~

1. É preciso permitir que o cron inicie sem solicitar a senha do root. No your WSL _bash_ execute:
  ~~~ terminal
  $ sudo visudo 
  ~~~
  e adicione a seguinte linha:
  ~~~ 
  %sudo ALL=NOPASSWD: /etc/init.d/cron start
  ~~~

1. (Opcional) Você pode limitar manualmente o limite de memória do WSL. O valor defuault é limitado à 80% da memória do host, se você desejar mudar crie um arquivo **.wslconfig** no seu **%UserProfile%** com o seguinte conteúdo:
  ~~~
  [wsl2]
  memory=8GB
  ~~~

1. Finalmente, para garantir que esta tudo ok, execute em um _Powersheel_ com privilégio administrativo:
  ~~~ terminal
    PS C:\> wsl --shutdown
  ~~~
  Reinicie seu terminal WSL :)

**OBS:** Você pode veriifcar a execução cron job olhando em /root/drop_caches_last_run pela data de modificação com o comando: 
  ~~~ terminal
  $ sudo stat -c '%y' /root/drop_caches_last_run
  ~~~
  Um alias para esse comando pode ser adiconado no seu _.bashrc_.
