#!/bin/bash

# vim:fdm=marker

# Components                                                                {{{1
# ==============================================================================

BUTTER_CHICKEN_REPOS=(
    # elsevier-research/kd-search-test
    elsevier-research/kd-apollo-router
    elsevier-research/kd-app-framework
    elsevier-research/kd-app-template
    elsevier-research/kd-artefacts
    elsevier-research/kd-automation-autocomplete
    elsevier-research/kd-automation-document-embeddings
    elsevier-research/kd-automation-enricher
    elsevier-research/kd-automation-genai
    elsevier-research/kd-automation-splitter
    elsevier-research/kd-automation-stitcher
    elsevier-research/kd-cto-legacy-rest-test
    elsevier-research/kd-docker-images
    elsevier-research/kd-document-embedding
    elsevier-research/kd-document-embedding-sagemaker-mme
    elsevier-research/kd-document-splitter
    elsevier-research/kd-document-stitcher
    elsevier-research/kd-ds-embedding-service
    elsevier-research/kd-ds-experiment-template
    elsevier-research/kd-ds-experiments
    elsevier-research/kd-ds-indextract
    elsevier-research/kd-ds-teddy
    elsevier-research/kd-eagle-sqs-publish
    elsevier-research/kd-enricher
    elsevier-research/kd-evaluation-framework
    elsevier-research/kd-evaluation-integration
    elsevier-research/kd-evaluation-service
    elsevier-research/kd-facade-service
    elsevier-research/kd-facade-service-perf-test
    elsevier-research/kd-facade-service-test
    elsevier-research/kd-genai-java-service
    elsevier-research/kd-genai-service
    elsevier-research/kd-graph-service-api-spec
    elsevier-research/kd-helm-charts
    elsevier-research/kd-ingestion-performance-poc
    elsevier-research/kd-jenkins-pipelines
    elsevier-research/kd-kafka-common
    elsevier-research/kd-mic-lambda
    elsevier-research/kd-multibranch-test
    elsevier-research/kd-performance-embeddings
    elsevier-research/kd-performance-genai
    elsevier-research/kd-performance-mendeley
    elsevier-research/kd-performance-sss
    elsevier-research/kd-person-finder-service
    elsevier-research/kd-personfinder-performance
    elsevier-research/kd-pf-tools
    elsevier-research/kd-python-app-test
    elsevier-research/kd-queruintent-analysis
    elsevier-research/kd-query-intent
    elsevier-research/kd-query-simulation
    elsevier-research/kd-queryintent-analysis
    elsevier-research/kd-queryintent-performancetesting
    elsevier-research/kd-scopus-search
    elsevier-research/kd-scripts-etc
    elsevier-research/kd-sda-batch-full-ingestion-poc
    elsevier-research/kd-sebright-app
    elsevier-research/kd-shared-search-api
    elsevier-research/kd-similarsearch-automation
    elsevier-research/kd-similarsearch-performancetesting
    elsevier-research/kd-sources-search-service-perf-test
    elsevier-research/kd-sources-search-service-test
    elsevier-research/kd-tio-ansible-es-config
    elsevier-research/kd-tio-ansible-neo4j
    elsevier-research/kd-tio-docker-neo4j
    elsevier-research/kd-tio-jenkinscontrol
    elsevier-research/kd-tio-kong-consumers-and-services
    elsevier-research/kd-tio-puppetcontrol
    elsevier-research/kd-tio-solr-docker
    elsevier-research/kd-tio-terraform
    elsevier-research/kd-tio-terraform-neo4j-enterprise
    elsevier-research/kd-vector-calculation-service
    elsevier-research/kd-vector-dbs
    elsevier-research/kd-xocs-feed-translator-test
    elsevier-research/poc-kd-genai-multiagent
)
BUTTER_CHICKEN_INFRA_REPOS=(
    elsevier-research/kd-author-relations-store-infra
    elsevier-research/kd-aws-newrelic-infra
    elsevier-research/kd-cto-legacy-rest-infra
    elsevier-research/kd-document-relations-store-infra
    elsevier-research/kd-evaluation-service-infra
    elsevier-research/kd-hydration-graphql-infra
    elsevier-research/kd-organization-hydration-graphql-infra
    elsevier-research/kd-person-hydration-graphql-infra
    elsevier-research/kd-person-relations-store-infra
    elsevier-research/kd-person-traversal-graphql-infra
    elsevier-research/kd-scival-graphql-infra
    elsevier-research/kd-shared-search-graphql-infra
    elsevier-research/kd-sources-search-service-infra
    elsevier-research/kd-tio-ansible-newrelic-infra-agent
    elsevier-research/kd-work-hydration-graphql-infra
)

