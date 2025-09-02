<#
.SYNOPSIS
    Configura bonding LACP e VLANs no Proxmox.
.DESCRIPTION
    Aplica configuração de rede automatizada.
.PARAMETER Host
    Nome do host Proxmox.
.EXAMPLE
    .\proxmox-networking.ps1 -Host prxmx01
.NOTES
    Autor: Aurelio Martins
    Data: 2025-09-02
#>

param (
    [string]$Host = "prxmx01"
)

Write-Host "Configurando rede no Proxmox: $Host" -ForegroundColor Cyan
