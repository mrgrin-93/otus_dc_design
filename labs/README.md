## Лабораторные работы:
 - [Lab01. Проектирование адресного пространства](lab01/)
 - [Lab02. Underlay. OSPF](lab02/)
 - [Lab03. Underlay. ISIS](lab03/)
 - [Lab04. Underlay. BGP](lab04/)
 - [Lab05. Overlay. L2VPN](lab05/)
 - [Lab06. Overlay. L3VPN](lab06/)
 - [Lab06.1 FRR network](lab06.1/)
 - [Lab07. Multihoming](lab07/)
 - [Lab08. EVPN. Routing](lab08/)

### Используемые инструменты:
 - [Containerlab](https://containerlab.dev/)
Инструкция по установке [тут](https://containerlab.dev/install/)
 - [FRR](https://frrouting.org/)
 - [Arista cEOS](https://www.arista.com/en/products/cEOS)

## Codespace

Для запуска лабораторных работ можно использовать Codespace. [Тык](https://codespaces.new/mrgrin-93/otus_dc_design?quickstart=1)

> [!TIP]
> Без образа (lab04-08) работать не будет, поэтому сначала нужно скачать образ на сайте [arista](https://www.arista.com/en/support/software-download), а затем перетащить его в Codespace (Простым drag&drop).
> После этого выполнить в териминале
> ```
> docker import '/workspaces/otus_dc_design/cEOS-lab-4.34.2F.tar.xz' ceos:4.34.2f
> ```

> [!WARNING]
> В образе используется старый clab, поэтому первым делом в консоли запустите
>
> ```
> sudo clab version upgrade
> ```

### Containerlab
В образе установлен плагин для управления лабораторными работами containerlab. Запускать работы лучше с помощью
```
bash run.sh
```
из директории лабораторной работы, так как необходимо настроить контейнеры linux.
