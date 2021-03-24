  # - ulimit -c unlimited
  # - install -m 1777 -d /var/lib/systemd/coredump
  # - echo '|/usr/lib/systemd/systemd-coredump %P %u %g %s %t %c %e' > /proc/sys/kernel/core_pattern
  # - /usr/lib/systemd/systemd-sysctl --prefix kernel.core_pattern
  # - echo 'kernel.core_pattern=|/usr/lib/systemd/systemd-coredump %P %u %g %s %t %c %e' >> /etc/sysctl.d/50-coredump.conf
  # - /usr/lib/systemd/systemd-sysctl /etc/sysctl.d/50-coredump.conf
  # - /sbin/rcapparmor stop || true
  # - echo 'kernel.suid_dumpable = 2' >> /etc/sysctl.d/suid_dumpable.conf
  # - /usr/lib/systemd/systemd-sysctl /etc/sysctl.d/suid_dumpable.conf
  - /sbin/swapoff -a
  - echo 'vm.swappiness = 0' >> /etc/sysctl.d/swappiness.conf
  - /usr/lib/systemd/systemd-sysctl /etc/sysctl.d/swappiness.conf
  - /usr/bin/sed -i 's/.*swap.*/#&/' /etc/fstab
  - /usr/bin/systemctl restart systemd-sysctl
  - /usr/bin/sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
  - /usr/bin/sed -i 's/#GSSAPIAuthentication no/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
  - /usr/bin/sed -i 's/#UseDNS no/UseDNS no/g' /etc/ssh/sshd_config
  - /usr/bin/sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
  - /usr/bin/systemctl restart sshd
  - echo '$(date) - hello world!' > /tmp/hello.txt
