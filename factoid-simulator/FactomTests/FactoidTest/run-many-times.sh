# http://localhost:8090/controlpanel
# factomd must be running

cd ~/testing/testing/test-plans-and-scripts/factoid-simulator/FactomTests/FactoidTest/
date +"%T"
for ((i=0; i < 1500; i++)); do
    ./run >> simulator-output
    done
date +"%T"

# awk '/Errors/ && $2 !~ /0/' ~/testing/testing/test-plans-and-scripts/factoid-simulator/FactomTests/FactoidTest/simulator-output


