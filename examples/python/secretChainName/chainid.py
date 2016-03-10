import scrypt

#change this to something specific for your application
unique_message = "Moderately Secret Chain Name"

h1 = scrypt.hash(password = unique_message, salt="", N = 1048576, r = 8, p = 1, buflen = 32)

print h1.encode('hex')