#!/bin/bash

set -u

site="$(meteor mongo $1 --url)"

# extract the protocol
proto="$(echo $site | grep :// | sed -e's,^\(.*://\).*,\1,g')"
# remove the protocol
url="$(echo ${site/$proto/})"
# extract the user and password (if any)
user_pass="$(echo $url | grep @ | cut -d@ -f1)"
# extract the user (if any)
user="$(echo $user_pass | grep : | cut -d: -f1)"
# extract the password (if any)
password="$(echo $user_pass | grep : | cut -d: -f2-)"
# extract the host with port
host_port="$(echo ${url/$user_pass@/} | cut -d/ -f1)"

# extract the user (if any)
host="$(echo $host_port | grep : | cut -d: -f1)"
# extract the password (if any)
port="$(echo $host_port | grep : | cut -d: -f2-)"

# extract the path (if any)
db="$(echo $url | grep / | cut -d/ -f2-)"

echo "url: $url"
echo "  proto: $proto"
echo "  user: $user"
echo "  password: $password"
echo "  host: $host"
echo "  port: $port"
echo "  db: $db"

mongodump -h "$host" --port "$port" --username "$user" --password "$password" -d "$db"
