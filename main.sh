#!/bin/bash
set -x

# Authors : Steven GOURVES

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#! MAIN:
#!   Clear artifacts and pipelines in all projects.
#!
#! USAGE:
#!   ./main.sh <job-token>
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

JOB_TOKEN=$1
GITLAB_API="https://gitlab.papierpain.fr/api/v4"

echo "Get all projects..."
PROJECTS=$(curl --header "PRIVATE-TOKEN: ${JOB_TOKEN}" "${GITLAB_API}/projects?per_page=500")

echo "Get the project ids..."
IFS=$'\n'
PROJECT_IDS=($(echo "${PROJECTS}" | jq -r '.[] | .id'))

for i in "${!PROJECT_IDS[@]}"; do
    functions/clear_pipelines "${JOB_TOKEN}" "${PROJECT_IDS[i]}" 5
    functions/clear_artifacts "${JOB_TOKEN}" "${PROJECT_IDS[i]}"
done
