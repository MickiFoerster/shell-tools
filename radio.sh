#!/bin/bash
cd $HOME
#playapp="vlc"
playapp="/usr/bin/firejail mpv"

printf "1. Ambient chill: Big R Radio - Erins Chill\n"
#channel1="http://173.192.43.20:10019"
channel1="http://tunein.com/radio/Big-R-Radio-Erins-Chill-s89921/"
printf "2. radio groove\n"
channel2="`wget -O - http://somafm.com/groovesalad.pls 2>/dev/null | grep File1 | sed "s/.*\(http.*\)/\1/"`"
printf "3. radio paradise\n"
channel3='http://scfire-chi-aa01.stream.aol.com:80/stream/1048 http://scfire-dll-aa01.stream.aol.com:80/stream/1048 http://scfire-nyk-aa04.stream.aol.com:80/stream/1048 http://scfire-ntc-aa04.stream.aol.com:80/stream/1048'
printf "4. streamingsoundtracks.com\n"
channel4='http://209.9.229.206:80'
printf "5. radio rivendell - the fantasy station\n"
channel5='http://88.191.11.123:8760'
printf "6. Secret Agent from SomaFM\n"
channel6='http://uwstream2.somafm.com:9016'
printf "7. chronix aggression\n"
channel7='https://fastcast4u.com/player/gebacher/?pl=vlc&c=0'
printf "8. 181.fm - the buzz\n"
channel8='http://relay.181.fm:8126/'
printf "9. www.cinemix.us\n"
channel9='http://listen.cinemix.fr'
#printf "10. monkeyradio.org 192kbps (for 96kbps see website)\n"
#channel10="`wget -O - http://groove.monkeyradio.org/ 2>/dev/null | grep File1 | sed "s/.*\(http.*\)/\1/"`"
printf "Choose your channel: " ;
read answer

case $answer in
	1)  playapp="/opt/google/chrome/chrome"
		$playapp "$channel1" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	2) $playapp "$channel2" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	3) $playapp "$channel3" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	4) $playapp "$channel4" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	5) $playapp "$channel5" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	6) $playapp "$channel6" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	7) $playapp "$channel7" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	8) $playapp "$channel8" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	9) $playapp "$channel9" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	10) $playapp "$channel10" #1>/dev/null 2>&1 &
		printf "Enjoy the channel.\n"
		;;
	*) echo "Wrong answer, so long."
esac


