# immon4ik_infra
immon4ik Infra repository
## ДЗ №3
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
## ДЗ №4
testapp_IP = 35.233.40.32
testapp_port = 9292
Для запуска использовался ps.
### create instances hw default
gcloud compute instances create reddit-app `
  --boot-disk-size=10GB `
  --image-family ubuntu-1604-lts `
  --image-project=ubuntu-os-cloud `
  --machine-type=g1-small `
  --tags puma-server `
  --restart-on-failure
### create instances with startup scripts(install.sh=install_ruby.sh+install_mongodb.sh+deploy.sh)
gcloud compute instances create reddit-app-ss `
  --metadata-from-file startup-script=D:\_System\Study\otus\hw4\install.sh `
  --boot-disk-size=10GB `
  --image-family ubuntu-1604-lts `
  --image-project=ubuntu-os-cloud `
  --machine-type=g1-small `
  --tags puma-server `
  --restart-on-failure
### create instances with startup scripts + fw rules
gcloud compute instances create reddit-app-ss2 `
  --metadata-from-file startup-script=D:\_System\Study\otus\hw4\install.sh `
  --boot-disk-size=10GB `
  --image-family ubuntu-1604-lts `
  --image-project=ubuntu-os-cloud `
  --machine-type=g1-small `
  --tags ss-puma-server `
  --restart-on-failure
