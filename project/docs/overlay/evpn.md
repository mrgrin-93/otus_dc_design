# EVPN

Раз уж мы настраиваем  EVPN/VXLAN в рамках стандартной Clos-топологии, то стоит рассмотреть все части этой фразы. И стандартную Clos-топологии мы уже сделали в underlay.

Теперь же время рассмотреть EVPN/VXLAN (netlab поддерживает еще и MPLS, но VXLAN идет дефолтно). За его настройку отвечает отдельный модуль evpn и модуль vxlan.

Так как все лабы проводятся на образах arista, то выберем их подход в постороении фабрики, то есть eBGP over eBGP ( ну и потому что iBGP over IGP прост, и нюансов при настройке в netlab почти нет).

{% hint style="info" %}
Так как ариста отказалась запускаться при таком количестве плагинов, этот пример и лаба будут на frr.

Дальнейшие лабы с arista будут iBGP IGP.
{% endhint %}

#### Overlay

Для начала настроим bgp чтобы evpn строился от lo интерфейсов с multihop

```yaml
plugin: [ebgp.multihop, fabric] # добавим плагин для установления mh сессий
evpn.session: [] # отключаем глобально evpn, чтобы не строил лишнего
bgp.multihop.activate.ipv4: [evpn] # и активируем для mh соседства

bgp.community.ebgp: [standard, extended] # ну extended community, без него не заработает
bgp.sessions.ipv4: [ebgp] # и включаем ipv4 af только для ebgp соседства 
                          # (а то попробует построить ibgp для spine)

bgp.multihop.sessions: # и нужно прописать какие сессии нужно устанавливать
  - L1-S1
  - L2-S1
  - L3-S1
  - L1-S2
  - L2-S2
  - L3-S2
```

Теперь сконфигурируем фабрику

```yaml
fabric:
  spines: 2
  spine:
    module: [bgp, evpn] # тут включим на спайнах evpn
    bgp:
      as: 65100
      next_hop_self: false

  leafs: 3
  leaf:
    module: [vlan, vxlan, bgp, evpn, vrf] # а вот лифам нужно больше
    bgp: 
      as: "{65000 + count}"
      next_hop_self: false
```

#### L2VNI

А теперь нужно сделать базовую связанность между хостами

```yaml
nodes: # добавим сами хосты
  h1:
    device: linux
  h2:
    device: linux
    
vlans:
  red:  # создадим влан
    mode: bridge  # без svi
    vni: 1001 
    links: [L1-h1, L2-h2] # и подключим хосты аксесами к лифам
```
