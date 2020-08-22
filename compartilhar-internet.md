# Compartilhar internet e salvar IP Tables

1. Alterar o arquivo _/etc/sysctl.conf_ e descomentar a linha abaixo. Isso irá habilitar o roteamento ao reiniciar.

    ~~~
    # Uncomment the next line to enable packet forwarding for IPv4
    net.ipv4.ip_forward=1
    ~~~

2. Executar o comando para ativar o Ip Forwarding imediatamente:

    ~~~ terminal
    $ sudo sysctl -p 
    ~~~


3. Criar um _/etc/iptables.blynk.rules_, ele irá salvar as configurações do seu IPTables.

    ~~~ terminal
    $ sudo touch /etc/iptables.blynk.rules
    ~~~

3. Aplicar a regra de NAT para compartillhar a internet. No exemplo abaixo todo o tráfego da rede 172.16.1.X será redirecionado para a placa enp0s3 e "mascarada".

    ~~~ terminal
    $ iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -o enp0s3 -j MASQUERADE
    ~~~ 

4. Criar dois scripts que serão executado quando o serviço de redes "desligar" ou "ligar":

    ~~~ terminal
    $ sudo echo '#!/bin/sh' > /etc/network/if-up.d/iptables
    $ sudo echo "iptables-restore < /etc/iptables.blynk.rules" >> /etc/network/if-up.d/iptables
    $ sudo chmod +x /etc/network/if-up.d/iptables    
    $ sudo echo '#!/bin/sh' > /etc/network/if-down.d/iptables
    $ sudo echo "iptables-save > /etc/iptables.blynk.rules" >> /etc/network/if-down.d/iptables
    $ sudo chmod +x /etc/network/if-down.d/iptables
    ~~~

# Fonte:

FONSECA, VAGNER; Configurando um Laboratório Simples no VirtualBox (2019) - Vídeo; [link](https://www.youtube.com/watch?v=cO4bxoZjYrA&t=848s) acessado em 22-08-2020
DISTANS; [HOWTO] Persistent port forward with iptables, [link](https://community.blynk.cc/t/howto-persistent-port-forward-with-iptables/21407) acessado em 22-08-2020
NETWORKING HOWTOS; Enable IP Forwarding on Ubuntu 13.04; [link](https://www.networkinghowtos.com/howto/enable-ip-forwarding-on-ubuntu-13-04/) acessado em 22-08-2020