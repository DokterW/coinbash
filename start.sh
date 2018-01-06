#!/bin/bash
# coinbash v0.17
# Made by Dr. Waldijk
# A simple script that fetches BTC, ETH  & LTC currency rate from coinbase.com.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
CIBNAM="coinbash"
CIBVER="0.17"
CIBLOC="$HOME/.dokter/coinbash"
CIBOLD[1]="0"
CIBIND[1]="-"
CIBOLD[2]="0"
CIBIND[2]="-"
CIBOLD[3]="0"
CIBIND[3]="-"
CIBOLD[4]="0"
CIBIND[4]="-"
CIBCCR[1]="BTC"
CIBCCR[2]="BCH"
CIBCCR[3]="ETH"
CIBCCR[4]="LTC"
 if [ ! -e $CIBLOC/coins.csv ]; then
    wget  -q -N --show-progress https://raw.githubusercontent.com/DokterW/$CIBNAM/master/coins.csv -P $CIBLOC/
    CIBCSV=$(cat $CIBLOC/coins.csv)
 else
    CIBCSVCHK=$(cat $CIBLOC/coins.csv | grep -o ',' | tr -d '\n' | wc -c)
    if [[ "$CIBCSVCHK" = "2" ]]; then
        CIBCSVCHK=$(cat $CIBLOC/coins.csv | sed -r 's/(.*),(.*),(.*)/\1,0,\2,\3/')
        echo "$CIBCSVCHK" > $CIBLOC/coins.csv
    fi
    CIBCSV=$(cat $CIBLOC/coins.csv)
 fi
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
while :; do
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
            break
        ;;
        2)
            CIBCUR="NOK"
            break
        ;;
        3)
            CIBCUR="SEK"
            break
        ;;
        4)
            CIBCUR="EUR"
            break
        ;;
    esac
done
while :; do
    clear
    echo "$CIBNAM - v$CIBVER"
    echo ""
    echo -n "1. "
    echo "$CIBCSV" | cut -d , -f 1 | sed 's/\(.*\)/\1 BTC/'
    echo -n "2. "
    echo "$CIBCSV" | cut -d , -f 2 | sed 's/\(.*\)/\1 BCH/'
    echo -n "3. "
    echo "$CIBCSV" | cut -d , -f 3 | sed 's/\(.*\)/\1 ETH/'
    echo -n "4. "
    echo "$CIBCSV" | cut -d , -f 4 | sed 's/\(.*\)/\1 LTC/'
    echo "0. Continue"
    echo ""
    read -p "Enter option: " -s -n1 CIBKEY
    case "$CIBKEY" in
        1)
            clear
            echo "$CIBNAM - v$CIBVER"
            echo ""
            read -p "Enter new amount: " CIBKEY
            CIBCSV=$(echo "$CIBCSV" | sed "1s/.*\(,.*,.*,.*\)/$CIBKEY\1/")
            echo "$CIBCSV" > $CIBLOC/coins.csv
        ;;
        2)
            clear
            echo "$CIBNAM - v$CIBVER"
            echo ""
            read -p "Enter new amount: " CIBKEY
            CIBCSV=$(echo "$CIBCSV" | sed "1s/\(.*,\).*\(,.*,.*\)/\1$CIBKEY\2/")
            echo "$CIBCSV" > $CIBLOC/coins.csv
        ;;
        3)
            clear
            echo "$CIBNAM - v$CIBVER"
            echo ""
            read -p "Enter new amount: " CIBKEY
            CIBCSV=$(echo "$CIBCSV" | sed "1s/\(.*,.*,\).*\(,.*\)/\1$CIBKEY\2/")
            echo "$CIBCSV" > $CIBLOC/coins.csv
        ;;
        4)
            clear
            echo "$CIBNAM - v$CIBVER"
            echo ""
            read -p "Enter new amount: " CIBKEY
            CIBCSV=$(echo "$CIBCSV" | sed "1s/\(.*,.*,.*,\).*/\1$CIBKEY/")
            echo "$CIBCSV" > $CIBLOC/coins.csv
        ;;
        0)
            break
        ;;
    esac