SPIROGRAPH_REPOS=(
    elsevier-research/kd-graph-airflow
    elsevier-research/kd-graph-automation
    elsevier-research/kd-graph-comparer
    elsevier-research/kd-graph-data-validator
    elsevier-research/kd-graph-metrics-api
    elsevier-research/kd-graph-neo4j-h-index
    elsevier-research/kd-graph-neo4j-poc
    elsevier-research/kd-graph-performance-test
    elsevier-research/kd-graph-quality-notebooks
    elsevier-research/kd-graph-service-test-automation
    elsevier-research/kd-graph-updater
    elsevier-research/kd-graph-version-manager
    elsevier-research/kd-graphql-gateway
    elsevier-research/kd-organization-hydration-graphql-test
    elsevier-research/kd-person-hydration-graphql-test
    elsevier-research/kd-person-traversal-graphql-test
    elsevier-research/kd-work-hydration-graphql-test
    elsevier-research/kd-work-traversal-graphql-test
)

MISC_REPOS=(
    elsevier-research/kd-architecture-n-design
    elsevier-research/kd-automation-graphql-mendeley-search
    elsevier-research/kd-automation-shared-search
    elsevier-research/kd-ds-pagerank-graph
    elsevier-research/kd-performance-shared-search
    elsevier-research/kd-scopus-search
    elsevier-research/kd-scopus-search2
    elsevier-research/kd-search-akka-healthcheck
    elsevier-research/kd-search-autocomplete-indexer
    elsevier-research/kd-search-basistech-packaging
    elsevier-research/kd-search-components
    elsevier-research/kd-search-cronkins-jobs
    elsevier-research/kd-search-cto-service-deploy
    elsevier-research/kd-search-cursormark-loadtest
    elsevier-research/kd-search-enrichment-module
    elsevier-research/kd-search-fps-client
    elsevier-research/kd-search-index-copy-scripts
    elsevier-research/kd-search-indexing-airflow
    elsevier-research/kd-search-indexing-pipeline-changes
    elsevier-research/kd-search-jmeter-plugins-exit-status
    elsevier-research/kd-search-jvm-heap-dump-analysis-box
    elsevier-research/kd-search-organisation-autocomplete-solr
    elsevier-research/kd-search-qi-entity-recognition
    elsevier-research/kd-search-query-insights
    elsevier-research/kd-search-scopus-loadtest-generator
    elsevier-research/kd-search-scopus-solr
    elsevier-research/kd-search-scopus-sources-api
    elsevier-research/kd-search-scopus-support-scripts
    elsevier-research/kd-search-scopus-tools
    elsevier-research/kd-search-scopus-updates-feed-generator
    elsevier-research/kd-search-solr-config-maven-plugin
    elsevier-research/kd-search-solr-handler-deploy
    elsevier-research/kd-search-solr-loadtests
    elsevier-research/kd-search-solr-paas
    elsevier-research/kd-search-solr-paas-deploy
    elsevier-research/kd-search-solr-packaging
    elsevier-research/kd-search-sqs-recorder-replayer
    elsevier-research/kd-search-taxonomy-service
    elsevier-research/kd-search-test
    elsevier-research/kd-search-xml-tag-transformer
    elsevier-research/kd-search-xocs-parser
    elsevier-research/kd-shared-search-autocomplete-poc
    elsevier-research/kd-shared-search-kafka-connect
    elsevier-research/kd-shared-search-mapping-generation
    elsevier-research/kd-shared-search-performance
    elsevier-research/kd-shared-search-tools
    elsevier-research/kd-shared-search-tools-service
    elsevier-research/kd-tio-ansible-shared-search-api
    elsevier-research/kd-tio-ansible-shared-search-es
    elsevier-research/kd-tio-ansible-shared-search-service
    elsevier-research/kd-tio-ansible-similar-search
    elsevier-research/kd-tio-graph-docker
    elsevier-research/kd-tio-puppet-scopus-search-service
    elsevier-research/kd-tio-puppet-searchindexfeedproducer
    elsevier-research/kd-tio-puppet-searchupdatefeedproducer
    elsevier-research/kd-tio-puppet-shared-search-api
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
    #local repoUrl="git@github.com:${repo}.git" ## For SSH
    local repoUrl="git@github-work:${repo}.git" ## For SSH and multiple keys

    if [[ ! -e "${clonePath}" ]]; then
        echo git clone --recursive "${repoUrl}"
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

    mkdir -p "${clonePath}"

    pushd "${clonePath}" > /dev/null || exit 1
    for URL in "${projects[@]}"
    do
        clone-project "$URL"
    done
    popd > /dev/null || exit 1
}

# Clone code
clone-projects-into butter-chicken       "${BUTTER_CHICKEN_REPOS[@]}"
clone-projects-into butter-chicken/infra "${BUTTER_CHICKEN_INFRA_REPOS[@]}"

clone-projects-into spirograph     "${SPIROGRAPH_REPOS[@]}"
clone-projects-into misc           "${MISC_REPOS[@]}"
