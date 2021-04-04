#!/usr/bin/env python3
import cgitb
import re
cgitb.enable()
import cgi
import os
import subprocess

print('Content-type: text/plain')
print('')

def list_networks():
    print('<pre>')
    print('command output')
    output = subprocess.check_output(["/opt/bin/zerotier-cli", "listnetworks"])
    print(output.decode('utf-8'))
    print('</pre>')


def join_network():
    print('<pre>')
    form = cgi.FieldStorage()
    network_name = form['network_name'].value.strip()
    match = re.match('^[0-9a-f]+$', network_name)
    if not match:
        print(f'Not a valid network name {network_name!r}')
        exit(0)

    print(f'trying to join {network_name!r}')
    output = subprocess.check_output(["/opt/bin/zerotier-cli", "join", network_name])
    print(output.decode('utf-8'))
    print('</pre>')

if os.environ['REQUEST_METHOD'] != 'GET':
    join_network()
    exit(0)

list_networks()
