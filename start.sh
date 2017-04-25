#!/bin/bash
# shETHer v0.1
# Made by Dr. Waldijk
# A simple script that fetches ETH rate from coinbase.com.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
ETHNAM="shETHer"
ETHVER="0.1"
# Refresh (in seconds)
ETHTIM="600"
# Install dependencies --------------------------------------------------------------
if [ ! -e /usr/bin/curl ] && [ ! -e /usr/bin/jq ]; then
    sudo dnf -y install curl jq
elif [ ! -e /usr/bin/curl ]; then
    sudo dnf -y install curl
elif [ ! -e /usr/bin/jq ]; then
    sudo dnf -y install jq
fi
# -----------------------------------------------------------------------------------
clear
echo "$ETHNAM - v$ETHVER"
echo "1. USD"
echo "2. NOK"
echo "3. SEK"
echo "4. EUR"
read -p "Pick currency: " -s -n1 ETHKEY
case "$ETHKEY" in
    1)
        ETHCUR="USD"
    ;;
    2)
        ETHCUR="NOK"
    ;;
    3)
        ETHCUR="SEK"
    ;;
    4)
        ETHCUR="EUR"
    ;;
esac
clear
echo "$ETHNAM - v$ETHVER"
echo ""
echo "How much ETH"
echo "do you have?"
echo ""
read -p "> " ETHCON
while :; do
    ETHRAT=$(curl -s "https://api.coinbase.com/v2/exchange-rates?currency=ETH" | jq -r ".data.rates.$ETHCUR")
    ETHVAL=$(echo "scale=2; $ETHRAT*$ETHCON" | bc)
    clear
    echo "$ETHNAM - v$ETHVER"
    echo ""
    echo "Rate: $ETHRAT $ETHCUR"
    echo " Own: $ETHVAL $ETHCUR"
    echo ""
    read -t $ETHTIM -s -n1 -p "(Q)uit|(U)pdate " ETHKEY
    case "$ETHKEY" in
        [qQ])
            echo ""
            clear
            break
        ;;
        *)
            continue
        ;;
    esac
done
