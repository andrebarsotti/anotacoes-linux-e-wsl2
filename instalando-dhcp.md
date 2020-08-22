# Instalando um servidor DHCP.

1. Para instalar executar o comandos:
    
    ~~~ terminal
    $ sudo apt install isc-dhcp-server
    ~~~

2. Editar o arquivo _/etc/dhcp/dhcpd.conf_ conforme abaixo:

    ~~~
    default-lease-time 600;
    max-lease-time 7200;
    authoritative;

    subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.150 192.168.1.200;
    option routers 192.168.1.1;
    option domain-name-servers 192.168.1.1, 192.168.1.2;
    option domain-name "mydomain.example";
    option subnet-mask 255.255.255.0;
    }
    ~~~

3. Editar o arquivo _/etc/default/isc-dhcp-server_ e alterar a variável abaixo para indicar a placa que irá prover os ips na rede:

    ~~~
    INTERFACESv4="bond0"
    ~~~

4. Reiniciar o serviço:

    ~~~ terminal
    $ sudo systemctl restart isc-dhcp-server.service
    ~~~

# Fonte

CANONICAL, Dynamic Host Configuration Protocol (DHCP), [link](https://ubuntu.com/server/docs/network-dhcp) acessado em 22/08/2020