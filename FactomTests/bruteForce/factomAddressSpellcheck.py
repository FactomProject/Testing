import hashlib
import base58

#Place the mostly correct address here:
address = "FA2dddddddddddddddddddddddddddddddddddddddddddddddd"

print address

if len(address) == 52:
    for i, let in enumerate(address):
	for r in base58.alphabet:
	    t = address[:i] + r + address[i+1:]
	    #print t
	    dec = base58.b58decode(t)
	    rcd = dec[:34]
	    checksum = hashlib.sha256(hashlib.sha256(rcd).digest()).digest()
	    if checksum[:4] == dec[34:]:
		print t
		print " " * (i-1),
		print "^"

elif len(address) == 51:
    for i, let in enumerate(address):
	for r in base58.alphabet:
	    t = address[:i] + r + address[i:]
	    #print t
	    dec = base58.b58decode(t)
	    rcd = dec[:34]
	    checksum = hashlib.sha256(hashlib.sha256(rcd).digest()).digest()
	    if checksum[:4] == dec[34:]:
		print t
		print " " * (i-1),
		print "^"

else :
    print "need 51 or 52 characters, you gave " + len(address)
    
    
