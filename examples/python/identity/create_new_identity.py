import hashlib
import base58
import ed25519
import os
import struct

key_priv_raw = []
for l in range(0, 4):
    key_priv_raw.append(os.urandom(32))

key_priv_raw[0]="f84a80f204c8e5e4369a80336919f55885d0b093505d84b80d12f9c08b81cd5e".decode("hex")
key_priv_raw[1]="2bb967a78b081fafef17818c2a4c2ba8dbefcd89664ff18f6ba926b55e00b601".decode("hex")
key_priv_raw[2]="09d51ae7cc0dbc597356ab1ada078457277875c81989c5db0ae6f4bf86ccea5f".decode("hex")
key_priv_raw[3]="72644033bdd70b8fec7aa1fea50b0c5f7dfadb1bce76aa15d9564bf71c62b160".decode("hex")

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
elements.append(hashlib.sha256("00".decode("hex")).digest())
elements.append(hashlib.sha256("4964656E7469747920436861696E".decode("hex")).digest())
for x in range(0, 4):
    elements.append(hashlib.sha256(key_pub_hash[x]).digest())

first6 = ""
for e in elements:
    first6 += e

targetprefix = "888888".decode("hex")

nonce = 0
while 1:
    nonce += 1
    n=struct.pack('>Q',nonce)
    seventh = hashlib.sha256(n).digest()
    chainid = hashlib.sha256(first6 + seventh).digest()
    if chainid.startswith(targetprefix):
        break #found an identity which is valid

print "Identity ChainID: " + chainid.encode("hex") + "\n"

print "Identity creation element 1: " + "00"
print "Identity creation element 2: " + "4964656E7469747920436861696E"
for x in range(0, 4):
    print "Identity creation element " + str(x+3) + ": " + key_pub_hash[x].encode("hex")
print "Identity creation element 7: " + "%016x" % nonce + "\n"





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
print "Registration element 6: " + sig.encode("hex") + "\n"




# Server Management Subchain
elements_man = []
elements_man.append(hashlib.sha256("00".decode("hex")).digest())
elements_man.append(hashlib.sha256("536572766572204D616E6167656D656E74".decode("hex")).digest())
elements_man.append(hashlib.sha256(chainid).digest())

first3 = ""
for e in elements_man:
    first3 += e

nonce = 0x9876543210000000
while 1:
    nonce += 1
    n=struct.pack('>Q',nonce)
    fourth = hashlib.sha256(n).digest()
    chainid_man = hashlib.sha256(first3 + fourth).digest()
    if chainid_man.startswith(targetprefix):
        break #found an identity which is valid

print "Server Management ChainID: " + chainid_man.encode("hex") + "\n"

print "Server Management element 1: " + "00"
print "Server Management element 2: " + "536572766572204D616E6167656D656E74"
print "Server Management element 3: " + chainid.encode("hex")
print "Server Management element 4: " + "%016x" % nonce + "\n"




# Server Management Subchain Registration Message

srv_man_registration_entry = []

# add version
srv_man_registration_entry.append("00".decode("hex"))
# add disambiguation note
srv_man_registration_entry.append("Register Server Management")
# specify which chainID to register
srv_man_registration_entry.append(chainid_man)
# specify the key level of the identity
srv_man_registration_entry.append("01".decode("hex"))
# reveal the pubkey at this level hashed into the identity
srv_man_registration_entry.append("01".decode("hex") + key_pub[0].to_bytes())
# add the signature to authenticate the message

srv_reg_message_payload = ""
for x in range(0, 5):
    print "Server Registration element " + str(x+1) + ": " + srv_man_registration_entry[x].encode("hex")
for x in range(0, 3):
    srv_reg_message_payload += srv_man_registration_entry[x]
#print srv_reg_message_payload.encode("hex")
sig = key_priv[0].sign(srv_reg_message_payload)
print "Server Registration element 6: " + sig.encode("hex") + "\n"


# Add New Block Signing Key

