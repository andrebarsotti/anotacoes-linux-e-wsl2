
# Configuração de redundancia de placas de rede  (_bonding_)

1. No Ubuntu Server 20.04 é preciso editar o arquivo _.yaml_ que esta em  _/etc/netplan/_. Para verificar o nome do arquivo:
  ~~~ terminal
  $ ls -alh /etc/netplan/
  ~~~

2. Verificar as placas de rede existentes com o comando:
  ~~~ terminal
  $ ip a s
  ~~~

3. Editar o arquivo conforme abaixo:
  ~~~ yaml
  network:
    version: 2
    # Configuração das placas de rede
    ethernets:
        # Placa de rede com acesso à internet
        enp0s3:
          dhcp4: true
          dhcp6: false
        # Placas de rede do bond
        enp0s8:
          dhcp4: false
          dhcp6: false
          optional: true
        enp0s9:
          dhcp4: false
          dhcp6: false
          optional: true
    # Configuracação do bonding
    bonds:
        bond-lan:
          interfaces: [enp0s8,enp0s9]
          addresses: [10.10.10.1/24]
          parameters:
            mode: balance-rr
            mii-monitor-interval: 100
  ~~~
  
  A opção _optional: true_ permite que o sistema faça um boot sem esperar que essas interfaces tenham sido totalmente carregas.

4. Aplicar a configuração com o comando:
  ~~~ terminal
  $ sudo netplan apply
  ~~~