#!/bin/bash
set -x

# Authors : Steven GOURVES

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#! MAIN:
#!   Function to remove pipelines with a given project id and
#!   the number of pipelines to keep.
#!
#! USAGE:
#!   ./clear-pipelines.sh <job-token> <package-id> <pipeline-nb-to-keep>
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function clear_pipelines {
    GITLAB_API="https://gitlab.papierpain.fr/api/v4"
    GITLAB_TOKEN="$1"

    PROJECT_ID="$2"
    NB_PIPELINES_TO_KEEP="$3"

    # Get all pipelines
    PIPELINES=$(curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_API}/projects/${PROJECT_ID}/pipelines?per_page=500")

    # Generate an array of pipeline ids
    IFS=$'\n'
    PIPELINE_IDS=($(echo "$PIPELINES" | jq -r '.[] | .id'))

    # Get the ids of the NB_PIPELINES_TO_KEEP most recent pipelines
    PIPELINE_IDS_TO_KEEP=("${PIPELINE_IDS[@]:0:$NB_PIPELINES_TO_KEEP}")

    # Show the number of pipelines
    echo "Number of pipelines: ${#PIPELINE_IDS[@]}"
    # Show the ids of the pipelines to keep
    echo "Pipeline ids to keep: ${PIPELINE_IDS_TO_KEEP[@]}"

    # Remove the pipelines ids to keep in the array of pipeline ids
    PIPELINE_IDS_TO_REMOVE=()
    for i in "${!PIPELINE_IDS[@]}"; do
        if [[ ! " ${PIPELINE_IDS_TO_KEEP[@]} " =~ " ${PIPELINE_IDS[i]} " ]]; then
            PIPELINE_IDS_TO_REMOVE+=(${PIPELINE_IDS[i]})
        fi
    done

    # Show the ids of the pipelines to remove
    echo "Pipeline ids to remove: ${PIPELINE_IDS_TO_REMOVE[@]}"

    # Remove the pipelines
    for i in "${!PIPELINE_IDS_TO_REMOVE[@]}"; do
        curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_API}/projects/${PROJECT_ID}/pipelines/${PIPELINE_IDS_TO_REMOVE[i]}" -X DELETE
    done
}

clear_pipelines $1 $2 $3
