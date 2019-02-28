#!/bin/bash -
php -d memory_limit=-1 "$HOME/.composer/vendor/bin/phpstan" --memory-limit=-1 "$@"
