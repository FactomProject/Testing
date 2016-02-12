import hashlib
import base58
import ed25519
import os
import struct

key_priv_raw = []
for l in range(0, 4):
    key_priv_raw.append(os.urandom(32))

key_priv=[]
for key in key_priv_raw:
    key_priv.append(ed25519.SigningKey(key))

key_pub=[]
for key in key_priv:
    key_pub.append(key.get_verifying_key())
    
pre = "01".decode("hex")

key_pub_hash=[]
for key in key_pub:
    key_pub_hash.append(hashlib.sha256(hashlib.sha256(pre + key.to_bytes()).digest()).digest())

#print key_pub_hash[0].encode("hex")

id_b58_prefix_priv = ["4db6c9", "4db6e7", "4db705", "4db723"]
id_b58_prefix_pub = ["3fbeba", "3fbed8", "3fbef6", "3fbf14"]

for x in range(0, 4):
    intkey = id_b58_prefix_priv[x].decode("hex") + key_priv_raw[x]
    checksum = hashlib.sha256(hashlib.sha256(intkey).digest()).digest()
    b58encoding = base58.b58encode(intkey + checksum[:4])
    print "Level" + str(x+1) + " " + b58encoding

    intpub = id_b58_prefix_pub[x].decode("hex") + key_pub_hash[x]
    checksum = hashlib.sha256(hashlib.sha256(intpub).digest()).digest()
    b58encoding = base58.b58encode(intpub + checksum[:4])
    print "Level" + str(x+1) + " " + b58encoding
    print ""


# Build the First Entry
elements = []
elements.append(hashlib.sha256("ID0").digest())
for x in range(0, 4):
    elements.append(hashlib.sha256(key_pub_hash[x]).digest())

first5 = ""
for e in elements:
    first5 += e

targetprefix = "888888".decode("hex")

nonce = 0
while 1:
    nonce += 1
    n=struct.pack('>Q',nonce)
    sixth = hashlib.sha256(n).digest()
    chainid = hashlib.sha256(first5 + sixth).digest()
    if chainid.startswith(targetprefix):
        break #found an identity which is valid

print "Identity ChainID: " + chainid.encode("hex") + "\n"

print "Element 1: " + "494430"
for x in range(0, 4):
    print "Element " + str(x+2) + ": " + key_pub_hash[x].encode("hex")
print "Element 6: " + "%016x" % nonce

