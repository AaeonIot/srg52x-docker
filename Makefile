#!/usr/bin/make

USER_ID := $(shell id -u)
ifeq ($(USER_ID),0)
	USER_ID = 1000
endif

export USER_ID

start:
	docker-compose run srg52x-app-dev

refresh:
	# Rebuild docker image
	docker-compose build --no-cache srg52x-app-dev

cleanall:
	docker-compose rm -svf srg52x-app-dev
	docker rmi -f srg52x-app-dev

.PHONY: refresh start cleanall
