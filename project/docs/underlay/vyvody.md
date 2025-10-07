# Выводы

В целом при выборе протокола и в андерлей, и в оверлей лучше выбирать то, что предлагает вендор.

Arista, например, видит BGP  и в оверлее и в андерлее ([rfc 7938](https://www.protokols.ru/WP/wp-content/uploads/2016/08/rfc7938.pdf)).

А вот Cisco считает

> A famous **informational** RFC 7938
>
> A vital concluding point on this informational RFC 7938 is that it does not discuss or propose using eBGP as an underlay routing protocol in a VXLAN BGP EVPN fabric or any overlay running in the data center. Therefore, referencing this informational RFC 7938 is not a strong argument for using eBGP as an underlay in VXLAN BGP EVPN fabrics.

Nokia в своем [validated design](https://github.com/nokia/nokia-validated-designs/tree/main/validated-designs/3-stage-evpn-vxlan/3-stage-evpn-vxlan-clab-without-eda) вообще на одном ebgp на ll ipv6 (без установления соседства с lo интерфейсам) делает всё. (Или соединяют [2 спайна](https://github.com/nokia/nokia-validated-designs/tree/main/validated-designs/collapsed-spine/collapsed-spine-without-eda), а лифы оставляют как аксесы)
