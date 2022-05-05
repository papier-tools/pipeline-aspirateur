#!/bin/bash
set -x

# Authors : Steven GOURVES

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#! MAIN:
#!   Function to remove artifacts with a given project id.
#!
#! USAGE:
#!   ./clear-artifacts.sh <job-token> <package-id>
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function clear_artifacts {
    GITLAB_API="https://gitlab.papierpain.fr/api/v4"
    GITLAB_TOKEN="$1"

    PROJECT_ID="$2"

    curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_API}/projects/${PROJECT_ID}/artifacts" -X DELETE
}

clear_artifacts $1 $2
