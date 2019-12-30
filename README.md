# immon4ik_infra
immon4ik Infra repository
# ДЗ №3
bastion_IP = 35.228.190.122
someinternalhost_IP = 10.166.0.6
Команда подключения к someinternalhost:
ssh -A immon4ik@35.228.190.122 ssh 10.166.0.6
Создания алиаса для подключения к someinternalhost
Добавляем в.ssh\config
Host someinternalhost
     HostName 10.166.0.6
     User immon4ik
     ProxyCommand C:\Windows\System32\OpenSSH\ssh.exe -W %h:%p immon4ik@35.228.190.122
Добавляем алиас
doskey someinternalhost=ssh someinternalhost
Профит
someinternalhost
Last login: Fri Dec 20 07:53:45 2019 from 10.166.0.5
immon4ik@sih:~$
# ДЗ №4
testapp_IP = 35.233.40.32
testapp_port = 9292
Для запуска использовался ps.
# create instances hw default
gcloud compute instances create reddit-app `
  --boot-disk-size=10GB `
  --image-family ubuntu-1604-lts `
  --image-project=ubuntu-os-cloud `
  --machine-type=g1-small `
  --tags puma-server `
  --restart-on-failure
# create instances with startup scripts(install.sh=install_ruby.sh+install_mongodb.sh+deploy.sh)
gcloud compute instances create reddit-app-ss `
  --metadata-from-file startup-script=D:\_System\Study\otus\hw4\install.sh `
  --boot-disk-size=10GB `
  --image-family ubuntu-1604-lts `
  --image-project=ubuntu-os-cloud `
  --machine-type=g1-small `
  --tags puma-server `
  --restart-on-failure
# create instances with startup scripts + fw rules
gcloud compute instances create reddit-app-ss2 `
  --metadata-from-file startup-script=D:\_System\Study\otus\hw4\install.sh `
  --boot-disk-size=10GB `
  --image-family ubuntu-1604-lts `
  --image-project=ubuntu-os-cloud `
  --machine-type=g1-small `
  --tags ss-puma-server `
  --restart-on-failure
# create fw rules
gcloud compute firewall-rules create ss-puma-server `
  --direction=INGRESS `
  --priority=1000 `
  --network=default `
  --action=ALLOW `
  --rules=tcp:9292 `
  --source-ranges=0.0.0.0/0 `
  --target-tags=ss-puma-server
# ДЗ №5
git mv deploy.sh install_mongodb.sh install_ruby.sh config-scripts
add packer/variables.json, variables.json.example ubuntu16.json, immutable.json
add packer/scripts/deploy.sh, install_mongodb.sh, install_ruby.sh hw5.sh
add packer/files/hw5.service
add .gitignore packer/variables.json
packer build paker/ubuntu16.json
packer build paker/immutable.json
add config-scripts/create-reddit-vm.sh
