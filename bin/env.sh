# Script: Env
# Description: DShared environment variables for WIRIS Moodle Docker scripts.

# Get the Moodle major/minor version from either a branch name or a release tag.
if [[ "$WIRIS_MOODLE_BRANCH" =~ ^v?([0-9]+)\.([0-9]+) ]]; then
    MOODLE_VERSION=$(printf "%02d%02d" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}")
elif [ "$WIRIS_MOODLE_BRANCH" = "main" ]; then
    MOODLE_VERSION=9999
else
    MOODLE_VERSION=$(echo "$WIRIS_MOODLE_BRANCH" | sed "s/MOODLE_//" | sed "s/_STABLE//")
    MOODLE_VERSION=$(printf %04d "$MOODLE_VERSION")
fi

if [ "$MOODLE_VERSION" -lt "0501" ];
then
    MOODLE_PUBLIC_ROOT="${MOODLE_DOCKER_WWWROOT}"
    MOODLE_RELATIVE_ROOT="."
else
    MOODLE_PUBLIC_ROOT="${MOODLE_DOCKER_WWWROOT}/public"
    MOODLE_RELATIVE_ROOT="public"
fi

echo "=> Moodle version: $MOODLE_VERSION detected. Using public root: $MOODLE_PUBLIC_ROOT"