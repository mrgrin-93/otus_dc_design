# VxLAN. L2 VNI


- Настроите BGP peering между Leaf и Spine в AF l2vpn evpn
- Настроите связанность между клиентами в первой зоне и убедитесь в её наличии
- Зафиксируете в документации - план работы, адресное пространство, схему сети, конфигурацию устройств

## План работы

### Схема сети

![Схема сети](evpn_l2_lab.png)

### Распределение адресного пространства

Аплинки на ll ipv6 (rfc 8950)

Ipv4
| Тип интерфейса | Сеть |
|----|----|
| Lo leaf | 192.168.{#DC}1.0/24 (eq /32) |
| Lo Spine | 192.168.{#DC}2.0/24 (eq /32) |


Ipv6
| Тип сети | Сеть |
|--------|----|
| Lo leaf | fd{#DC}::1:0/112 (eq /128) |
| Lo Spine | fd{#DC}::/112 (eq /128) |

AS
| Type | AS |
|----|----|
| Leafs | 65{#DC}01-65{#DC}99 |
| Spines | 650{#DC}0 |


### BGP

### Настройки интерфейсов

Конфигурация устройств находится в соотвествующих папках хостов в файле startup-configs

Шаблоны настроек (только недостающее в lab04)

Leaf
```
vlan n

interface Ethernet1/3
   switchport access vlan n

interface Vxlan1
   vxlan source-interface Loopback0
   vxlan vlan n vni 100n

router bgp 65101
  neighbor BGP send-community extended
  vlan 10
     rd auto
     route-target both 65010:100n
     redistribute learned
  address-family evpn
    neighbor BGP activate
```

Spine

```
router bgp 65010
  neighbor BGP send-community extended
  !
  address-family evpn
     neighbor BGP activate
  !
```

## Запуск лабораторной работы

### run.sh

- Для запуска используется скрипт run.sh
- Если в вас установлен Docker, то необходимо убрать ключ --runtime и его аргумент

## Результаты

### evpn
В выводе команды sh bgp evpn видно всех соседей и 2 хоста (локальный с Path = i и удаленный с Path = 65010 65102)
```
leaf1-1#sh bgp evpn
          Network                Next Hop              Metric  LocPref Weight  Path
 * >Ec    RD: 192.168.11.2:10 mac-ip aac1.ab64.541b
                                 192.168.11.2          -       100     0       65010 65102 i
 *  ec    RD: 192.168.11.2:10 mac-ip aac1.ab64.541b
                                 192.168.11.2          -       100     0       65010 65102 i
 * >      RD: 192.168.11.1:10 mac-ip aac1.aba1.cf10
                                 -                     -       -       0       i
 * >      RD: 192.168.11.1:10 imet 192.168.11.1
                                 -                     -       -       0       i
 * >Ec    RD: 192.168.11.2:10 imet 192.168.11.2
                                 192.168.11.2          -       100     0       65010 65102 i
 *  ec    RD: 192.168.11.2:10 imet 192.168.11.2
                                 192.168.11.2          -       100     0       65010 65102 i
 * >Ec    RD: 192.168.11.2:20 imet 192.168.11.2
                                 192.168.11.2          -       100     0       65010 65102 i
 *  ec    RD: 192.168.11.2:20 imet 192.168.11.2
                                 192.168.11.2          -       100     0       65010 65102 i
 * >Ec    RD: 192.168.11.3:20 imet 192.168.11.3
                                 192.168.11.3          -       100     0       65010 65103 i
 *  ec    RD: 192.168.11.3:20 imet 192.168.11.3
                                 192.168.11.3          -       100     0       65010 65103 i

```

Аналогично и для остальных влан и хостов

### mac address-table

```
leaf1-1#sh mac address-table
          Mac Address Table
------------------------------------------------------------------

Vlan    Mac Address       Type        Ports      Moves   Last Move
----    -----------       ----        -----      -----   ---------
  10    aac1.ab64.541b    DYNAMIC     Vx1        1       0:02:40 ago
  10    aac1.aba1.cf10    DYNAMIC     Et1/3      1       0:02:40 ago
```

### host
Пинг с хоста проходит

```
ping  -I 172.16.1.2 172.16.1.3
PING 172.16.1.3 (172.16.1.3) from 172.16.1.2 : 56(84) bytes of data.
64 bytes from 172.16.1.3: icmp_seq=1 ttl=64 time=6.30 ms
64 bytes from 172.16.1.3: icmp_seq=2 ttl=64 time=7.12 ms
```
