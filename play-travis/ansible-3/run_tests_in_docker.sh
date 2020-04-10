#!/usr/bin/env bash
HOMEWORK_RUN=./play-travis/ansible-3/tests/run_tests.sh

# Запуск скрипта преподготовки среды тестирования и выполнения тестов из подготовленных сценариев.
# Используется пользователь не immon4ik, а appuser, т.к. в контейнере создан только пользователь appuser.
if [ -f $HOMEWORK_RUN ]; then
	echo "Run tests (linters, validators)"
	sudo pip install -r ansible/requirements.txt
	ansible --version
	ansible-lint --version
	terraform --version
	packer --version
	docker exec -e USER=appuser hw-test $HOMEWORK_RUN
else
	echo "We don't have any tests"
	exit 0
fi
