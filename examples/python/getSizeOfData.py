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
    daySize = {}

    if 'KeyMR' in json_return_data:
        keymr = json_return_data['KeyMR']
        # now we have the DB chain head.  we can follow it back until we get to the genesis block
        
        #use to shorten the seek time
        #keymr = '607a202dc993ff5ebe0bff902298ac5437ae3d6d7a3427fdb3cdc7a009156f5d'
        #keymr = '114146a5281ed9cf83b9b0a72d183463fec8854e1701a92225a983bac8866ea0'

        # keep looping until we find the genesis block
        # the genesis block has a previous keymr of all zeros
        while keymr != '0000000000000000000000000000000000000000000000000000000000000000':
            # Get the Directory Block identified by the KeyMR
            url = "http://localhost:8088/v1/directory-block-by-keymr/" + keymr
            web_response = requests.get(url)
            json_return_data = json.loads(web_response.text)
            # find out what the preceding directory block was
            keymr = json_return_data['Header']['PrevBlockKeyMR']

            for i in json_return_data['EntryBlockList']:
                if i['ChainID'] != '000000000000000000000000000000000000000000000000000000000000000a' \
                    and i['ChainID'] != '000000000000000000000000000000000000000000000000000000000000000c' \
                        and i['ChainID'] != '000000000000000000000000000000000000000000000000000000000000000f':
                    dayNum = (json_return_data['Header']['Timestamp'])/60/60/24

                    url = "http://localhost:8088/v1/entry-block-by-keymr/" + str(i['KeyMR'])
                    web_response = requests.get(url)
                    json_return_entry_data = json.loads(web_response.text)
                    for j in json_return_entry_data['EntryList']:
                        #print j
                        url = "http://localhost:8088/v1/entry-by-hash/" + str(j['EntryHash'])
                        web_response = requests.get(url)
                        json_return_entryhash_data = json.loads(web_response.text)
                        entsize = 0
                        if json_return_entryhash_data['ExtIDs'] is not None:
                            for k in json_return_entryhash_data['ExtIDs']:
                                entsize += len(k)/2
                        entsize += len(json_return_entryhash_data['Content'])/2
                        
                        dayTotals = 0
                        if dayNum in daySize:
                            dayTotals = daySize[dayNum]
                        dayTotals += entsize
                        daySize[dayNum] = dayTotals
        for d, s in daySize.iteritems():
            print str(d) + "," + str(s)

def main():
    print "reading from the Factom API"
    all_chainids_that_exist = all_chains_made_by_chainID()


if "__main__" == __name__:
        main()
