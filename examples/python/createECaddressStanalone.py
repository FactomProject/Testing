import sys
sys.path.append('libs')
import hashlib
import base58
import ed25519djb as ed25519
import os


# get a 32 byte random number.  This is the raw ed25519 private key
ECprivatekey = os.urandom(32)

# if using an existing private key, uncomment and add your key here
#ECprivatekey = "0000000000000000000000000000000000000000000000000000000000000000".decode("hex")

# get the matching public key for the random private key
Ed25519PrivateKey = ECprivatekey
Ed25519PublicKey = ed25519.publickey(Ed25519PrivateKey)


print "raw private key:" + ECprivatekey.encode("hex")
print "raw public key: " + Ed25519PublicKey.encode("hex")



# convert the private key to human readable form

# this is a magic number to make the first two letters be Es
privatePrefix = "5db6"

interimAddress = privatePrefix + ECprivatekey.encode("hex")
checksum = hashlib.sha256(hashlib.sha256(interimAddress.decode("hex")).digest()).digest()
b58encoding = base58.b58encode(interimAddress.decode("hex") + checksum[:4])

print "human readable Private Key: " + b58encoding




# convert the public key to human readable form

# this is a magic number to make the first two letters be EC
publicPrefix = "592a"

interimAddress = publicPrefix + Ed25519PublicKey.encode("hex")
checksum = hashlib.sha256(hashlib.sha256(interimAddress.decode("hex")).digest()).digest()
b58encoding = base58.b58encode(interimAddress.decode("hex") + checksum[:4])

print "human readable Public Key:  " + b58encoding




