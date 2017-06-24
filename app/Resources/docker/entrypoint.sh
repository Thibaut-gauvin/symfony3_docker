#!/usr/bin/env bash

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
  ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
BOLD="$(tput bold)"
NORMAL="$(tput  sgr0)"
else
RED=""
GREEN=""
YELLOW=""
BLUE=""
BOLD=""
NORMAL=""
fi

echo "Install Composer dependencies"
/bin/bash -l -c "cd /home/docker && composer install --no-interaction --prefer-dist"

echo ''
echo '---------------------------------------'
echo ''

echo "Create database schema"
/bin/bash -l -c "cd /home/docker && php bin/console doctrine:schema:update --force"

echo ''
echo '---------------------------------------'
echo ''

echo ''
printf "${YELLOW}"
echo "Success, Your are ready to develop ! :D"
echo "take a look at http://symfony.dev"
printf "${NORMAL}"
echo ''
