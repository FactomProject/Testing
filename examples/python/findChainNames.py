# Read Factom API

# This software shows how to do various types of reads with the Factom API in Python.
# This particular program reads data interesting to Factom.  
# The concepts should be adapted to find data interesting to your application.
# It is not production code, it is mostly for shwing the API and how to use it to find your data.

# This software is MIT licensed, Copyright 2015 Factom Foundation.

import requests
import json
import time
import re


def all_chains_made_by_chainID():
    all_chainids = []

    # connect to the local factomd instance
    try:
        web_response = requests.get("http://localhost:8088/v1/directory-block-head")
    except requests.ConnectionError:
        print("Could not connect to the factomd local node.  Is factomd running?")
        return False

    # Get the KeyMR (unique identifying hash) of what factomd thinks is the latest directory block
    json_return_data = json.loads(web_response.text)

    if 'KeyMR' in json_return_data:
        keymr = json_return_data['KeyMR']
        # now we have the DB chain head.  we can follow it back until we get to the genesis block

        # keep looping until we find the genesis block
        # the genesis block has a previous keymr of all zeros
        while keymr != '0000000000000000000000000000000000000000000000000000000000000000':
            # Get the Directory Block identified by the KeyMR
            url = "http://localhost:8088/v1/directory-block-by-keymr/" + keymr
            web_response = requests.get(url)
            json_return_data = json.loads(web_response.text)
            # find out what the preceding directory block was
            keymr = json_return_data['Header']['PrevBlockKeyMR']
            #print "KeyMR of the earlier Directory Block: " + keymr
            # identify and save the chainIDs which were updated during the specified directory block
            add_new_chainid(json_return_data['EntryBlockList'], all_chainids)
            #print json_return_data['Header']['SequenceNumber']
        return all_chainids


# given a list of chainIDs in a directory block, and a list of previously found chainIDs
# add the new ones to the list
# ignore the _A_dministrative, entry _C_redit, and _F_actoid blocks
def add_new_chainid(current_list, cumulative_list):
    for i in current_list:
        if i['ChainID'] not in cumulative_list:
            if i['ChainID'] != '000000000000000000000000000000000000000000000000000000000000000a' \
                and i['ChainID'] != '000000000000000000000000000000000000000000000000000000000000000c' \
                    and i['ChainID'] != '000000000000000000000000000000000000000000000000000000000000000f':
                cumulative_list.append(i['ChainID'])


# given an existing chainID, return the entry hash of the first entry in that chain
def get_first_entry(chainid):
    try:
        # get the keyMR of the latest entry block with the specified chainID
        url = "http://localhost:8088/v1/chain-head/" + chainid
        web_response = requests.get(url)
        json_return_data = json.loads(web_response.text)
        #print json_return_data

        keymr = json_return_data['ChainHead']

        # keep chasing the entry blocks back until we get the the first one
        # the first entry block of each chain has a previous keymr of all zeros
        while keymr != '0000000000000000000000000000000000000000000000000000000000000000':
            # Get the Entry Block identified by the KeyMR
            url = "http://localhost:8088/v1/entry-block-by-keymr/" + keymr
            web_response = requests.get(url)
            json_return_data = json.loads(web_response.text)
            print json_return_data
            # find out what the preceding entry block was
            keymr = json_return_data['Header']['PrevKeyMR']

        # We have iterated through all the entry blocks and found the first block of the chain
        # The first entry of the chain will be the first one in the entry list.
        # There will always be at least 1 entry per entry block
        return json_return_data['EntryList'][0]['EntryHash']

    except:
        return '0000000000000000000000000000000000000000000000000000000000000000'


# Takes in a list of the hashes of the First Entry in a chain.
# Returns a list of lists of the ChainID paired with the chain name elements (themselves in a list).
def extract_chain_name(entry_hashes):
    name_elements = []

    for h in entry_hashes:
        url = "http://localhost:8088/v1/entry-by-hash/" + h
        web_response = requests.get(url)
        json_return_data = json.loads(web_response.text)
        chainid_pair = []
        chainid_pair.append(h)
        chainid_pair.append(json_return_data['ExtIDs'])
        name_elements.append(chainid_pair)

    return name_elements


def print_name_list(name_list):
    for n in name_list:
        name = ""
        for s in n[1]:
			# strip off non-ascii printable characters for display.  also strips unicode, sorry europe, asia... everywhere else.
            name += re.sub('[^\040-\176]', '', str(s.decode("hex")))
            name += "/"
        print "ChainID " + str(n[0]) + " is " + name


def main():
    print "reading from the Factom API"
    all_chainids_that_exist = all_chains_made_by_chainID()
    all_chainids_that_exist.sort()
    print "all chainIDs " +  str(all_chainids_that_exist)

    first_entries = []
    for i in all_chainids_that_exist:
        first_entries.append(get_first_entry(i))

    print "all first entries " + str(first_entries)

    print "Chain Names: " + str(extract_chain_name(first_entries))

    print_name_list(extract_chain_name(first_entries))


if "__main__" == __name__:
        main()