done
while :; do
    CIBCNT=0
    until [ "$CIBCNT" -eq "4" ]; do
        CIBCNT=$(expr $CIBCNT + 1)
        CIBCON[$CIBCNT]=$(echo "$CIBCSV" | cut -d , -f $CIBCNT)
        CIBDEC[$CIBCNT]=$(echo "scale=2; ${CIBCON[$CIBCNT]}/1" | bc)
        CIBRAT[$CIBCNT]=$(curl -s "https://api.coinbase.com/v2/exchange-rates?currency=${CIBCCR[$CIBCNT]}" | jq -r ".data.rates.$CIBCUR")
        if [ "${CIBRAT[$CIBCNT]}" = "null" ]; then
            CIBRAT[$CIBCNT]="0"
        fi
        CIBVAL[$CIBCNT]=$(echo "scale=2; ${CIBRAT[$CIBCNT]}*${CIBCON[$CIBCNT]}/1" | bc)
    done
    clear
    echo "$CIBNAM - v$CIBVER"
    CIBDAT=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$CIBDAT]"
    echo ""
    CIBCNT=0
    until [ "$CIBCNT" -eq "4" ]; do
        CIBCNT=$(expr $CIBCNT + 1)
        # Comparisons with decimals doesn't work, so I decided to solve it by removing the decimal separator.
        CIBRATINT[$CIBCNT]=$(echo "${CIBRAT[$CIBCNT]}" | sed 's/\.//g')
        CIBOLDINT[$CIBCNT]=$(echo "${CIBOLD[$CIBCNT]}" | sed 's/\.//g')
        if [ "${CIBOLDINT[$CIBCNT]}" -eq "0" ]; then
            CIBIND[$CIBCNT]="-"
            CIBOLD[$CIBCNT]="-"
        elif [ "${CIBRATINT[$CIBCNT]}" -eq "${CIBOLDINT[$CIBCNT]}" ]; then
            CIBIND[$CIBCNT]="-"
        elif [ "${CIBRATINT[$CIBCNT]}" -gt "${CIBOLDINT[$CIBCNT]}" ]; then
            CIBIND[$CIBCNT]="↑"
        elif [ "${CIBRATINT[$CIBCNT]}" -lt "${CIBOLDINT[$CIBCNT]}" ]; then
            CIBIND[$CIBCNT]="↓"
        fi
        CIBRAT[$CIBCNT]=$(echo "${CIBRAT[$CIBCNT]}" | sed -r 's/([0-9]{1,3})([0-9]{3})(\.[0-9]{2})/\1,\2\3/')
        CIBOLD[$CIBCNT]=$(echo "${CIBOLD[$CIBCNT]}" | sed -r 's/([0-9]{1,3})([0-9]{3})(\.[0-9]{2})/\1,\2\3/')
        echo "  ${CIBCCR[$CIBCNT]}: ${CIBRAT[$CIBCNT]} $CIBCUR"
        echo "   ${CIBIND[$CIBCNT]}  (${CIBOLD[$CIBCNT]} $CIBCUR)"
        echo "Coins: ${CIBDEC[$CIBCNT]} ${CIBCCR[$CIBCNT]}"
        echo "       ${CIBVAL[$CIBCNT]} $CIBCUR" | sed -r 's/([0-9]{1,3})([0-9]{3})(\.[0-9]{2})/\1,\2\3/'
        echo ""
        CIBRAT[$CIBCNT]=$(echo "${CIBRAT[$CIBCNT]}" | sed -r 's/,//g')
        CIBOLD[$CIBCNT]=$(echo "${CIBOLD[$CIBCNT]}" | sed -r 's/,//g')
        CIBOLD[$CIBCNT]=${CIBRAT[$CIBCNT]}
    done
    CIBALL=$(echo "${CIBVAL[1]}+${CIBVAL[2]}+${CIBVAL[3]}+${CIBVAL[4]}" | bc | sed -r 's/([0-9]{1,3})([0-9]{3})(\.[0-9]{2})/\1,\2\3/')
    echo "  All: $CIBALL $CIBCUR"
    echo ""
    read -t $CIBTIM -s -n1 -p "(Q)uit (*)refresh " CIBKEY
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