block_signing_pubkey = ed25519.SigningKey("e0e92721e80180627244bf182b2c04b71925ab7b991fddc5deecf47db6f94dbc".decode("hex")).get_verifying_key()


new_block_key_entry = []

# add version
new_block_key_entry.append("00".decode("hex"))
# add disambiguation note
new_block_key_entry.append("New Block Signing Key")
# specify which chainID this belongs to
new_block_key_entry.append(chainid)
# specify the new block signing pubkey
new_block_key_entry.append(block_signing_pubkey.to_bytes())
# add the timestamp
new_block_key_entry.append("00000000495EAA80".decode("hex"))
# specify the key level of the identity
new_block_key_entry.append("01".decode("hex"))
# reveal the pubkey at this level hashed into the identity
new_block_key_entry.append("01".decode("hex") + key_pub[0].to_bytes())
# add the signature to authenticate the message

new_block_key_message_payload = ""
for x in range(0, 7):
    print "New Block Signing Key element " + str(x+1) + ": " + new_block_key_entry[x].encode("hex")
for x in range(0, 5):
    new_block_key_message_payload += new_block_key_entry[x]
#print new_block_key_message_payload.encode("hex")
sig = key_priv[0].sign(new_block_key_message_payload)
print "New Block Signing Key element 8: " + sig.encode("hex") + "\n"







# Add New Bitcoin Key

new_bitcoin_key_entry = []

# add version
new_bitcoin_key_entry.append("00".decode("hex"))
# add disambiguation note
new_bitcoin_key_entry.append("New Bitcoin Key")
# specify which chainID this belongs to
new_bitcoin_key_entry.append(chainid)
# bitcoin key level
new_bitcoin_key_entry.append("01".decode("hex"))
# add bitcoin key type
new_bitcoin_key_entry.append("00".decode("hex"))
# add bitcoin pubkey
new_bitcoin_key_entry.append("C5B7FD920DCE5F61934E792C7E6FCC829AFF533D".decode("hex"))
# add the timestamp
new_bitcoin_key_entry.append("00000000495EAA80".decode("hex"))
# specify the key level of the identity
new_bitcoin_key_entry.append("01".decode("hex"))
# reveal the pubkey at this level hashed into the identity
new_bitcoin_key_entry.append("01".decode("hex") + key_pub[0].to_bytes())
# add the signature to authenticate the message

new_bitcoin_key_message_payload = ""
for x in range(0, 9):
    print "New Bitcoin Key element " + str(x+1) + ": " + new_bitcoin_key_entry[x].encode("hex")
for x in range(0, 7):
    new_bitcoin_key_message_payload += new_bitcoin_key_entry[x]
#print new_bitcoin_key_message_payload.encode("hex")
sig = key_priv[0].sign(new_bitcoin_key_message_payload)
print "New Bitcoin Key element 10: " + sig.encode("hex") + "\n"




# Add New M-Hash
new_mhash_entry = []

# add version
new_mhash_entry.append("00".decode("hex"))
# add disambiguation note
new_mhash_entry.append("New Matryoshka Hash")
# specify which chainID this belongs to
new_mhash_entry.append(chainid)
# specify the new outermost m-hash
new_mhash_entry.append("bf1e78e5755851242a2ebf703e8bf6aca1af9dbae09ebc495cd2da220e5d370f".decode("hex"))
# add the timestamp
new_mhash_entry.append("00000000495EAA80".decode("hex"))
# specify the key level of the identity
new_mhash_entry.append("01".decode("hex"))
# reveal the pubkey at this level hashed into the identity
new_mhash_entry.append("01".decode("hex") + key_pub[0].to_bytes())
# add the signature to authenticate the message

new_mhash_message_payload = ""
for x in range(0, 7):
    print "New M-Hash element " + str(x+1) + ": " + new_mhash_entry[x].encode("hex")
for x in range(0, 5):
    new_mhash_message_payload += new_mhash_entry[x]
#print new_mhash_message_payload.encode("hex")
sig = key_priv[0].sign(new_mhash_message_payload)
print "New M-Hash element 8: " + sig.encode("hex") + "\n"



