#!/usr/bin/env python
# Write Factom Entry API
 
# This software shows how to write data to an already created chain with the Factom API in Python
 
# This software is MIT licensed, Copyright 2015 Factom Foundation.
 
# sudo apt-get install python-pip
# sudo apt-get install python-dev
# sudo pip install ed25519
# sudo pip install base58
 
# factomd should be running on the local computer
 
import requests
import json
import time
import ed25519
import base58
import hashlib
import struct
 
# replace this private key with a 32 byte hex string which is random
privateECKey = "8961efd2ecbaaa835dc89249be8f46caacb30628f1c90a1711a4de51341170a176803ef880899cbe53ac6063aa92f47fd82647b68b299b7fc775118cbea96e10"
 
# values to build an entry out of:
 
chainID ="9e54c63c6ccf2f1e7bb6e86a4e026b63c5665dca2b649c1cb407d2e39d7e83f3" #chain name thisIsAChainName
entryContent = "hello world4"
externalIDs = ["extid","anotherextid"]
 
# Factom constants:
prefixEC = "592a"
prefixECsecret = "5db6"
 
 
# this function returns the hex encoded Entry Credit public key based on
# the given privateECKey, which is a hex encoded string
def ec_addresses_hex():
    privatekey = ed25519.SigningKey(privateECKey.decode("hex"))
    pubkey = privatekey.get_verifying_key()
    return pubkey.to_ascii(encoding="hex")
 
 
# This function returns the human readable EC address for the private key.
# It contains a prefix and checksum, to detect typos.
# https://github.com/FactomProject/FactomDocs/blob/master/factomDataStructureDetails.md#human-readable-addresses
 
def ec_addresses_human():
    addr = prefixEC
    addr += ec_addresses_hex()
    check = hashlib.sha256(hashlib.sha256(addr.decode("hex")).digest()).digest()
    encoding = base58.b58encode(addr.decode("hex") + check[:4])
    return encoding
 
 
# This function returns the human readable EC private key, based on the hex value from above.
# It contains a prefix and checksum, to detect typos.
# https://github.com/FactomProject/FactomDocs/blob/master/factomDataStructureDetails.md#human-readable-addresses
 
def ec_secret_human():
    addr = prefixECsecret
    addr += privateECKey
    check = hashlib.sha256(hashlib.sha256(addr.decode("hex")).digest()).digest()
    encoding = base58.b58encode(addr.decode("hex") + check[:4])
    return encoding
 
 
# This function connects to a local factomd node and checks the balance for the Entry Credit address
 
def get_ec_balance():
    # connect to the local factomd instance
    try:
        url = "http://localhost:8088/v1/entry-credit-balance/" + ec_addresses_hex()
        web_response = requests.get(url)
        json_return_data = json.loads(web_response.text)
        return json_return_data["Response"]
 
    except requests.ConnectionError:
        print("Could not connect to the factomd local node.  Is factomd running?")
        return 0
 
 
# This function returns a hex encoded entry based on the values listed at the top
# https://github.com/FactomProject/FactomDocs/blob/master/factomDataStructureDetails.md#entry
 
def construct_entry():
    entry = "00"
    entry += chainID
 
    extIdLen = 0
    for e in externalIDs:
        extIdLen += len(e)
        extIdLen += 2
    encodeExtIDs = struct.pack('>H', extIdLen)
    entry += encodeExtIDs.encode("hex")
 
    for e in externalIDs:
        extidLen = struct.pack('>H', len(e))
        entry += extidLen.encode("hex")
        entry += e.encode("hex")
 
    entry += entryContent.encode("hex")
 
    print "entry:" + entry
 
    return entry
 
 
# this function returns a hex encoded Entry Hash
# https://github.com/FactomProject/FactomDocs/blob/master/factomDataStructureDetails.md#entry-hash
 
def get_entry_hash():
    entryb = construct_entry()
    interim = hashlib.sha512(entryb.decode("hex")).digest().encode("hex")
    interim += entryb
    return hashlib.sha256(interim.decode("hex")).digest().encode("hex")
 
 
# this function returns an integer describing the minimum number of entry credits this entry must pay
 
def num_entry_credits():
    entryLength = len(construct_entry())/2 # find the number of bytes the entry takes up
    entryLength -= 35  # the header doesn't count when paying for an entry
    entryLength += 1023 # make the division round up
    entryLength /= 1024 #
    return entryLength
 
 
# then builds the datastructure required to commit an entry, returning in hex format
 
def get_entry_commit():
    commit = "00"  # version
 
    millitime = int((time.time() + 76)* 1000)  # time() gives floating point, so this tries to be millisecond accurate
 
    millitimestamp = struct.pack('>Q', millitime)
 
    # add 6 LS bytes of the millitimestamp to the entry commit
    commit += millitimestamp.encode("hex")[4:]
 
    commit += get_entry_hash()
 
    ecRequired = struct.pack('b', 10)
    commit += ecRequired.encode("hex")
 
    signature = ed25519.SigningKey(privateECKey.decode("hex")).sign(commit.decode("hex"), encoding="hex")
    commit += ec_addresses_hex()
    commit += signature
       
    print "commit:" + commit
 
    return commit
 
 
# this function checks for a balance on the EC key and returns that balance
# next it forms an entry and its commit then posts this to the factomd api
 
def write_to_factomd():
    balance = get_ec_balance()
 
    if 0 < balance:
        print "\nWriting to the Factom API"
        headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
        commit = {}
        commit['CommitEntryMsg'] = get_entry_commit()
        r = requests.post("http://localhost:8088/v1/commit-entry", data=json.dumps(commit), headers=headers)
        print "commit gives status: " + str(r.status_code)
 
        time.sleep(2)
        reveal = {}
        reveal['Entry'] = construct_entry()
        r = requests.post("http://localhost:8088/v1/reveal-entry", data=json.dumps(reveal), headers=headers)
        print "reveal gives status: " + str(r.status_code)
 
 
def main():
    if "0000000000000000000000000000000000000000000000000000000000000000" == privateECKey:
        print "Warning, using a non-unique private key.  Your Entry Credits can be used by others."
        print "Change privateECKey in this script to a random number"
 
    print "\nAdd Entry Credits to this key: " + ec_addresses_human()
    print "It currently has a balance of " + str(get_ec_balance())
 
    write_to_factomd()
    print "wrote " + get_entry_hash()
    print entryContent
 
 
if "__main__" == __name__:
        main()