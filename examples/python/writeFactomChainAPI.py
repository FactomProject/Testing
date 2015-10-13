# Write Factom Chain API

# This software shows how to create a new chain with the Factom API in Python

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
# run the code to find the Entry Credit address to buy credits for
privateECKey = "0000000000000000000000000000000000000000000000000000000000000000"

# values to build the first entry out of:

entryContent = "hello world"
chainName = ["FirstElement","2ndElement"]


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


# this function computes the ChainID from the chain name and returns it hex encoded

def get_chain_id():
    chainNameElementHashes = []
    for n in chainName:
        elementHash = hashlib.sha256(n).digest()
        chainNameElementHashes.append(elementHash)
    idPre = ""
    for e in chainNameElementHashes:
        idPre += e
    chainId = hashlib.sha256(idPre).digest()
    return chainId.encode("hex")


# This function returns a hex encoded first entry based on the values listed at the top
# The Chain name must be included in the extid fields in the entry.
# https://github.com/FactomProject/FactomDocs/blob/master/factomDataStructureDetails.md#entry

def construct_first_entry():
    entry = "00"

    entry += get_chain_id()

    extIdLen = 0
    for e in chainName:
        extIdLen += len(e)
        extIdLen += 2
    encodeExtIDs = struct.pack('>H', extIdLen)
    entry += encodeExtIDs.encode("hex")

    for e in chainName:
        extidLen = struct.pack('>H', len(e))
        entry += extidLen.encode("hex")
        entry += e.encode("hex")

    entry += entryContent.encode("hex")

    # print "entry: "  + entry
    return entry


# this function returns a hex encoded Entry Hash
# https://github.com/FactomProject/FactomDocs/blob/master/factomDataStructureDetails.md#entry-hash

def get_entry_hash():
    entryb = construct_first_entry()
    interim = hashlib.sha512(entryb.decode("hex")).digest().encode("hex")
    interim += entryb
    return hashlib.sha256(interim.decode("hex")).digest().encode("hex")


# this function returns an integer describing the minimum number of entry credits this entry must pay

def num_entry_credits():
    entryLength = len(construct_first_entry())/2 # find the number of bytes the entry takes up
    entryLength -= 35  # the header doesn't count when paying for an entry
    entryLength += 1023 # make the division round up
    entryLength /= 1024 #
    return entryLength


# this function builds the data structure used to reserve and pay for a chain

def get_chain_commit():
    commit = "00"  # version

    millitime = int(time.time() * 1000)  # time() gives floating point, so this tries to be millisecond accurate

    millitimestamp = struct.pack('>Q', millitime)

    # add 6 Least Significant bytes of the millitimestamp to the entry commit
    commit += millitimestamp.encode("hex")[4:]

    chainIdHash = hashlib.sha256(hashlib.sha256(get_chain_id().decode("hex")).digest()).digest().encode("hex")
    commit += chainIdHash

    weld = hashlib.sha256(hashlib.sha256((get_entry_hash() + get_chain_id()).decode("hex")).digest()).digest().encode("hex")
    commit += weld

    commit += get_entry_hash()

    ecRequired = struct.pack('b', (num_entry_credits()+10))
    commit += ecRequired.encode("hex")

    signature = ed25519.SigningKey(privateECKey.decode("hex")).sign(commit.decode("hex"), encoding="hex")
    commit += ec_addresses_hex()
    commit += signature
    # print "commit: " + commit

    return commit


# this function checks for a balance on the EC key and returns that balance
# next it forms an entry and its commit then posts this to the factomd api

def write_to_factomd():
    balance = get_ec_balance()

    if 0 < balance:
        print "\nWriting to the Factom API"
        print "requiring this many EC: " + str(num_entry_credits() + 10)
        print "entry is this many bytes: " + str(len(construct_first_entry())/2)
        headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
        commit = {}
        commit['CommitChainMsg'] = get_chain_commit()
        r = requests.post("http://localhost:8088/v1/commit-chain", data=json.dumps(commit), headers=headers)
        print "commit gives status: " + str(r.status_code)

        time.sleep(2)
        reveal = {}
        reveal['Entry'] = construct_first_entry()
        r = requests.post("http://localhost:8088/v1/reveal-chain", data=json.dumps(reveal), headers=headers)
        print "reveal gives status: " + str(r.status_code)


def main():
    if "0000000000000000000000000000000000000000000000000000000000000000" == privateECKey:
        print "Warning, using a non-unique private key.  Your Entry Credits can be used by others."
        print "Change privateECKey in this script to a random number"

    print "\nAdd Entry Credits to this key: " + ec_addresses_human()
    print "It currently has a balance of " + str(get_ec_balance())

    write_to_factomd()
    print "made chain " + get_chain_id()
    print "wrote entry with hash " + get_entry_hash()
    # print entryContent


if "__main__" == __name__:
        main()
