#!/usr/bin/env bash
HOMEWORK_RUN=./play-travis/ansible-3/tests/run_tests.sh

# Запуск скрипта преподготовки среды тестирования и выполнения тестов из подготовленных сценариев.
# Используется пользователь не immon4ik, а appuser, т.к. в контейнере создан только пользователь appuser.
if [ -f $HOMEWORK_RUN ]; then
	echo "Run tests (linters, validators)"
	# sudo pip install --upgrade pip
	# sudo pip install -r ansible/requirements.txt
	# ansible --version
	# ansible-lint --version
	# terraform --version
	# packer --version
	# find . -type f -name '*.tf' -exec terraform fmt {} \;
	# cp terraform/prod/terraform.tfvars.example terraform/prod/terraform.tfvars
	# cp terraform/stage/terraform.tfvars.example terraform/stage/terraform.tfvars
	# terraform get terraform/stage
	# find terraform/stage -type f -name '*.tf' -exec tflint --ignore-module=SweetOps/storage-bucket/google {} \;
	# terraform get terraform/prod
	# find terraform/prod -type f -name '*.tf' -exec tflint --ignore-module=SweetOps/storage-bucket/google {} \;
	# find . -type f -name '*.json' -exec packer validate -var-file=packer/variables.json.example {} \;
	# find . -type f -name '*.yml' -exec ansible-lint {} \;
	docker exec -e USER=appuser hw-test $HOMEWORK_RUN
else
	echo "We don't have any tests"
	exit 0
fi
