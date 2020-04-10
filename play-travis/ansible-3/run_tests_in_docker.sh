#!/bin/bash
GROUP=2019-11
BRANCH=${TRAVIS_PULL_REQUEST_BRANCH:-$TRAVIS_BRANCH}
HOMEWORK_RUN=./otus-homeworks/homeworks/$BRANCH/run.sh
REPO=https://github.com/express42/otus-homeworks.git
DOCKER_IMAGE=express42/otus-homeworks:0.7.1
HOMEWORK_RUN=./play-travis/ansible-3/tests/run_tests.sh

echo GROUP:$GROUP

if [ "$BRANCH" == "" ]; then
	echo "We don't have tests for master branch"
	exit 0
fi

echo HOMEWORK:$BRANCH

echo "Clone repository with tests"
git clone -b $GROUP --single-branch $REPO

# Запуск скрипта преподготовки среды тестирования и выполнения тестов из подготовленных сценариев.
# Используется пользователь не immon4ik, а appuser, т.к. в контейнере создан только пользователь appuser.
if [ -f $HOMEWORK_RUN ]; then
	echo "Run tests (linters, validators)"
	docker exec -e USER=appuser hw-test $HOMEWORK_RUN
else
	echo "We don't have any tests"
	exit 0
fi