### create fw rules
gcloud compute firewall-rules create ss-puma-server `
  --direction=INGRESS `
  --priority=1000 `
  --network=default `
  --action=ALLOW `
  --rules=tcp:9292 `
  --source-ranges=0.0.0.0/0 `
  --target-tags=ss-puma-server
## ДЗ №5
git mv deploy.sh install_mongodb.sh install_ruby.sh config-scripts
add packer/variables.json, variables.json.example ubuntu16.json, immutable.json
add packer/scripts/deploy.sh, install_mongodb.sh, install_ruby.sh hw5.sh
add packer/files/hw5.service
add .gitignore packer/variables.json
packer build paker/ubuntu16.json
packer build paker/immutable.json
add config-scripts/create-reddit-vm.sh
## ДЗ №6
### Основное задание.
Установлен terraform. Скорректирован .gitignore. Добавлен код в main.tf, lb.tf. Сформированы переменные в variables.tf, outputs.tf. Добавлен пример с введенными значениями переменных terraform.tfvars.example. Добавлены files/deploy.sh, files/puma.service для деплоя приложения, выданы права на исполнение скрипта. Определён ряд переменных и внесён в код. Все конфигурационные файлы отформатированы командой terraform fmt.
### Задание со *.
Добавлены ssh ключи в методанные проекта для нескольких пользователей с использованием count.
При добавлении ssh ключа через веб и последующем применении terraform apply -auto-approve удаляется ключ внесённый через веб.
### Задание с **.
На основе открытых источников сформирован код создания lb. Разобрано выполнение всех из использованных в коде ресурсов. Создание инстансов приложений сформировано с использованием count.
В такой конфигурации приложения присутствуют две независимые БД для каждого инстанса приложения, отстутствует кеш. Соответственно данные внесенные на каждый из инстансов никак не реплицируются, что приводит к их разнородности.
## ДЗ №7
### Основное задание.
Изучена взаимосвязь и зависимость ресурсов. Изучена работа с модулями. Конфигурация разбина на несколько .tf файлов. Выполнено разделение приложения на среды prod и stage. Изучена работа с реестром модулей. Создан бакет для хранения state-файлов.
### Задание со *.
Создана конфигурация для хранения state-файлов. State-файлы перемещены, при последовательном применении конфигураций для prod и stage сред проходит без ошибок. При параллельном применении конфигураций для prod и stage сред срабатывает блокировка "Error locking state: Error acquiring the state lock". Доработан модуль terraform-google-storage-bucket для создания нескольких бакетов с for_each, в backend.tf каждой из сред прописан относящийся к среде бакет. В таком варианте возможно одновременное применение конфигураций.
### Задание с **.
На основе открытых источников сформированы provisioner для модулей, которые позволяют работать приложению. Параметризированы модули и среды prod и stage.
## ДЗ №8
### Основное задание.
Результатом повторного запуска ansible-playbook clone.yml является:
```
appserver: ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Это говорит о том, что после удаления папки reddit появляется возможность вновь её склонировать.
### Задание со *.
Доработаны tf файлы модулей для маркировки по группам "app","db".
Настроена работа virtualenv и python 3.6.8
С использованием открытых источников написаны скрипты inventory.py, run_inventory.py для формирования файлов динамической инвентаризации.
Выполнение задания по:
```
ansible all -i run_inventory.py -m ping
35.205.159.135 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
35.233.117.204 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```
ansible.cfg изменен для возможности запуска без явного указания файла инвентаризации:
```
inventory = ./run_inventory.py
```
Отличия статической и динамической инвентаризации заключаются в архитектуре формирования блоков групп хостов. Так же наиболее ярким отличием является присутствие блок _meta и содержание в нем переменных хоста(блок hostvars), при этом инвентори скрипт не будет вызываться с --host для каждого хоста. Это позволяет сильно ускорить производительность динамического инвентори и упрощает реализацию кеширования на стороне клиента.
## ДЗ №9
### Основное задание.
В рамках домашнего задания исследована работа плейбуков, ограничений по группам и тегам: плейбука с одним\несколькими сценариями, работа нескольких плейбуков, а так же их работа при объединении импортом в один основной плейбук.
Написаны плейбуки для конфигурирования хостов БД и прилодения: ansible/app.yml, db.yml, deploy.yml, site.yml
Написаны плейбуки для установки ПО хостов БД и приложения используя packer: ansible/packer_app.yml, packer_db.yml
Переработаны сценарии сборки образов packer с использованием провижиенера ansible: app.json, db.json
**Переведена инфраструктура тестирования и выполнения ДЗ с windows на *nix и в gcp. Установлен весь необходимый софт из предидущих ДЗ.**
### Задание со *.
Для реализации динамической инвентаризации принято решение использовать инвентори плагин gcp compute.
ansible.cfg изменен для возможности использовать динамическую инвентаризацию в gcp:
```
[defaults]
inventory = ./inventory_gcp.yml
[inventory]
enable_plugins = gcp_compute, host_list, script, yaml, ini, auto
```
С использованием открытых источников(*http://docs.testing.ansible.com/ansible/latest/plugins/inventory/gcp_compute.html*) написаны файл динамической инвентаризации ansible/inventory_gcp.yml.
Создан и настроен сервисный аккаунт gcp для моего проекта.
С использованием открытых источников(*https://serverfault.com/questions/638507/how-to-access-host-variable-of-a-different-host-with-ansible*) внесена доработка в блок переменных для динамической установки ip-адреса БД в плейбук ansible/app.yml:
```
vars:
  db_host: "{{ hostvars['reddit-db']['ansible_default_ipv4']['address'] }}"
```
## ДЗ №10
### Основное задание.
В рамках ДЗ изучены практики по организации конфигурационного кода, разделение плейбуков по ролям, разделение окружений среды, изучены принцип работы и возможности ansible-galaxy.
Для реализации открытия 80 порта для инстанса приложения в конфигурации terraform/modules/app/variables.tf было добавлено дефолтное значение тега http-server:
```
[...]
variable tags {
  type    = list(string)
  default = ["reddit-app", "http-server"]
}
[...]
```
Добавлен вызов роли jdauphant.nginx в плейбук ansible/playbooks/app.yml:
```
[...]
  roles:
    - app
    - jdauphant.nginx
[...]
```
Изучена и применена работа с ansible-vault. Дополнен конфиг ansible/ansible.cfg для работы с мастер-ключем vault.key.
Дополнен плейбук ansible/playbooks/site.yml для создания дополнительных пользователей из зашифрованных плейбуков соответствующей среды окружения:
```
[...]
- import_playbook: users.yml
[...]
```
Провереня доступность приложения на 80 порту и возможность подключиться новым пользователям после применения ansible/playbooks/site.yml
### Задание со *.
Для созданнового в прошлом задании динамического инвентори добавим фильтрацию по метке среды окружения:
- ansible/environments/prod/inventory_gcp.yml
```
[...]
filters:
  - labels.env = prod
[...]
```
- ansible/environments/stage/inventory_gcp.yml
```
[...]
filters:
  - labels.env = stage
[...]
```
Теперь опишим эту метку в конфигурациях terraform:
- terraform/modules/app/variables.tf
```
[...]
variable label_env {
  type    = string
  description = "dev, stage, prod and etc."
  default     = "dev"
}
[...]
```
- terraform/modules/app/main.tf
```
[...]
labels = {
  ansible_group = var.label_ansible_group
  env = var.label_env
}
[...]
```
- terraform/modules/db/variables.tf
```
[...]
variable label_env {
  type    = string
  description = "dev, stage, prod and etc."
  default     = "dev"
}
[...]
```
- terraform/modules/db/main.tf
```
[...]
labels = {
  ansible_group = var.label_ansible_group
  env = var.label_env
}
[...]
```
- terraform/prod/variables.tf
```
[...]
variable label_env {
  type    = string
  description = "dev, stage, prod and etc."
  default     = "prod"
}
[...]
```
- terraform/prod/main.tf
```
[...]
label_env = var.label_env
[...]
```
- terraform/stage/variables.tf
```
[...]
variable label_env {
  type    = string
  description = "dev, stage, prod and etc."
  default     = "stage"
}
[...]
```
- terraform/stage/main.tf
```
[...]
label_env = var.label_env
[...]
```
Поднимем среду для прода terraform/prod и попробуем выполнить ansible-playbook playbooks/site.yml --check,
```
[...]
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost
does not match 'all'
[WARNING]: While constructing a mapping from
/home/immon4ik/otus/hw/ansible-3/ansible/roles/jdauphant.nginx/tasks/configuration.yml, line 62, column 3,
found a duplicate dict key (when). Using last defined value only.
[WARNING]: Could not match supplied host pattern, ignoring: db
[...]
```
Результат говорит о работе меток, т.к. настроено дефолтное использование динамического инвентори для среды окружения stage.
Выполнив  ansible-playbook -i environments/prod/inventory_gcp.yml playbooks/site.yml получаю настроенное приложение работающее на 80 порту и хосты доступные для дополнительных пользователей.
### Задание с **.
С использованием открытых источников(*https://docs.travis-ci.com/user/job-lifecycle/#breaking-the-build*) созданна следущая структура для выполнения задания:
```
play-travis/ansible-3/run_tests_in_docker.sh - скрипт для TravisCI, выполняется после тестов из ДЗ№3,передает команды в контейнер с тестами, использует пользователя appuser.
play-travis/ansible-3/tests/controls/ansible.rb packer.rb terraform.rb - сценарии тестов для приложений, указанных в задании. Применяется packer validate для всех шаблонов, terraform validate и tflint для окружений stage и prod, ansible-lint для плейбуков ansible.
play-travis/ansible-3/tests/inspec.yml - конфигурационный файл для запуска inspec, в нашей реализации не используется.
play-travis/ansible-3/tests/run_tests.sh - скрипт преподготовки среды тестирования и запуска тестов из подготовленных сценариев.
```
С использованием открытых источников(*https://docs.travis-ci.com/user/job-lifecycle/#breaking-the-build*) изменен .travis.yml для выполнения скриптов и сценариев созданной среды тестирования:
```
[...]
before_script:
- curl https://raw.githubusercontent.com/otus-devops-2019-11/immon4ik_infra/ansible-3/play-travis/ansible-3/run_tests_in_docker.sh | bash
[...]

```
