#!/bin/bash

# vim:fdm=marker

# Components                                                                {{{1
# ==============================================================================

COMPONENT_REPOS=(
    # elsevier-research/kd-architecture-n-design
    elsevier-research/kd-recs-airflow-dags
    elsevier-research/kd-recs-api
    elsevier-research/kd-recs-api-common
    elsevier-research/kd-recs-api-jobs
    elsevier-research/kd-recs-api-performance
    elsevier-research/kd-recs-api-system-tests
    elsevier-research/kd-recs-app-common
    elsevier-research/kd-recs-auth-common
    elsevier-research/kd-recs-aws
    elsevier-research/kd-recs-bos-api-common
    elsevier-research/kd-recs-build
    elsevier-research/kd-recs-collaborative-filtering-lib
    elsevier-research/kd-recs-common-config
    elsevier-research/kd-recs-core-contracts
    elsevier-research/kd-recs-data-access-lib
    elsevier-research/kd-recs-data-access-spark-for-recs-lib
    elsevier-research/kd-recs-data-access-spark-lib
    elsevier-research/kd-recs-domain-lib
    elsevier-research/kd-recs-event-log-processor
    elsevier-research/kd-recs-event-logger-lambda
    elsevier-research/kd-recs-events-common
    elsevier-research/kd-recs-feature-store
    elsevier-research/kd-recs-funding-opportunities-processor
    elsevier-research/kd-recs-interview
    elsevier-research/kd-recs-kafka-connectors
    elsevier-research/kd-recs-kafka-performance
    elsevier-research/kd-recs-keyfe-commons
    elsevier-research/kd-recs-local-testing-utils
    elsevier-research/kd-recs-logging-dependencies
    elsevier-research/kd-recs-mendeley-end-to-end
    elsevier-research/kd-recs-mendeley-suggest
    elsevier-research/kd-recs-mendeley-suggest-event-processing
    elsevier-research/kd-recs-mendeley-users-scopus-events-generator
    elsevier-research/kd-recs-offline-evaluation
    elsevier-research/kd-recs-pact-verifier
    elsevier-research/kd-recs-pipelines-visualiser-lib
    elsevier-research/kd-recs-rankymcrankface
    elsevier-research/kd-recs-record-loader
    elsevier-research/kd-recs-reviewers-data-pump-lambda
    elsevier-research/kd-recs-reviewers-deletion-lambda
    elsevier-research/kd-recs-reviewers-jobs
    elsevier-research/kd-recs-reviewers-quality-metrics
    elsevier-research/kd-recs-reviewers-recommender-api
    elsevier-research/kd-recs-reviewers-recommender-common
    elsevier-research/kd-recs-reviewers-recommender-lambda
    elsevier-research/kd-recs-ros-recommender-cf
    elsevier-research/kd-recs-ros-recommender-common
    elsevier-research/kd-recs-s3-to-kinesis-lambda
    elsevier-research/kd-recs-scopus-access-lib
    elsevier-research/kd-recs-scopus-article-metadata-extractor
    elsevier-research/kd-work-recommendations-graphql
    elsevier-research/kd-work-recommendations-graphql-test
    elsevier-research/kd-work-recommendations-graphql-infra
    elsevier-research/kd-recs-scripts
    elsevier-research/kd-recs-sd-article-metadata-extractor
    elsevier-research/kd-recs-sd-article-recommender-api
    elsevier-research/kd-recs-sd-citation-snippets-generator
    elsevier-research/kd-recs-sd-generator
    elsevier-research/kd-recs-sd-learning-to-rank
    elsevier-research/kd-recs-spark-recommendation-evaluation
    elsevier-research/kd-recs-spark-test
    elsevier-research/kd-recs-sutd-kafka-producer
    elsevier-research/kd-recs-sutd-limf-recommendation-generator
    elsevier-research/kd-recs-sutd-service-tests
    elsevier-research/kd-recs-sutd-user-signals-generator
    elsevier-research/kd-recs-tech-spikes
    elsevier-research/kd-recs-test-data
    elsevier-research/kd-recs-utils
    elsevier-research/kd-recs-validation
    elsevier-research/kd-recs-validation-app
    elsevier-research/kd-recs-integration-testing-utils
)
STACK_REPOS=(
    elsevier-research/kd-recs-spark-emr-stack
)
INFRA_REPOS=(
    elsevier-research/kd-recs-airflow-dags
    elsevier-research/kd-recs-core-infra
    elsevier-research/kd-recs-data-pipelines
    elsevier-research/kd-recs-data-pipelines-base
    elsevier-research/kd-recs-docker-es-curator
    elsevier-research/kd-recs-event-service-infra
    elsevier-research/kd-recs-funding-infra
    elsevier-research/kd-recs-github-actions
    elsevier-research/kd-recs-homebrew-tools
    elsevier-research/kd-recs-infra
    elsevier-research/kd-recs-main-eks
    elsevier-research/kd-recs-newrelic-terraform-generator
    elsevier-research/kd-recs-packer-builds
    elsevier-research/kd-recs-portal
    elsevier-research/kd-recs-reviewers-infra
    elsevier-research/kd-recs-secrets
    elsevier-research/kd-recs-terraform-newrelic
    elsevier-research/kd-recs-terraform-tags
    elsevier-research/kd-recs-util-eks
    elsevier-research/kd-recs-util-jenkins-jobs
    elsevier-research/kdp-recs-terraform-ec2
    elsevier-research/kd-recs-instance-scheduler
)
DS_REPOS=(
    elsevier-research/datascience-recs-reviewers-bias-causality
    elsevier-research/kd-recs-api-performance-tests
    elsevier-research/kd-recs-causal-inference
    elsevier-research/kd-recs-cicd-test-repo
    elsevier-research/kd-recs-manuscript-fit-ds
    elsevier-research/kd-recs-reviewer-pytorch
    elsevier-research/kd-recs-reviewers-ds-daniel-kershaw
    elsevier-research/kd-recs-reviewers-ds-evaluation-libary
    elsevier-research/kd-recs-reviewers-ds-experiments
    elsevier-research/kd-recs-reviewers-ds-pipelines
    elsevier-research/kd-recs-sd-homie
    elsevier-research/kd-recs-specter
)
ARCHIVED_REPOS=(
    elsevier-research/kd-recs-aws-test
    elsevier-research/kd-recs-data-pipeline-newrelic-lambda
    elsevier-research/kd-recs-data-pipeline-trigger-lambda
    elsevier-research/kd-recs-elasticsearch-common
    elsevier-research/kd-recs-elasticsearch-loader
    elsevier-research/kd-recs-enhanced-reading
    elsevier-research/kd-recs-events-service
    elsevier-research/kd-recs-evise-reviewers-tests
    elsevier-research/kd-recs-funding-institutional-recommendations-api
    elsevier-research/kd-recs-mendeley-funding-recommendations-api
    elsevier-research/kd-recs-mendeley-profile-data-converter
    elsevier-research/kd-recs-mendeley-user-representation-common
    elsevier-research/kd-recs-mendeley-user-representation-generator
    elsevier-research/kd-recs-mendeley-user-representation-infra
    elsevier-research/kd-recs-rev-sagemaker
    elsevier-research/kd-recs-ros-recommender-dataformats
    elsevier-research/kd-recs-sutd-offline-evaluation
    elsevier-research/kd-recs-sutd-recs-generator
)
 
