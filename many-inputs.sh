factom-cli generateaddress fct factoid-wallet-address-name01 | awk '{print $3}'
factom-cli generateaddress fct factoid-wallet-address-name02 | awk '{print $3}'
factom-cli generateaddress ec ec-wallet-address-name01 | awk '{print $3}'
factom-cli getaddresses

factom-cli newtransaction transaction09
for ((i=0; i < 10; i++)); do
    j=`echo "scale=8;1+$i/100" | bc`
    factom-cli addinput transaction09 factoid-wallet-address-name01 $j
done
factom-cli addoutput transaction09 factoid-wallet-address-name02 3.33333333
factom-cli addecoutput transaction09 ec-wallet-address-name01 6
factom-cli sign transaction09
factom-cli submit transaction09
factom-cli getaddresses

for ((i=0; i < 100; i++)); do
    echo "scale=8;1+$i/100" | bc
done

for ((i=0; i < 100; i++)); do
    j=`echo "scale=8;1+$i/100" | bc`
    echo $j
done





