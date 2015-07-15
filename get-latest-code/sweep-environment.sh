rm -r /tmp/ldb* 
rm -r /tmp/store
rm -r ~/.factom/data/factoid0/
rm -r /tmp/wallet
rm -r /tmp/*bolt.db
rm -rf ~/go/pkg
rm -rf ~/go/bin
cd ~/go/src/github.com/FactomProject/FactomCode
./all.sh development

