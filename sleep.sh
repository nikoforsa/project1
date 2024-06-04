#!/bin/bash
#build script
#./build-dev.sh
# For Linux/macOS
##docker run -it --rm --volume $PWD:/opt/pwd ubuntu:latest /bin/bash
# For Windows (PowerShell)
##docker run -it --rm --volume ${PWD}:/opt/pwd ubuntu:latest /bin/bash
#
echo "complete build..."
apt-get install xpra xserver-xephyr xinit xauth xclip x11-xserver-utils x11-utils x11-apps gedit \
    dbus-x11 libxext-dev libxrender-dev libxtst-dev x11vnc xvfb net-tools -y
#find /root/.conan/ -name 'libp7*.so' -exec cp {} /home/user/build/bin/ \;
#find /root/.conan/ -name 'libp7*.so' -exec cp {} /lib/x86_64-linux-gnu/ \;

echo 'root:111' | chpasswd
#usermod -d /home/user/ root

apt install -y  net-tools
export DISPLAY="$(ifconfig eth0 | grep inet | awk '$1=="inet" {print $2}')":0
touch ~/.Xauthority 

$(sed -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config)
$(sed -i 's/\#X11Forwarding yes/X11Forwarding yes/' /etc/ssh/sshd_config)


$(sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config )
$(sed -ri 's/^#AllowTcpForwarding\s+.*/AllowTcpForwarding yes/g' /etc/ssh/sshd_config )
$(sed -ri 's/^#X11Forwarding\s+.*/X11Forwarding yes/g' /etc/ssh/sshd_config)
$(sed -ri 's/^#X11UseLocalhost\s+.*/X11UseLocalhost no/g' /etc/ssh/sshd_config)

echo "daemon run container..."
mkdir -p /run/sshd
/usr/sbin/sshd -p 5555 -D &
sleep infinity
#"tail -f /dev/null"