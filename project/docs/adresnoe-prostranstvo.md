# Адресное пространство

### Выделение адресации

Для начала выделим адресное пространство, но сделаем это по нетлабовски:

Дефолтные пулы трогать не будем, сразу соберем свои (аплинки и лан возьмем из дефолта)

```yaml
addressing:
    lo0_leafs_dc1: # dc1 это громко, так как в проекте будет всего один ЦОД
        ipv4: 192.168.1.0/24
        prefix: 32
    lo0_spines_dc1:
        ipv4: 192.168.11.0/24
        prefix: 32
    p2p_ll: # если захочется сделать ipv6 only или rfc 8950
        ipv6: True
```

А теперь закрепим это всё на устройствах:

```yaml
---
provider: clab # все лабы будут выполяться в clab
defaults:
  device: frr # дальше будут примеры и на arista (не забудте скачать образ)
  # следующий параметр нужен, если хотите поменять дефолтную версию контейнера
  # дефолтные и полностью поддерживаемые можно посмотреть коммандой netlab show images
  # devices.eos.clab.image: localhost/ceos:4.34.2f  

nodes: 
  s1:
    loopback:
      pool: lo0_spines_dc1
  l1:
    loopback:
      pool: lo0_leafs_dc1
  l2:
    loopback:
      pool: lo0_leafs_dc1
        
links:
- s1:
  l1:
  type: p2p
  pool: p2p_ll
- s1:
  l2:
  type: p2p
  pool: p2p_ll
```

### Проверка

Запускаем&#x20;

{% hint style="info" %}
netlab up
{% endhint %}

и подключаемся к хосту

{% hint style="info" %}
netlab connect s1
{% endhint %}

и видим&#x20;

```
s1(bash)# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet 192.168.11.1/32 brd 192.168.11.1 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host proto kernel_lo 
       valid_lft forever preferred_lft forever
2: eth0@if31: 
// skip mgmt link
32: eth2@if33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether aa:c1:ab:11:52:45 brd ff:ff:ff:ff:ff:ff link-netnsid 2
    inet 10.1.0.2/30 brd 10.1.0.3 scope global eth2
       valid_lft forever preferred_lft forever
34: eth1@if35: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether aa:c1:ab:62:06:b6 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::a8c1:abff:fe62:6b6/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever

```

Всё как мы и хотели.&#x20;
