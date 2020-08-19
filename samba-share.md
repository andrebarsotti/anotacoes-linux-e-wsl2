# Configurando um share no samba

1. Instalar o Samba no linux:

    ~~~ terminal
    $ sudo apt install -y samba
    ~~~

2. No diretório **/etc/samba/**:

    ~~~ terminal
    $ sudo mv smb.conf smb.conf.old
    $ sudo touch smb.conf
    ~~~

3. Abrir o no arquivo **smb.conf** e adiconar as linhas:

    ~~~ INI
    [global]
        server role = standalone server #
        map to guest = bad user # deixa os usuário como guest, se desejar que fiquem sem acesso user "never"
        usershare allow guests = yes
        hosts allow = 192.168.15.0/24 # Sua rede
        hosts deny = 0.0.0.0/0

    [<nome do compartilhamento>]
        comment = Open Linux Share
        path = ***<sharename>***
        read only = no
        guest ok = yes
        force create mode = 0755
        force user = ***<usuario default>***
        force group = ***<grupo default>***
    ~~~

4. Depois de salvar as mudanças executar:

    ~~~ terminal
    $ testparm # Valida se o arquivo esta integro
    $ sudo service restart smbd # Reinicia o serviço do smb
    $ sudo ufw allow Samba # (Opcional) habilita o samba no firewall
    ~~~
