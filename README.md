# Fedora

# Server
```
mkdir ~/.ssh
chmod 500 ~/.ssh

cp workstation/.ssh/authorized_keys ~/.ssh/authorized_keys
chmod 500 ~/.ssh/authorized_keys

cp workstation/.bashrc ~/.bashrc
```

## OpenShift + SELinux
```
chcon -R -t bin_t /opt/openshift
```

# Workstation
```
mkdir ~/.ssh
chmod 500 ~/.ssh

cp workstation/.ssh/config ~/.ssh/config
chmod 500 ~/.ssh/config

cp workstation/.bashrc ~/.bashrc
```
