cd ~/robertubuntu/testing/test-plans-and-scripts/Robert-API/full/Google-Plan-and-Script/history
mkdir $1
cd $1
mv ~/Downloads/"FactomAPITestScript.odt" "Factom API Test Script $1.odt"
sha256sum "Factom API Test Script $1.odt" >"Factom API Test Script $1.odt.hash"
cat "Factom API Test Script $1.odt.hash"
gpg --clearsign "Factom API Test Script $1.odt.hash"
cat "Factom API Test Script $1.odt.hash.asc"
factom-cli put -e "Factom API Test Script $1.odt" -c 71fecdd33ea55b9608863782da1fc158b69e0cc8f283620bac670578a5603645 ec-wallet-address-name01 <~/robertubuntu/testing/test-plans-and-scripts/Robert-API/full/Google-Plan-and-Script/history/$1/"Factom API Test Script $1.odt.hash.asc"
mv ~/Downloads/"Factom API Test Plan II.ods" "Factom API Test Plan $1.ods"
sha256sum "Factom API Test Plan $1.ods" >"Factom API Test Plan $1.ods.hash"
cat "Factom API Test Plan $1.ods.hash"
gpg --clearsign "Factom API Test Plan $1.ods.hash"
cat "Factom API Test Plan $1.ods.hash.asc"
factom-cli put -e "Factom API Test Plan $1.ods" -c 71fecdd33ea55b9608863782da1fc158b69e0cc8f283620bac670578a5603645 ec-wallet-address-name01 <~/robertubuntu/testing/test-plans-and-scripts/Robert-API/full/Google-Plan-and-Script/history/$1/"Factom API Test Plan $1.ods.hash.asc"
