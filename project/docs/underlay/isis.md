# ISIS

{% hint style="info" %}
Эту лабу лучше не запускать с frr, там есть некоторые баги (не редистрибьютятся L1 в L2, а у меня еще и более 2х L2 соседей начинают флапать и грузить проц. Но с L1 всё работет нормально.
{% endhint %}

Тут всё также просто как и с ospf:

```yaml
module: [isis, bfd]

isis:
  area: "49.0001"
  bfd:
    ipv4: True
  type: level-1
```

Но вот беда, не завезли аутентификацию. Ну что ж, зато завезли функционал добавления своих конфигов централизовано, с помощью j2 шаблонов.

{% code title="eos.j2" %}
```django
{% for l in interfaces %}
interface {{ l.ifname }}
    isis authentication mode text
    isis authentication key isispassword
{% endfor %}

```
{% endcode %}

> netlab config templates/

И получим нужный нам конфиг:

```
interface Ethernet1
   description S1 -> L1
   mac-address 52:dc:ca:fe:04:01
   no switchport
   ip address 10.1.0.2/30
   bfd interval 500 min_rx 500 multiplier 3
   isis enable Gandalf
   isis bfd
   isis network point-to-point
   isis authentication mode text
   isis authentication key 7 MNPMSMz4HoGUQdIUfB+bSg==
!
interface Ethernet2
   description S1 -> L2
   mac-address 52:dc:ca:fe:04:02
   no switchport
   ip address 10.1.0.10/30
   bfd interval 500 min_rx 500 multiplier 3
   isis enable Gandalf
   isis bfd
   isis network point-to-point
   isis authentication mode text
   isis authentication key 7 MNPMSMz4HoGUQdIUfB+bSg==
!
interface Ethernet3
   description S1 -> L3
   mac-address 52:dc:ca:fe:04:03
   no switchport
   ip address 10.1.0.18/30
   bfd interval 500 min_rx 500 multiplier 3
   isis enable Gandalf
   isis bfd
   isis network point-to-point
   isis authentication mode text
   isis authentication key 7 MNPMSMz4HoGUQdIUfB+bSg==

```
