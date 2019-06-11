DATE=`date +%Y-%m-%d`
ifndef GIT_BRANCH
GIT_BRANCH := $(shell git branch | grep \* | cut -d ' ' -f2)
endif

print-%  : ; @echo $* = $($*)

all: prepare build push cleanup

prepare:
	docker pull gone/php:cli-php5.6
	docker pull gone/php:cli-php7.0
	docker pull gone/php:cli-php7.1
	docker pull gone/php:cli-php7.2
	docker pull gone/php:cli-php7.3
	sed 's/FROM\ gone\/php:cli/FROM gone\/php\:cli\-php5.6/g' Dockerfile > Dockerfile.php56
	sed 's/FROM\ gone\/php:cli/FROM gone\/php\:cli\-php7.0/g' Dockerfile > Dockerfile.php70
	sed 's/FROM\ gone\/php:cli/FROM gone\/php\:cli\-php7.1/g' Dockerfile > Dockerfile.php71
	sed 's/FROM\ gone\/php:cli/FROM gone\/php\:cli\-php7.2/g' Dockerfile > Dockerfile.php72
	sed 's/FROM\ gone\/php:cli/FROM gone\/php\:cli\-php7.3/g' Dockerfile > Dockerfile.php73

build-php5.6:
	docker build -t gone/mule:php5.6 -f Dockerfile.php56 .
build-php7.0:
	docker build -t gone/mule:php7.0 -f Dockerfile.php70 .
build-php7.1:
	docker build -t gone/mule:php7.1 -f Dockerfile.php71 .
build-php7.2:
	docker build -t gone/mule:php7.2 -f Dockerfile.php72 .
build-php7.3:
	docker build -t gone/mule:php7.3 -f Dockerfile.php73 .

build:
	$(MAKE) build-php5.6
	$(MAKE) build-php7.0
	$(MAKE) build-php7.1
	$(MAKE) build-php7.2
	$(MAKE) build-php7.3

tag:
	docker tag gone/mule:php7.3 gone/mule:latest
	docker tag gone/mule:latest gone/mule:$(DATE)
	docker tag gone/mule:latest	gone/jenkins-slave:latest
	docker tag gone/mule:latest	gone/jenkins-slave:$(DATE)

push:
ifeq ($(GIT_BRANCH), master)
	docker push gone/mule:php5.6
	docker push gone/mule:php7.0
	docker push gone/mule:php7.1
	docker push gone/mule:php7.2
	docker push gone/mule:php7.3
	docker push gone/mule:latest
	docker push gone/mule:$(DATE)
	docker push gone/jenkins-slave:latest
	docker push gone/jenkins-slave:$(DATE)
else
	echo "Skipping push, on branch \"$(GIT_BRANCH)\" not on branch \"master\""
endif

cleanup:
	rm Dockerfile.php*
