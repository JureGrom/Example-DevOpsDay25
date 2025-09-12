#!/bin/bash
# Update and install necessary dependencies
apt-get update
apt-get install -y redis-server postgresql-16

# Configure Redis
sudo sed -i 's/^bind .*/bind 0.0.0.0/' /etc/redis/redis.conf
sudo sed -i 's/^protected-mode .*/protected-mode no/' /etc/redis/redis.conf

# Configure PostgreSQL
sudo sed -i "s/^#\?listen_addresses *= *.*/listen_addresses = '*'/" /etc/postgresql/16/main/postgresql.conf
echo "host    all    all    10.0.0.0/8    password" | sudo tee -a /etc/postgresql/16/main/pg_hba.conf

# Enable and start Redis and PostgreSQL
systemctl enable redis-server
systemctl restart redis-server

systemctl enable postgresql
systemctl restart postgresql

sudo -u postgres psql <<EOF
CREATE USER demo_user WITH PASSWORD 'demo_user';
CREATE DATABASE demo OWNER demo_user;
EOF
