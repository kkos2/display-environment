#!/usr/bin/env bash
#
# Set submodule revision
#
# A small wrapper around updating a submodule in a consistent manner
#

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ -z "${APP:-}" ]] ; then
    echo "Missing APP environment variable"
    exit 1
fi

if [[ -z "${REFSPEC:-}" ]] ; then
    echo "Missing REFSPEC environment variable"
    exit 1
fi

SUBMODULE_DIRECTORY=""

# Figure out the name of the submodule
# This could probably have been extracted from git, but this will do for now.
case ${APP} in

  admin)
    SUBMODULE_DIRECTORY="display-admin-client"
    ;;

  api)
    SUBMODULE_DIRECTORY="display-api-service"
    ;;

  client)
    SUBMODULE_DIRECTORY="display-client"
    ;;

  integration)
    SUBMODULE_DIRECTORY="kk-display-integration"
    ;;

  *)
    echo "Unknown app ${APP}"
    exit 1
    ;;
esac

REVISION_FILE="${APP}-revision.txt"

cd "${SCRIPT_DIR}/../apps/${APP}"
cd "${SUBMODULE_DIRECTORY}"
# Fetch the refspec - doing this up front ensures that it actually exists before
# we start doing anything drastic.
git fetch origin "${REFSPEC}"
# Make sure we clean with regards to the current revision
git clean -df
# Then reset the working directory to this ref.
git reset --hard origin/"${REFSPEC}"
# Find out what the refspec resolved to. Eg, get the SHA for the tag we just
# checked out.
SUBMODULE_SHA=$(git rev-parse HEAD)
cd ..

cat <<EOT > "${REVISION_FILE}"
refspec: ${REFSPEC}
sha: ${SUBMODULE_SHA}
EOT

# See if the submodule actually moved - if not, abort
if [[ -z $(git status --porcelain "${SUBMODULE_DIRECTORY}" "${REVISION_FILE}") ]]; then
    echo "No change change detected after jumping to ${REFSPEC}, aborting update"
    exit
fi
git add "${SUBMODULE_DIRECTORY}"
git add "${REVISION_FILE}"
echo "Comitting updated revision file and submodule"
git commit -m "Updating ${APP} to ${REFSPEC} (sha: ${SUBMODULE_SHA})"