# Constants                                                                 {{{1
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'

# Functions                                                                 {{{1
# ==============================================================================

function msg-success() {
    local msg=$1
    printf "${CLEAR_LINE}${GREEN}✔ ${msg}${NO_COLOR}\n"
}

function msg-error() {
    local msg=$1
    printf "${CLEAR_LINE}${RED}✘ ${msg}${NO_COLOR}\n"
}

function clone-project() {
    local repo=$1
    local localPath="${repo##*/}"
    local clonePath="${localPath%.*}"

    #local repoUrl="https://github.com/${repo}.git" ## For HTTPS
    local repoUrl="git@github.com:${repo}.git" ## For SSH
    #local repoUrl="git@github-work:${repo}.git" ## For SSH and multiple keys

    if [[ ! -e "${clonePath}" ]]; then
        git clone --recursive "${repoUrl}"
    fi

    if [[ -e "${clonePath}" ]]; then
        msg-success "Exists: ${clonePath}"
    else
        msg-error "Error:  Failed to clone ${repoUrl}"
    fi
}

function clone-projects-into() {
    local clonePath="$1"
    shift
    local projects=("$@")

    pushd "${clonePath}" > /dev/null || exit 1
    for URL in "${projects[@]}"
    do
        clone-project "$URL"
    done
    popd > /dev/null || exit 1
}

# Clone code
clone-projects-into . "${COMPONENT_REPOS[@]}"

# Clone tech-stacks
mkdir -p tech-stacks
clone-projects-into ./tech-stacks "${STACK_REPOS[@]}"

# Clone infra
mkdir -p infra
clone-projects-into ./infra "${INFRA_REPOS[@]}"

# Clone DS
## mkdir -p ds
## clone-projects-into ./ds "${DS_REPOS[@]}"

# Clone archived
## mkdir -p archived
## clone-projects-into ./archived "${ARCHIVED_REPOS[@]}"
