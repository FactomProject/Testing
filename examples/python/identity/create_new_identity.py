import hashlib
import base58
import ed25519
import os
import struct

key_priv_raw = []
for l in range(0, 4):
    key_priv_raw.append(os.urandom(32))

#key_priv_raw[0]="f84a80f204c8e5e4369a80336919f55885d0b093505d84b80d12f9c08b81cd5e".decode("hex")
#key_priv_raw[1]="2bb967a78b081fafef17818c2a4c2ba8dbefcd89664ff18f6ba926b55e00b601".decode("hex")
#key_priv_raw[2]="09d51ae7cc0dbc597356ab1ada078457277875c81989c5db0ae6f4bf86ccea5f".decode("hex")
#key_priv_raw[3]="72644033bdd70b8fec7aa1fea50b0c5f7dfadb1bce76aa15d9564bf71c62b160".decode("hex")

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

print "Identity creation element 1: " + "494430"
for x in range(0, 4):
    print "Identity creation element " + str(x+2) + ": " + key_pub_hash[x].encode("hex")
print "Identity creation element 6: " + "%016x" % nonce + "\n"





# Registration Message

registration_entry = []

# add version
registration_entry.append("00".decode("hex"))
# add disambiguation note
registration_entry.append("Register Factom Identity")
# specify which chainID to register
registration_entry.append(chainid)
# specify the key level of the identity
registration_entry.append("01".decode("hex"))
# reveal the pubkey at this level hashed into the identity
registration_entry.append("01".decode("hex") + key_pub[0].to_bytes())
# add the signature to authenticate the message

reg_message_payload = ""
for x in range(0, 5):
    print "Registration element " + str(x+1) + ": " + registration_entry[x].encode("hex")
for x in range(0, 3):
    reg_message_payload += registration_entry[x]
#print reg_message_payload.encode("hex")
sig = key_priv[0].sign(reg_message_payload)
print "Registration element 6: " + sig.encode("hex")








