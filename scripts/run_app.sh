#!/bin/bash

clear
set -e

if [ $# -gt 0 ]; then
    choice=$1
else
    if [ $(hostname) != 'laptop-300E5A' ]; then
        # We are on the server, no gui menu, use command line
        echo 'Provide a shorcut number [1..3]'
        read choice
    else
        # Quick and dirty zenity menu
        choice=`(
            simulations=("1 Backtest Equities", "2 Live Forex", "3 Live Equities")
            for simu in ${simulations[@]}
            do
                echo $simu
            done
        ) | zenity --list --width=300 --height=200 --title="Simulation Shortcuts" \
                    --text="Select the simulation to run" \
                    --column="Number" --column="Mode" --column="Assets"`
    fi
fi


# Quick run of usual backtests
echo $(date) " [Debug] Choice: " $choice
echo "C'est parti..."

# Equitie backtest 
if [ $choice == 1 ]; then
    time $QTRADE/application/app.py --initialcash 10000 --tickers random,20 \
        --algorithm VWAP --manager Fair --start 2011-01-10 --end 2012-01-11 \
        --frequency daily --database backtest --exchange paris

# Forex live test !
elif [ $choice == 2 ]; then
    time $QTRADE/application/app.py --initialcash 10000 --tickers EUR/USD,EUR/GBP,EUR/JPY \
        --algorithm StdBased --manager Constant --end 23h \
        --database liveforex --exchange forex --frequency minute --live

# Equitie live test !
elif [ $choice == 3 ]; then
    time $QTRADE/application/app.py --initialcash 10000 --tickers random,20 \
        --algorithm StdBased --manager OptimalFrontier --end 22h \
        --database live-equities --exchange nasdaq --frequency minute --live

else
    echo '** Error: invalid simulation number provided: ' $choice

fi

#notify-send Simulation "Simulation ended !" --urgency normal --app-name QuanTrade --icon $QTRADE/management/introduction/LaTexSources/images/graph.png