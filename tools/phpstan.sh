#!/bin/bash -
php -d memory_limit=-1 "$(which phpstan)" --memory-limit=4G "$@"
