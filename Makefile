freeze:
	pip freeze > requirements.txt

build:
	sudo docker-compose -f docker/docker-compose.yml build

rund:
	sudo docker-compose -f docker/docker-compose.yml up -d

run:
	sudo docker-compose -f docker/docker-compose.yml up

stop:
	sudo docker-compose -f docker/docker-compose.yml down


configrm:
	sudo rm ~/.docker/config.json

shell:
	docker run -it --entrypoint /bin/bash ner-req


prune:
	@echo "Are you sure you want to prune all stopped containers, unused networks, images, build cache and volumes? [yes/no]"
	@read ans; \
	if [ $$ans = "yes" ]; then \
		sudo docker system prune -a -f --volumes; \
	else \
		echo "Prune cancelled."; \
	fi

push:
	docker/ecr.sh

deploy: ##=> Deploy to AWS Lambda
	./sam.sh dev

deploy_prod:
	./sam.sh prod