# http://localhost:8090/controlpanel
# factomd must be running

sleep 60
. ~/testing/testing/test-plans-and-scripts/Robert-API/get-latest-code/go-version.sh
cd ~/testing/testing/test-plans-and-scripts/factoid-simulator/FactomTests/FactoidTest/
date +"%T"
for ((i=0; i < 500; i++)); do
    ./run >> simulator-output
    done
date +"%T"

# awk '/Errors/ && $2 !~ /0/' ~/testing/testing/test-plans-and-scripts/factoid-simulator/FactomTests/FactoidTest/simulator-output


