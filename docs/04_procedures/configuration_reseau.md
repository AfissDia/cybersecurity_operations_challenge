# Configuration réseau

## Objectif

Séparer l'accès Internet du réseau interne utilisé par les composants du SOC.

## VirtualBox

Adaptateur 1 :
- Mode : NAT
- Usage : accès Internet

Adaptateur 2 :
- Mode : Réseau interne
- Nom : SOC-NET
- Usage : communication entre les composants du SOC

## ES-NODE-01

Adresse SOC :

192.168.100.10/24

## ES-NODE-02

Adresse SOC :

192.168.100.11/24

## Vérification

Depuis ES-NODE-01 :

```bash
ping -c 4 192.168.100.11