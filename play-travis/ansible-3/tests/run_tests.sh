#!/usr/bin/env bash
set -e

# Создание подложного ключа ssh для возможности тестов конфигов terraform.
# Используется пользователь не immon4ik, а appuser, т.к. в контейнере создан только пользователь appuser.
touch ~/.ssh/appuser.pub ~/.ssh/appuser

# Установка софта для окружения и ролей из ansible-galaxy, описанные в requirements.yml.
# sudo pip install -r ansible/requirements.txt
pwd && ls
ansible --version
ansible-lint --version
terraform --version
packer --version
# cd ansible && ansible-galaxy install -r environments/stage/requirements.yml && cd ..

# Запуск inspec.
inspec exec play-travis/ansible-3/tests/
