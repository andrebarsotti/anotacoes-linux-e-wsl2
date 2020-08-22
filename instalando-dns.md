# Instalação de um Serviço de DNS

1. Executar o comando para instalar:

~~~ terminal
$ sudo apt install bind9 dnsutils -y
~~~

2. Para configurar o DNS primário:

    1. Editar o arquivo _etc/bind/named.conf.local_
    
        ~~~
        zone "example.com" {
            type master;
            file "/etc/bind/db.example.com";
        };
        ~~~
    
    2. Copiar o arquivo de modelo com o comando:

        ~~~ terminal
        $ sudo cp /etc/bind/db.local /etc/bind/db.example.com
        ~~~

    3. Editar o novo arquivo alterando onde esta **localhost.** com o nome da sua DNS Zone com um ponto adicionado ao final, no nosso exemplo fica **exemplo.com.**. Altere o endereço 127.0.0.1 para o endereço de rede do seu servidor DNS. O Número de Serial deve ser modificado sempre que o arquivo for alterado. Abaixo um exemplo

        ~~~
        ;
        ; BIND data file for example.com
        ;
        $TTL    604800
        @       IN      SOA     example.com. root.example.com. (
                                    2         ; Serial
                                604800         ; Refresh
                                86400         ; Retry
                                2419200         ; Expire
                                604800 )       ; Negative Cache TTL

        @       IN      NS      ns.example.com.
        @       IN      A       192.168.1.10
        @       IN      AAAA    ::1
        ns      IN      A       192.168.1.10
        ~~~
    
    4. Reiniciar o bind

        ~~~ terminal
        $ sudo systemctl restart bind9.service
        ~~~

    5. Configuar a Zona Reversa editando novamente o arquivo _etc/bind/named.conf.local_. Substituir o _1.168.192_ pela estrutura inversa do seu ip sem os endereços finais. O arquivo _db.192_ também deve ter o nome alterado para o começo da sua rede.
    
        ~~~
        zone "1.168.192.in-addr.arpa" {
            type master;
            file "/etc/bind/db.192";
        };
        ~~~
    
    5. Copiar o arquivo de modelo:

        ~~~ terminal
        sudo cp /etc/bind/db.127 /etc/bind/db.192
        ~~~
    
    6. Alterar o novo arquivo, da mesma forma que no da zona de DNS. Exemplo:

        ~~~
        ;
        ; BIND reverse data file for local 192.168.1.XXX net
        ;
        $TTL    604800
        @       IN      SOA     ns.example.com. root.example.com. (
                                    2         ; Serial
                                604800         ; Refresh
                                86400         ; Retry
                                2419200         ; Expire
                                604800 )       ; Negative Cache TTL
        ;
        @       IN      NS      ns.
        10      IN      PTR     ns.example.com.
        ~~~
    
    7. Reiniciar o bind

        ~~~ terminal
        $ sudo systemctl restart bind9.service
        ~~~

# Fonte

Canonical, Domain Name Service (DNS), [link] (https://ubuntu.com/server/docs/service-domain-name-service-dns) acessado em 20/08/2020