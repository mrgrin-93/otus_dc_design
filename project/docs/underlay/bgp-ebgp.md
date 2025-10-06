# BGP (eBGP)

Тут тоже без особых сложностей. Только вот отдельной опции для включения ecmp не подвезли. Нашел одну статью про cumulus, но там же frr. А в frr ecmp включен по дефолту. (Если сменить device на frr, то эту строку нужно будет закомментировать)

Исправим как и в прошлый раз, но в этот раз прямо в топологии и при запуске.

{% code title="templates/mp.j2" %}
```django
router bgp {{ bgp.as }}
  maximum-paths 8 ecmp 8
```
{% endcode %}

```yaml
plugin: [fabric]
module: [bgp, bfd]

bgp.next_hop_self: false
bgp.bfd: true

fabric:
  spines: 2
  spine:
    loopback:
      pool: lo0_spines_dc1
    bgp:
      as: 65100
      next_hop_self: false
    config: [templates/mp]

  leafs: 3
  leaf:
    loopback:
      pool: lo0_leafs_dc1
    bgp:
      as: "{65000 + count}"
      next_hop_self: false
    config: [templates/mp]
```

К сожалению убрать next-hop-self так и не получилось (даже когда напрямую указал, что нужно убрать)

```
router bgp 65002
   router-id 192.168.1.2
   no bgp default ipv4-unicast
   maximum-paths 8 ecmp 8
   bgp advertise-inactive
   neighbor ebgp_intf_Ethernet1 peer group
   neighbor ebgp_intf_Ethernet1 remote-as 65100
   neighbor ebgp_intf_Ethernet1 description S1
   neighbor ebgp_intf_Ethernet1 send-community standard large
   neighbor ebgp_intf_Ethernet2 peer group
   neighbor ebgp_intf_Ethernet2 remote-as 65100
   neighbor ebgp_intf_Ethernet2 description S2
   neighbor ebgp_intf_Ethernet2 send-community standard large
   neighbor interface Et1 peer-group ebgp_intf_Ethernet1
   neighbor interface Et2 peer-group ebgp_intf_Ethernet2
   !
   address-family ipv4
      neighbor ebgp_intf_Ethernet1 activate
      neighbor ebgp_intf_Ethernet1 next-hop address-family ipv6 originate
      neighbor ebgp_intf_Ethernet1 next-hop-self
      neighbor ebgp_intf_Ethernet2 activate
      neighbor ebgp_intf_Ethernet2 next-hop address-family ipv6 originate
      neighbor ebgp_intf_Ethernet2 next-hop-self
      network 192.168.1.2/32
   !
   address-family ipv6
      neighbor ebgp_intf_Ethernet1 activate
      neighbor ebgp_intf_Ethernet1 next-hop-self
      neighbor ebgp_intf_Ethernet2 activate
      neighbor ebgp_intf_Ethernet2 next-hop-self

```

Зато теперь мы получаем ipv4 через ipv6 ll адреса и имеем ecmp:

```
 B E      192.168.1.1/32 [200/0]
           via fe80::50dc:caff:fefe:402, Ethernet1
           via fe80::50dc:caff:fefe:502, Ethernet2
 C        192.168.1.2/32 [0/0]
           via Loopback0, directly connected
 B E      192.168.1.3/32 [200/0]
           via fe80::50dc:caff:fefe:402, Ethernet1
           via fe80::50dc:caff:fefe:502, Ethernet2
 B E      192.168.11.4/32 [200/0]
           via fe80::50dc:caff:fefe:402, Ethernet1
 B E      192.168.11.5/32 [200/0]
           via fe80::50dc:caff:fefe:502, Ethernet2
```
