#!/bin/bash
echo "====================================="
echo "=        RESTARTING B2Docker        ="
echo "====================================="
#boot2docker stop
#boot2docker delete
#boot2docker init
#boot2docker start

echo "====================================="
echo "=        BUILDING DSE               ="
echo "====================================="
docker build --tag="dse" dse
sleep 3
docker run -d --name="dse01" dse
sleep 10
echo "====================================="
echo "=      BUILDING ELASTICSEARCH       ="
echo "====================================="
docker build --tag="elasticsearch:0.1.0" elasticsearch
sleep 3
docker run -d -p 9200:9200 -p 9300:9300 --name='es01' elasticsearch:0.1.0
sleep 10
echo "====================================="
echo "=         BUILDING CYANITE          ="
echo "====================================="
docker build --tag="cyanite:0.1.0" cyanite
sleep 3
docker run -d -p 2003:2003 --name="cyanite01" --link dse01:dse01 cyanite:0.1.0 
sleep 10
echo "====================================="
echo "=         BUILDING GRAPHITE         ="
echo "====================================="
docker build --tag="graphite01" graphite_api
sleep 3
docker run -d -p 8000:8000 -p 80:80 --link cyanite01:cyanite01 --name "graphite01" graphite01 
sleep 10
echo "====================================="
echo "=         BUILDING GRAFANA         ="
echo "====================================="
docker build --tag="grafana" grafana
sleep 3
docker run -d -p 3000:3000 --link graphite01:graphite01 --name "grafana" grafana
sleep 10
echo "====================================="
echo "=              ALL DONE             ="
echo "====================================="
