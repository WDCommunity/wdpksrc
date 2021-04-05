#!/usr/bin/env python3
import cgitb

cgitb.enable()

import cgi
import os
import re
import subprocess
import sys
import urllib.parse

os.environ["PATH"] = os.path.pathsep.join(["/opt/bin", os.environ["PATH"]])
REQUEST_METHOD = os.environ["REQUEST_METHOD"]
QUERY_STRING = os.environ["QUERY_STRING"]


def is_post():
    return REQUEST_METHOD == "POST"


def get_package_name(qs):
    package_name = qs.get("package_name", [])
    package_name = package_name[0] if package_name else ""

    if not re.match(r"^\w+$", package_name):
        print(f"Invalid package name {package_name!r}")
        exit(1)

    return package_name


def print_output(output):
    for line in output.decode().splitlines():
        print(f"<p>{line}</p>")


def search(qs):
    package_name = get_package_name(qs)
    output = subprocess.check_output(["opkg", "find", f"{package_name}*"])
    print_output(output)


def install_remove(qs, method):
    package_name = get_package_name(qs)
    output = subprocess.check_output(["opkg", method, f"{package_name}"])
    print_output(output)
    print("Done")


def install(qs):
    install_remove(qs, "install")


def remove(qs):
    install_remove(qs, "remove")


def list_installed(_):
    output = subprocess.check_output(["opkg", "list-installed"])
    print(output.decode().replace("\n", "<br>"))


FUNCTIONS = {
    "search": search,
    "install": install,
    "remove": remove,
    "list-installed": list_installed,
}


def handle():
    print("Content-type: text/html\n\n")
    if not is_post():
        print("Must be post")
        exit(0)

    qs = urllib.parse.parse_qs(QUERY_STRING)
    method = qs.get("method", [])
    method = method[0] if method else ""
    if method not in FUNCTIONS:
        print(f"Invalid method {method!r}")

    FUNCTIONS[method](qs)


handle()
exit(0)
