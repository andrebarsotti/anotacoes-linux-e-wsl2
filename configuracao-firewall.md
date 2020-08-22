# Passo-a-passo para a configuração de um servidor de firewall linux no Ubuntu 20.04

Esses são os passos para configuração de um de um servidor de firewall.

## Configuar um arquivo com as regras de IP Tables

1. Criar um arquivo de script:
  ~~~ Bash
  #!/bin/bash
  REDELOCAL="10.10.10.0/24"

  local(){
    # Libera as portas 443, 80, 53 e 123 de conexões provindas do servidor firewall
    iptables -t filter -A INPUT -i enp0s3 -p tcp -m multiport --sports 80,443 -j ACCEPT
    iptables -t filter -A INPUT -i enp0s3 -p udp -m multiport --sports 53,123 -j ACCEPT
    iptables -t filter -A OUTPUT -o enp0s3 -p tcp -m multiport --dports 80,443 -j ACCEPT
    iptables -t filter -A OUTPUT -o enp0s3 -p udp -m multiport --dports 53,123 -j ACCEPT

    # Libera conexões para o protocolo icmp - ping
    iptables -t filter -A OUTPUT -o enp0s3 -p icmp --icmp-type 8 -d 0/0 -j ACCEPT
    iptables -t filter -A INPUT -i enp0s3 -p icmp --icmp-type 0 -s 0/0 -j ACCEPT

    # Libera trafego na interface loopback
    iptables -t filter -A INPUT -i lo -j ACCEPT
    iptables -t filter -A OUTPUT -o lo -j ACCEPT

    # Libera trafego ao ssh e proxy squid #
    iptables -t filter -A INPUT -i bond0 -p tcp -m multiport --dports 22,3128 -s $REDELOCAL -j ACCEPT
    iptables -t filter -A OUTPUT -o bond0 -p tcp -m multiport --sports 22,3128 -d $REDELOCAL -j ACCEPT
  }

  forwarding(){
    # Libera as portas 443, 80, 53 e 123 de conexões originadas da rede LAN $REDELOCAL 
    iptables -t filter -A FORWARD -i enp0s3 -p tcp -m multiport --sports 80,443 -d $REDELOCAL -j ACCEPT
    iptables -t filter -A FORWARD -i enp0s3 -p udp -m multiport --sports 53,123 -d $REDELOCAL -j ACCEPT
    iptables -t filter -A FORWARD -i bond0 -p tcp -m multiport --dports 80,443 -s $REDELOCAL -j ACCEPT
    iptables -t filter -A FORWARD -i bond0 -p udp -m multiport --dports 53,123 -s $REDELOCAL -j ACCEPT

    # Libera conexões para o protocolo icmp - ping
    iptables -t filter -A FORWARD -o enp0s3 -p icmp --icmp-type 8 -d 0/0 -s $REDELOCAL -j ACCEPT
    iptables -t filter -A FORWARD -i enp0s3 -p icmp --icmp-type 0 -s 0/0 -d $REDELOCAL -j ACCEPT
  }

  internet(){
    # Compartilha a internet.
    sysctl -w net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -s $REDELOCAL -o enp0s3 -j MASQUERADE
  }

  default(){
    # Reijeta o restante por padrão.
    iptables -t filter -P INPUT DROP
    iptables -t filter -P OUTPUT DROP
    iptables -t filter -P FORWARD DROP
  }

  iniciar(){
    local
    forwarding
    default
    internet
  }

  parar(){
    iptables -t filter -P INPUT ACCEPT
    iptables -t filter -P OUTPUT ACCEPT
    iptables -t filter -P FORWARD ACCEPT
    iptables -t filter -F
  }

  case $1 in
    start|START|Start)iniciar;;
    stop|STOP|Stop)parar;;
    restart|RESTART|Restart)parar;iniciar;;
    listar)iptables -t filter -nvL;;
    *)echo "Execute o script com os parâmetros start ou stop ou restart";;
  esac
  ~~~

2. 

# Fontes

Netplan configuration examples, [https://netplan.io/examples](https://netplan.io/examples), acessado em 16/08/2020
