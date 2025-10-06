# Script: Env
# Description: DShared environment variables for WIRIS Moodle Docker scripts.

# Get the version number of the moodle branch
MOODLE_VERSION=`echo ${WIRIS_MOODLE_BRANCH} | sed "s/MOODLE_//" | sed "s/_STABLE//"`
# Pad left tree 0 on the version number
if [ $WIRIS_MOODLE_BRANCH != "master" ]; then
    MOODLE_VERSION=$(printf %04d $MOODLE_VERSION)
else 
    MOODLE_VERSION=9999
fi

if [ $MOODLE_VERSION -lt "0501"  ];
then
    MOODLE_PUBLIC_ROOT="${MOODLE_DOCKER_WWWROOT}"
    MOODLE_RELATIVE_ROOT="."
else
    MOODLE_PUBLIC_ROOT="${MOODLE_DOCKER_WWWROOT}/public"
    MOODLE_RELATIVE_ROOT="public"
fi

echo "=> Moodle root path is set to: $MOODLE_PUBLIC_ROOT"