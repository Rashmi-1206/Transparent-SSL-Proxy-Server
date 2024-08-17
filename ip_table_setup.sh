A_IP='10.130.171.242'
B_IP='10.130.171.247' 
C_IP='10.130.171.243' 

# Forward traffic from VM A to VM C
sudo iptables -t nat -A PREROUTING -p tcp -s $A_IP/24 -d $C_IP/24 --dport 80 -j DNAT --to-destination $C_IP:80
sudo iptables -t nat -A POSTROUTING -d $C_IP/23 -j MASQUERADE

# # Forward traffic from VM C to VM A
sudo iptables -t nat -A PREROUTING -p tcp -s $C_IP/24 -d $A_IP/24 --dport 80 -j DNAT --to-destination $A_IP:80
sudo iptables -t nat -A POSTROUTING -d $A_IP/24 -j MASQUERADE


# sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# sudo iptables -A FORWARD -i enp0s3 -p tcp --dport 80 -j ACCEPT
# sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE


# # Set up iptables rules for port forwarding
# iptables -t nat -A PREROUTING -p tcp --dport 80 -d $B_IP -j DNAT --to-destination $C_IP:80
# iptables -t nat -A POSTROUTING -p tcp --dport 80 -d $C_IP -j MASQUERADE

# iptables -t nat -A PREROUTING -p tcp --dport 80 -d $B_IP -j DNAT --to-destination $C_IP:80
# iptables -t nat -A POSTROUTING -p tcp -d $C_IP --dport 80 -j MASQUERADE

# iptables -t nat -A POSTROUTING -p tcp -d $C_IP --dport 80

# iptables -t nat -A PREROUTING -p tcp --dport 80 -d $B_IP -j DNAT --to-destination $C_IP:80
# iptables -A FORWARD -p tcp -d $C_IP --dport 80 -j ACCEPT

sudo sysctl -w net.ipv4.ip_forward=1

# sudo iptables -A FORWARD -i enp0s3 -o enp0s3 -d $C_IP -p tcp --dport 80 -j ACCEPT
sudo iptables -A FORWARD -i enp0s3 -o enp0s3 -s $C_IP -p tcp --sport 80 -m state --state RELATED,ESTABLISHED -j ACCEPT

# sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE


sudo iptables -A FORWARD -i enp0s3 -o enp0s3 -s $A_IP/24 -d $C_IP/24 -j ACCEPT
sudo iptables -A FORWARD -i enp0s3 -o enp0s3 -s $C_IP/24 -d $A_IP/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80 -d $C_IP -j DNAT --to-destination $B_IP
sudo iptables -t nat -A POSTROUTING -o enp0s3 -p tcp --dport 80 -d $B_IP -j SNAT --to-source $C_IP
