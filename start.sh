#!/bin/bash
# shETHer v0.3
# Made by Dr. Waldijk
# A simple script that fetches ETH rate from coinbase.com.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
ETHNAM="shETHer"
ETHVER="0.3"
ETHOLD="-"
ETHIND="-"
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
echo ""
echo "1. USD"
echo "2. NOK"
echo "3. SEK"
echo "4. EUR"
echo ""
echo ""
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
echo ""
echo "How much ETH"
echo "do you have?"
echo ""
echo ""
echo ""
read -p "> " ETHCON
ETHDEC=$(echo "scale=2; $ETHCON/1" | bc)
while :; do
    ETHRAT=$(curl -s "https://api.coinbase.com/v2/exchange-rates?currency=ETH" | jq -r ".data.rates.$ETHCUR")
    ETHVAL=$(echo "scale=2; $ETHRAT*$ETHCON/1" | bc)
    # Comparisons with decimals doesn't work, so I decided to solve it by removing the decimal separator.
    ETHRATINT=$(echo "$ETHRAT" | sed 's/\.//g')
    ETHOLDINT=$(echo "$ETHOLD" | sed 's/\.//g')
    if [ "$ETHRATINT" -eq "$ETHOLDINT" ]; then
        ETHIND="-"
    elif [ "$ETHRATINT" -gt "$ETHOLDINT" ]; then
        ETHIND="↑"
    elif [ "$ETHRATINT" -lt "$ETHOLDINT" ]; then
        ETHIND="↓"
    fi
    clear
    echo "$ETHNAM - v$ETHVER"
    echo ""
    echo " Rate: $ETHRAT $ETHCUR"
    echo "   $ETHIND  ($ETHOLD $ETHCUR)"
    echo ""
    echo "Coins: $ETHDEC ETH"
    echo "  Own: $ETHVAL $ETHCUR"
    echo ""
    read -t $ETHTIM -s -n1 -p "(Q)uit | *key=update " ETHKEY
    ETHOLD=$ETHRAT
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
