#!/bin/bash
cd $HOME
#playapp="vlc"
playapp="mpv"

printf "1. Chillout Antenne von Antenne Bayern\n"
channel1="https://s2-webradio.antenne.de/chillout/stream/aacp?aw_0_1st.playerid=radio.de"
printf "2. Absolute Chillout\n"
channel2="https://ais-edge90-dal03.cdnstream.com/b05055_128mp3"
printf "3. Classicnl Soundtracks\n"
channel3="https://stream.classic.nl/classicnl-soundtracks.mp3"
printf "4. Matt's Movie Trax\n"
channel4='http://s8.myradiostream.com:11732/'
printf "5. Soundtracks FM\n"
channel5='https://soundtracksfm.stream.laut.fm/soundtracksfm?ref=radiode&t302=2024-12-05_15-45-18&uuid=0b21f786-ae33-443b-ab0a-138180dcc749'
printf "6. Movie Dance\n"
channel6='https://moviedance.stream.laut.fm/moviedance?ref=radiode&t302=2024-12-05_15-46-32&uuid=1f499652-4025-4e2a-86b7-7ca379181ff6'
printf "7. Streaming Soundtracks\n"
channel7='http://hi5.streamingsoundtracks.com/;'
printf "8. 181.fm - the buzz\n"
channel8='http://relay.181.fm:8126/'
printf "9. www.cinemix.us\n"
channel9='http://listen.cinemix.fr'
printf "Choose your channel: "
read answer

case $answer in
1)
    $playapp "$channel1" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
2)
    $playapp "$channel2" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
3)
    $playapp "$channel3" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
4)
    $playapp "$channel4" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
5)
    $playapp "$channel5" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
6)
    $playapp "$channel6" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
7)
    $playapp "$channel7" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
8)
    $playapp "$channel8" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
9)
    $playapp "$channel9" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
10)
    $playapp "$channel10" #1>/dev/null 2>&1 &
    printf "Enjoy the channel.\n"
    ;;
*) echo "Wrong answer, so long." ;;
esac
