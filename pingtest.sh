echo "Running $0 ping discovery script..."
echo ""
if [ -z "$1" ]
then
	echo -e '\a'
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "ERROR! You need to enter the network address! "
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo ""
	echo "To aid you, here is the current ARP table:"
	echo ""
	arp -a
	echo "............................................."
	echo ""
	read -p "Enter the first octet of the address: " network_address0
	read -p "Enter the second octet of the address: " network_address1
	read -p "Enter the third octet of the address: " network_address2
	network_address=$network_address0.$network_address1.$network_address2.
else
	network_address=$1
fi
read -p "Enter a starting host address: " start
read -p "Enter the last host address: " end

echo ""
echo "............................................."
echo "Testing addresses (in range of $start - $end) starting with:"
echo $network_address$start
echo ""
echo ""
echo "Starting network discovery Ping/ICMP,"
echo "using a starting address of $network_address$start"
echo ""
echo "Only one ping is sent, be sure that ICMP"
echo "is not disabled on the network"
echo ""
echo "Alert sound is played on success and end..."
echo "............................................."
echo ""

for (( host_address = $start; host_address <= $end; host_address++ ))
do
	ping -a -c 1 $network_address$host_address
	
done
echo "Ping test complete!"
echo -e '\a'
exit 0
