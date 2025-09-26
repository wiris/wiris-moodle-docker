# Script: Env
# Description: DShared environment variables for WIRIS Moodle Docker scripts.

if [ -d "${MOODLE_DOCKER_WWWROOT}/public" ];
then
    MOODLE_PUBLIC_ROOT="${MOODLE_DOCKER_WWWROOT}/public"
    MOODLE_RELATIVE_ROOT="public"
else
    MOODLE_PUBLIC_ROOT="${MOODLE_DOCKER_WWWROOT}"
    MOODLE_RELATIVE_ROOT="./"
fi

echo "=> Moodle root path is set to: $MOODLE_PUBLIC_ROOT"