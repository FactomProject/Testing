This code, combined with a fully indexed btcd node, as specified in the factom.conf file, will display some diagnostics about the anchors.

Modify the code based on the data at the top of the anchorCheck.go file.

It panics when it cannot connect to a btcd node, so check the port numbers and passwords carefully.

to start btcd with indexing run this command: "btcd --addrindex --testnet"

