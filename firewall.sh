#!/bin/bash
REDELOCAL="10.10.10.0/24"

local(){

  # Libera as portas 443, 80, 53 e 123 de conexões provindas do servidor firewall
  iptables -t filter -A INPUT -i enp0s3 -p tcp -m multiport --sports 80,443 -j ACCEPT
  iptables -t filter -A INPUT -i enp0s3 -p udp -m multiport --sports 53,123 -j ACCEPT
  iptables -t filter -A OUTPUT -o enp0s3 -p tcp -m multiport --dports 80,443 -j ACCEPT
  iptables -t filter -A OUTPUT -o enp0s3 -p udp -m multiport --dports 53,123 -j ACCEPT

  # Liberando SSH para acesso remoto
  #iptables -t filter -A INPUT -i enp0s3 -p tcp -m multiport --dports 22 -j ACCEPT
  #iptables -t filter -A OUTPUT -o enp0s3 -p tcp -m multiport --sports 22 -j ACCEPT

  # Libera conexões para o protocolo icmp - ping
  iptables -t filter -A OUTPUT -o enp0s3 -p icmp --icmp-type 8 -d 0/0 -j ACCEPT
  iptables -t filter -A INPUT -i enp0s3 -p icmp --icmp-type 0 -s 0/0 -j ACCEPT

  # Libera trafego na interface loopback
  iptables -t filter -A INPUT -i lo -j ACCEPT
  iptables -t filter -A OUTPUT -o lo -j ACCEPT

  # Libera trafego ao ssh e proxy squid #
  iptables -t filter -A INPUT -i bond0 -p tcp -m multiport --dports 22,3128 -s $REDELOCAL -j ACCEPT
  iptables -t filter -A OUTPUT -o bond0 -p tcp -m multiport --sports 22,3128 -d $REDELOCAL -j ACCEPT

  # Liberar DHCP
  #iptables -t filter -A INPUT -i bond0 -p udp -m multiport --sports 67,68 -s $REDELOCAL -j ACCEPT
  #iptables -t filter -A OUTPUT -o bond0 -p udp -m multiport --dports 67,68 -s $REDELOCAL -j ACCEPT

  # Liberar DNS
  #iptables -t filter -A INPUT -i bond0 -p udp -m multiport --dports 53 -s $REDELOCAL -j ACCEPT
  #iptables -t filter -A INPUT -i bond0 -p tcp -m multiport --dports 53 -s $REDELOCAL -j ACCEPT
  #iptables -t filter -A OUTPUT -o bond0 -p udp -m multiport --sports 53 -d $REDELOCAL -j ACCEPT
  #iptables -t filter -A OUTPUT -o bond0 -p tcp -m multiport --sports 53 -d $REDELOCAL -j ACCEPT
  #iptables -t filter -A INPUT -i bond0 -p udp -m multiport --dports 123 -s $REDELOCAL -j ACCEPT
  #iptables -t filter -A OUTPUT -o bond0 -p udp -m multiport --sports 123 -d $REDELOCAL -j ACCEPT
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
  #sysctl -w net.ipv4.ip_forward=1
  sysctl -p
  iptables -t nat -A POSTROUTING -s $REDELOCAL -o enp0s3 -j MASQUERADE
}

default(){
  # Reijeta o restante por padrão.
  iptables -t filter -P INPUT DROP
  iptables -t filter -P OUTPUT DROP
  iptables -t filter -P FORWARD DROP
}

save(){
  iptables-save > /etc/iptables.blynk.rules
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
  iptables -t nat -F
}

case $1 in
  start|START|Start|st)iniciar;;
  stop|STOP|Stop|sp)parar;;
  restart|RESTART|Restart|rs)parar;iniciar;;
  list|ls)iptables -t filter -nvL && iptables -t nat -nvL;;
  share|sh)internet;;
  save|sv)save;;
  *)echo "Execute o script com os parâmetros start ou stop ou restart";;
esac
