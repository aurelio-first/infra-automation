# **Configuração de Rede no Proxmox com LACP e VLANs**

## **📌 Objetivo**
Documentar a configuração de rede com **LACP (802.3ad)**, **VLANs** e **bonding** em servidores HP DL360 Gen9 conectados a switches Dell PowerConnect 6224.

## **📜 Topologia**
- **Servidores Proxmox:** prxmx01 até prxmx05
- **Switches:** Dell PowerConnect 6224 (em stack)
- **LACP:** bond0 com 4 interfaces (2 em cada switch)
- **VLANs:**
    - Produção: 192.168.20.0/24
    - Infra: 192.168.15.0/24
    - Testes: 192.168.17.0/24

## **🚀 Passos**
1. Criar bond0 no Proxmox:
   ```bash
   nano /etc/network/interfaces
   ```
   ```
   auto bond0
   iface bond0 inet manual
       bond-slaves eno1 eno2 eno3 eno4
       bond-miimon 100
       bond-mode 802.3ad
       bond-xmit-hash-policy layer3+4
   ```

2. Configurar bridges para VLANs:
   ```
   auto vmbr20
   iface vmbr20 inet static
       address 192.168.20.10/24
       gateway 192.168.20.1
       bridge-ports bond0.20
       bridge-stp off
       bridge-fd 0
   ```

## **⚡ Automação via Script**
Script correspondente: `scripts/proxmox-networking.ps1`
