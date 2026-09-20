# Installation Elasticsearch

Version déployée : Elasticsearch 9.5.4

## Dépendances


```bash
sudo apt update
sudo apt install apt-transport-https wget gnupg -y


## Clé du dépôt
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch \
| sudo gpg --dearmor \
-o /usr/share/keyrings/elasticsearch-keyring.gpg

## Dépôt Elastic
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/9.x/apt stable main" \
| sudo tee /etc/apt/sources.list.d/elastic-9.x.list

## Installation
sudo apt update
sudo apt install elasticsearch -y

## Vérification
/usr/share/elasticsearch/bin/elasticsearch --version

## Résultat obtenu :

Elasticsearch 9.5.4
