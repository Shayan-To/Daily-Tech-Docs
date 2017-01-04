mkdir -p /root/rec
cd /root

while :
do
	for (( i=0 ; ; i++ ))
	do
		if [ ! -e /root/rec/$i.rec -a ! -e /root/rec/$i.tim ]
		then
			break
		fi
	done

	script -c byobu -t/root/rec/$i.tim /root/rec/$i.rec
done

# Why 'nohup shellrec < /dev/null > /dev/null 2>&1 &' or even 'nohup shellrec &' don't work?
