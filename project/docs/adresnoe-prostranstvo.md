# Адресное пространство

Для начала выделим адресное пространство, но сделаем это по нетлабовски:

Дефолтные пулы трогать не будем, сразу соберем свои (аплинки и лан возьмем из дефолта)

```yaml
addressing:
    lo0_leafs_dc1: # dc1 это громко, так как в проекте будет всего один ЦОД
        ipv4: 192.168.1.0/24
        prefix: 32
    lo1_leafs_dc1: # пригодится для mlag arista
        ipv4: 192.168.1.0/24
        prefix: 32
        start: 10 # можно и 100, но ни мой ноут, ни codespace не выдержат много хостов
    lo0_spines_dc1:
        ipv4: 192.168.11.0/24
        prefix: 32
    p2p_ll: # если захочется сделать ipv6 only или rfc 8950
        ipv6: True
```

А теперь закрепим это всё на устройствах:

<pre class="language-yaml"><code class="lang-yaml">---
provider: clab # все лабы будут выполяться в clab
defaults:
  device: frr # дальше будут примеры и на arista (не забудте скачать образ)
  # следующий параметр нужен, если хотите поменять дефолтную версию контейнера
  # дефолтные и полностью подднрживаемые можно посмотреть коммандой netlab show images
  # devices.eos.clab.image: localhost/ceos:4.34.2f  

nodes: 
  s1:
<strong>    id: 1 # будет использован в генерации lo адреса
</strong>    loopback:
      pool: lo0_spines_dc1
  l1:
    id: 1
    loopback:
      pool: lo0_leafs_dc1
    interfaces:
      loopback1:
        pool: lo1_leafs_dc1
        type: loopback
  l2:
    id: 2
    loopback:
      pool: lo0_leafs_dc1
    interfaces:
      - loopback1:
        pool: lo1_leafs_dc1
        type: loopback
        
links:
- s1:
  l1:
  type: p2p
  pool: p2p_ll
- s1:
  l2:
  type: p2p
  pool: p2p_ll
</code></pre>
