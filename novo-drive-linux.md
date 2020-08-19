# Registrando um novo HD no linux

1. Executar os comandos:

    ~~~ shell
    # para localizar o HD
    $ sudo fdisk -l

    # Para montar o diretório
    $ sudo mount -t ext4 /dev/<hd> <path>
    ~~~

2. Para manter o HD montado depois de reiniciar. Editar o arquivo **/etc/fsab** e adicinar

    ~~~ simple text
    /dev/<hd> <path>   ext4  defaults       1  2
    ~~~
