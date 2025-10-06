# OSPF

Расписывать про сам протокол я не буду. Начнем сразу с настройки.

```yaml
plugin: [fabric]
module: [ospf]

fabric:
  spines: 2
  spine:
    loopback:
      pool: lo0_spines_dc1
  leafs: 3
  leaf:
    loopback:
      pool: lo0_leafs_dc1
```

Сразу запустим лабу и посмотрим конфиги:

```
router ospf 1
   router-id 192.168.11.4
interface Ethernet1
   description S1 -> L1
   mac-address 52:dc:ca:fe:04:01
   no switchport
   ip address 10.1.0.2/30
   ip ospf network point-to-point
   ip ospf area 0.0.0.0
!
interface Ethernet2
   description S1 -> L2
   mac-address 52:dc:ca:fe:04:02
   no switchport
   ip address 10.1.0.10/30
   ip ospf network point-to-point
   ip ospf area 0.0.0.0
!
interface Ethernet3
   description S1 -> L3
   mac-address 52:dc:ca:fe:04:03
   no switchport
   ip address 10.1.0.18/30
   ip ospf network point-to-point
   ip ospf area 0.0.0.0
!
interface Loopback0
   ip address 192.168.11.4/32
   ip ospf area 0.0.0.0
!

```

