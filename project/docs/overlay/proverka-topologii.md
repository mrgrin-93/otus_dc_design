# Проверка топологии

Отойдем немного в сторону от построения фабрики, и проверим, что она вообще работает.

Для этого в netlab есть отдельный раздел в топологии [validate](https://netlab.tools/topology/validate)

#### Простые тесты

Начнем с простых проверок. Просто попингуем хосты с хостов:

```yaml
validate:
  ping:
    description: Pinging host from hosts
    nodes: [h1, h3]
    devices: [linux]
    exec: ping -c 10 h5 -A
    valid: |
      "64 bytes" in stdout
```

Тут мы пингуем h5 с h1 и h3. Для запуска валидации нужно запустить

{% hint style="info" %}
netlab validate
{% endhint %}

И получим в ответ:

```bash
[ping]    Pinging H2 from H1 [ node(s): h1,h3 ]
[PASS]    Validation succeeded on h1
[PASS]    Validation succeeded on h3
[PASS]    Test succeeded in 0.2 seconds

[SUCCESS] Tests passed: 2
```

#### Модульные тесты

Можно составлять и более сложные тесты, и проверять вывод show команд оборудования

Давайте проверим, что для всех соседей, указанных в топологии, была установлена BGP сессия (пример из документации, только больше чем с 2мя соседями не работало, пришлось немного переписать)

```yaml
  session:
    description: Check the EBGP session on the ISP router
    fail: The EBGP session with your router is not established
    pass: The EBGP session is in the Established state
    nodes: [ext_rtr, L1]
    show:
      frr: bgp summary json
      eos: bgp summary | json

    valid:
      frr: >
        {% for n in bgp.neighbors if n.name == 'L3' %}
        result["ipv4Unicast"]["peers"]["{{ n.ipv4 }}"]["state"] == "Established"{% if not loop.last %} and {% endif %}
        {% endfor %}
      eos: >
        {% for n in bgp.neighbors %}
        result["vrfs"]["default"]["peers"]["{{ n.ipv4 }}"]["peerState"] == "Established"{% if not loop.last %} and {% endif %}
        {% endfor %}
```

Здесь bgp.neighbors можно посмотреть в файле netlab.snapshot.yml. В этом файле указываются все данные по топологии. Если в show на выходе получается валидный json, то результат помещается в переменную result.&#x20;

В valid указывается python код. Если же там валидный j2, то генерируется код из j2 шаблона.

Также есть уже готовые плагины для ping, проверки bgp, ospf и isis. Встроенные плагины работают только с frr и eos.

А еще можно менять конфигурацию прямо во время теста. Делается это аналогично с добавлением кастомного конфига.

Погасим интерфейс на L1 и проверим bgp снова

```yaml
  disable_eth1:
    description: Disable interface on L1
    config:
      template: template
    nodes: [L1]
    pass: int disabled

  session2:
    description: Check EBGP sessions with DUT
    nodes: [L1, L2]
    plugin: bgp_neighbor(node.bgp.neighbors,'S1')
```

{% code title="template.j2" %}
```django
interface Eth1
shutdown
```
{% endcode %}

В конечном резултате получим вывод:

```
[ping]         Pinging host from hosts [ node(s): h1,h3 ]
[PASS]         Validation succeeded on h1
[PASS]         Validation succeeded on h3
[PASS]         Test succeeded in 0.2 seconds

[session]      Check the EBGP session on the ISP router [ node(s): ext_rtr,L1 ]
[PASS]         Validation succeeded on ext_rtr
[PASS]         Validation succeeded on L1
[PASS]         Test succeeded in 0.3 seconds
[PASS]         The EBGP session is in the Established state

[disable_eth1] Disable interface on L1 [ node(s): L1 ]
[INFO]         Executing configuration snippet template
[PASS]         int disabled

[session2]     Check EBGP sessions with DUT [ node(s): L1,L2 ]
[FAIL]         Node L1: The neighbor 10.1.0.2 (S1) is in state Idle (expected Established)
[PASS]         L2: Neighbor 10.1.0.6 (S1) is in state Established

[FAIL]         7 tests completed, one test failed

```

Сначала мы проверили пинг между хостами в разных вланах и vrf, затем проверили BGP сессии на L1 и ext\_rtr, затем отключили линк S1-L1 и снова проверили BGP. В итоге увидели  падение сессии.&#x20;
