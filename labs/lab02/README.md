# Underlay. OSPF

- Настроите OSPF в Underlay сети, для IP связанности между всеми сетевыми устройствами.
- Зафиксируете в документации - план работы, адресное пространство, схему сети, конфигурацию устройств
- Убедитесь в наличии IP связанности между устройствами в OSFP домене

## План работ

### Схема сети

![Схема сети](clos_lab1.png)

### Распределение адресного пространства

Ipv4
| Тип интерфейса | Сеть |
| ---- | ----|
| Lo Spine | 10.0.0.0/24 (eq /32) |
| Lo leaf | 10.0.1.0/24 (eq /32) |
| Uplink Spine1 | 192.168.0.0/24 (eq /31) |
| Uplink Spine2 | 192.168.1.0/24 (eq /31) |
| Vlan interface | 172.16.0.0/12 (le /24) |

Ipv6 (аплинки между сетевыми устройствами на link-local)
| Тип сети | Сеть |
|--------|----|
| Lo Spine | fd00::/112 (eq /128) |
| Lo leaf | fd00::1:0/112 (eq /128) |
| Vlan interface | fd01::/56 (eq /64) |

### Настройки интерфейсов

Все настройки интерфейсов находятся в файлах setup.sh в соответствующих папках хостов. VLAN интерфейсы представлены как br интерфейсы linux.
Конфигурация устройств находится в файлах frr.conf

## Запуск лабораторной работы

### run.sh

- Для запуска используется скрипт run.sh
- Если в вас установлен Docker, то необходимо убрать ключ --runtime и его аргумент, а также заменить podman на docker

## Результаты

### Spine

- Соседство спайна с лифами

```bash
spine1# sh ip ospf neighbor

Neighbor ID     Pri State           Up Time         Dead Time Address         Interface                        RXmtL RqstL DBsmL
10.0.1.1          1 Full/-          1m27s             32.591s 192.168.0.1     eth1:192.168.0.0                     0     0     0
10.0.1.2          1 Full/-          1m26s             33.755s 192.168.0.3     eth2:192.168.0.2                     0     0     0
10.0.1.3          1 Full/-          1m25s             34.968s 192.168.0.5     eth3:192.168.0.4                     0     0     0

spine1# sh ipv6 ospf6 neighbor
Neighbor ID     Pri    DeadTime    State/IfState         Duration I/F[State]
10.0.1.1          1    00:00:38     Full/PointToPoint    00:01:31 eth1[PointToPoint]
10.0.1.2          1    00:00:38     Full/PointToPoint    00:01:31 eth2[PointToPoint]
10.0.1.3          1    00:00:39     Full/PointToPoint    00:01:26 eth3[PointToPoint]
```

- Маршруты до вланов, лупбеков и соседей

```bash
spine1# sh ip route ospf
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIP, O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

O   10.0.0.1/32 [110/0] is directly connected, lo, weight 1, 00:10:56
O>* 10.0.0.2/32 [110/20] via 192.168.0.1, eth1, weight 1, 00:10:40
  *                      via 192.168.0.3, eth2, weight 1, 00:10:40
  *                      via 192.168.0.5, eth3, weight 1, 00:10:40
O>* 10.0.1.1/32 [110/10] via 192.168.0.1, eth1, weight 1, 00:10:45
O>* 10.0.1.2/32 [110/10] via 192.168.0.3, eth2, weight 1, 00:10:45
O>* 10.0.1.3/32 [110/10] via 192.168.0.5, eth3, weight 1, 00:10:45
O>* 172.16.1.0/24 [110/20] via 192.168.0.1, eth1, weight 1, 00:10:45
O>* 172.16.2.0/24 [110/20] via 192.168.0.3, eth2, weight 1, 00:10:45
O>* 172.16.3.0/24 [110/20] via 192.168.0.5, eth3, weight 1, 00:10:45
O   192.168.0.0/31 [110/10] is directly connected, eth1, weight 1, 00:10:56
O   192.168.0.2/31 [110/10] is directly connected, eth2, weight 1, 00:10:56
O   192.168.0.4/31 [110/10] is directly connected, eth3, weight 1, 00:10:56
O>* 192.168.1.0/31 [110/20] via 192.168.0.1, eth1, weight 1, 00:10:45
O>* 192.168.1.2/31 [110/20] via 192.168.0.3, eth2, weight 1, 00:10:45
O>* 192.168.1.4/31 [110/20] via 192.168.0.5, eth3, weight 1, 00:10:45
```
IPv6

```bash
spine1# sh ipv6 route ospf6
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIPng, O - OSPFv3, I - IS-IS, B - BGP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

O   fd00::1/128 [110/0] is directly connected, lo, weight 1, 00:29:26
O>* fd00::2/128 [110/20] via fe80::a8c1:abff:fea4:d39e, eth1, weight 1, 00:29:10
  *                      via fe80::a8c1:abff:feb7:e2c1, eth2, weight 1, 00:29:10
  *                      via fe80::a8c1:abff:fee8:370c, eth3, weight 1, 00:29:10
O>* fd00::1:1/128 [110/10] via fe80::a8c1:abff:fea4:d39e, eth1, weight 1, 00:29:15
O>* fd00::1:2/128 [110/10] via fe80::a8c1:abff:feb7:e2c1, eth2, weight 1, 00:29:15
O>* fd00::1:3/128 [110/10] via fe80::a8c1:abff:fee8:370c, eth3, weight 1, 00:29:15
O>* fd01:0:0:1::/64 [110/20] via fe80::a8c1:abff:fea4:d39e, eth1, weight 1, 00:29:15
O>* fd01:0:0:2::/64 [110/20] via fe80::a8c1:abff:feb7:e2c1, eth2, weight 1, 00:29:15
O>* fd01:0:0:3::/64 [110/20] via fe80::a8c1:abff:fee8:370c, eth3, weight 1, 00:29:15
```
### Пинг с хоста
- Все интерфейсы доступны:

```bash
sudo podman exec -it clab-ospf_lab-HOST1 bash

bash-5.1# ping 172.16.2.1
PING 172.16.2.1 (172.16.2.1) 56(84) bytes of data.
64 bytes from 172.16.2.1: icmp_seq=1 ttl=62 time=0.128 ms
^C
--- 172.16.2.1 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.128/0.128/0.128/0.000 ms
bash-5.1# ping 172.16.2.2
PING 172.16.2.2 (172.16.2.2) 56(84) bytes of data.
64 bytes from 172.16.2.2: icmp_seq=1 ttl=61 time=0.205 ms
64 bytes from 172.16.2.2: icmp_seq=2 ttl=61 time=0.153 ms
^C
--- 172.16.2.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1061ms
rtt min/avg/max/mdev = 0.153/0.179/0.205/0.026 ms
bash-5.1# ping 10.0.0.1
PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
64 bytes from 10.0.0.1: icmp_seq=1 ttl=63 time=0.175 ms
64 bytes from 10.0.0.1: icmp_seq=2 ttl=63 time=0.142 ms
64 bytes from 10.0.0.1: icmp_seq=3 ttl=63 time=0.140 ms
^C
--- 10.0.0.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2075ms
rtt min/avg/max/mdev = 0.140/0.152/0.175/0.016 ms
```
