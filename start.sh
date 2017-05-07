#!/bin/bash
# coinbash v0.6
# Made by Dr. Waldijk
# A simple script that fetches BTC, ETH  & LTC currency rate from coinbase.com.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
CIBNAM="coinbash"
CIBVER="0.6"
CIBLOC="$HOME/.dokter/coinbash"
CIBOLD="0"
CIBIND="-"
# Refresh (in seconds)
CIBTIM="600"
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
echo "$CIBNAM - v$CIBVER"
echo ""
echo "1. USD"
echo "2. NOK"
echo "3. SEK"
echo "4. EUR"
echo ""
echo ""
read -p "Pick currency: " -s -n1 CIBKEY
case "$CIBKEY" in
    1)
        CIBCUR="USD"
    ;;
    2)
        CIBCUR="NOK"
    ;;
    3)
        CIBCUR="SEK"
    ;;
    4)
        CIBCUR="EUR"
    ;;
esac
clear
echo "$CIBNAM - v$CIBVER"
echo ""
echo ""
echo "How much do you have?"
echo ""
read -p "BTC: " CIBCONBTC
CIBDECBTC=$(echo "scale=2; $CIBCONBTC/1" | bc)
read -p "ETH: " CIBCONETH
CIBDECETH=$(echo "scale=2; $CIBCONETH/1" | bc)
read -p "LTC: " CIBCONLTC
CIBDECLTC=$(echo "scale=2; $CIBCONLTC/1" | bc)
while :; do
    # BTC
    CIBRATBTC=$(curl -s "https://api.coinbase.com/v2/exchange-rates?currency=BTC" | jq -r ".data.rates.$CIBCUR")
    CIBVALBTC=$(echo "scale=2; $CIBRATBTC*$CIBCONBTC/1" | bc)
    # ETH
    CIBRATETH=$(curl -s "https://api.coinbase.com/v2/exchange-rates?currency=ETH" | jq -r ".data.rates.$CIBCUR")
    CIBVALETH=$(echo "scale=2; $CIBRATETH*$CIBCONETH/1" | bc)
    # Comparisons with decimals doesn't work, so I decided to solve it by removing the decimal separator.
#    CIBRATETHINT=$(echo "$CIBRATETH" | sed 's/\.//g')
#    CIBOLDINT=$(echo "$CIBOLD" | sed 's/\.//g')
#    if [ "$CIBOLDINT" -eq "0" ]; then
#        CIBIND="-"
#        CIBOLD="-"
#    elif [ "$CIBRATETHINT" -eq "$CIBOLDINT" ]; then
#        CIBIND="-"
#    elif [ "$CIBRATETHINT" -gt "$CIBOLDINT" ]; then
#        CIBIND="↑"
#    elif [ "$CIBRATETHINT" -lt "$CIBOLDINT" ]; then
#        CIBIND="↓"
#    fi
    # LTC
    CIBRATLTC=$(curl -s "https://api.coinbase.com/v2/exchange-rates?currency=LTC" | jq -r ".data.rates.$CIBCUR")
    CIBVALLTC=$(echo "scale=2; $CIBRATLTC*$CIBCONLTC/1" | bc)
    clear
    echo "$CIBNAM - v$CIBVER"
    echo ""
    echo "  BTC: $CIBRATBTC $CIBCUR"
    echo "  ETH: $CIBRATETH $CIBCUR"
#    echo "   $CIBIND  ($CIBOLD $CIBCUR)"
    echo "  LTC: $CIBRATLTC $CIBCUR"
    echo ""
    echo "Coins: $CIBDECBTC BTC"
    echo "       $CIBVALBTC $CIBCUR"
    echo "Coins: $CIBDECETH ETH"
    echo "       $CIBVALETH $CIBCUR"
    echo "Coins: $CIBDECLTC LTC"
    echo "       $CIBVALLTC $CIBCUR"
    echo ""
    read -t $CIBTIM -s -n1 -p "(Q)uit (*)refresh " CIBKEY
    CIBOLD=$CIBRATETH
    case "$CIBKEY" in
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
