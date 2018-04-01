while true
do
	echo 'Connecting...'
	ssh -NL localhost:5902:localhost:5901 parmyn
	echo 'Connection lost.'
done
