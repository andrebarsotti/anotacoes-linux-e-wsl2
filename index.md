# Liberar memória WSL2

Step-by-step workaround:

1. Execute cache drop periodically. On your WSL bash execute _$ sudo crontab -e -u root_ and add the following line:
~~~ terminal
$ */15 * * * * sync; echo 3 > /proc/sys/vm/drop_caches; touch /root/drop_caches_last_run
~~~
The "*/15" means that it will be executed every 15 minutes. You can change it if you wish

1. Auto start cron service. On your _~/.bashrc_ add the following line:
~~~ terminal
$ [ -z "$(ps -ef | grep cron | grep -v grep)" ] && sudo /etc/init.d/cron start &> /dev/null
~~~

1. Allow starting cron service without asking by root password. On your WSL bash execute $ sudo visudo and add the following line:
~~~ terminal
$ %sudo ALL=NOPASSWD: /etc/init.d/cron start
~~~

1. (Optional) Hard limit the maximum memory. By default it's limited to 80% of the host memory, if yo	u want to change it create a .wslconfig file on your _%UserProfile%_ with the following content:
~~~
[wsl2]
memory=8GB
~~~

1. Finally, to make sure that all changes take effect, execute:
~~~ terminal
  PS C:\> wsl --shutdown on
~~~
Re-open your WSL terminal and have fun :)

_You can check if the cron job is running accordingly by looking at the /root/drop_caches_last_run last modification date: $ sudo stat -c '%y' /root/drop_caches_last_run_