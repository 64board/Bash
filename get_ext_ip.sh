#!/bin/bash

# Check which is your external IP.
# janeiros@mbfcc.com
# 2026.05.16

# curl ifconfig.me
# curl icanhazip.com
# curl api.ipify.org

# In case curl is not available:

# wget -qO- ifconfig.me

# Using dig (fastest no HTTP)

# +short: By default, dig is very verbose and returns a massive wall of network text.
# This flag tells dig to shut up and only give you the exact answer to your question—
# in this case, just your IP address.

# txt: This specifies the type of DNS record you are looking for. Usually, you look for
# A records (which turn a name like google.com into an IP). A TXT record is just raw,
# arbitrary text. Cloudflare uses a text record to pass your IP back to you.

# ch: This stands for the Chaosnet class. While 99% of internet traffic uses the IN
# (Internet) class, some network tools use the historical Chaosnet class for local
# server information and diagnostics.

# whoami.cloudflare: This is the specific zone/domain name you are querying.
# Cloudflare has programmed their servers so that if anyone asks for "whoami",
# the server looks at the incoming connection, grabs the public IP it came from,
# and spits it right back.

# @1.1.1.1: This forces dig to ask Cloudflare's public DNS server (1.1.1.1) directly,
# rather than asking your local home router or your ISP's DNS server.

dig +short txt ch whoami.cloudflare @1.1.1.1

##END##
