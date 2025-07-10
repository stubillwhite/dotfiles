#!/bin/bash

# vim:fdm=marker

# RDP repos                                                                 {{{1
# ==============================================================================

# Architecture                      {{{2
# ======================================

ARCHITECTURE_REPOS=(
    elsevier-research/architecture-research-vocabulary
    elsevier-research/data-platform-adr
    elsevier-research/rtarchitecture-adrs
)

# DKP                               {{{2
# ======================================

DKP_REPOS=(
    elsevier-research/dkp-aws-scripts
    elsevier-research/dkp-batch-rest-tests
    elsevier-research/dkp-core
    elsevier-research/dkp-core-authentication
    elsevier-research/dkp-core-batch
    elsevier-research/dkp-core-dereferencing-service
    elsevier-research/dkp-core-imagefinder
    elsevier-research/dkp-core-platform
    elsevier-research/dkp-core-resources-service
    elsevier-research/dkp-core-vtw-integration
    elsevier-research/dkp-ewii-pcmt
    elsevier-research/dkp-image-finder-rest-tests
    elsevier-research/dkp-imagefinder-logging
    elsevier-research/dkp-imagefinder-service
    elsevier-research/dkp-imagefinder-tests
    elsevier-research/dkp-imagefinder-ui
    elsevier-research/dkp-ldr-dependencies
    elsevier-research/dkp-linked-data-browser
    elsevier-research/dkp-linked-data-browser-tests
    elsevier-research/dkp-qa-elasticjmeter
    elsevier-research/dkp-qa-ldr-functional
    elsevier-research/dkp-qa-ldr-performance
    elsevier-research/dkp-qa-ldr-regression
    elsevier-research/dkp-qa-sct-selenium
    elsevier-research/dkp-qa-ui-functional
    elsevier-research/dkp-rest-tests
    elsevier-research/dkp-sct-application
    elsevier-research/dkp-sct-e2e-tests
    elsevier-research/dkp-sct-tests
    elsevier-research/dkp-taxonomy-conversion-lambda
    elsevier-research/dkp-taxonomy-exporter
    elsevier-research/sct-services
    elsevier-research/taxonomies-ctm-prototype
)

DKP_INFRA_REPOS=(
    elsevier-research/ces-terraformcontrol-cef
    elsevier-research/dkp-ami-security-updates
    elsevier-research/dkp-ansible-rest
    elsevier-research/dkp-base-image
    elsevier-research/dkp-cicd-scripts
    elsevier-research/dkp-core-github-actions
    elsevier-research/dkp-core-infra
    elsevier-research/dkp-dist-docker
    elsevier-research/dkp-fluentd-image
    elsevier-research/dkp-graphdb-image
    elsevier-research/dkp-if-terraform
    elsevier-research/dkp-imagefinder-deployment
    elsevier-research/dkp-integrationserver
    elsevier-research/dkp-irvs-event-framework
    elsevier-research/dkp-jenkins-config
    elsevier-research/dkp-jenkins-libraries
    elsevier-research/dkp-jenkins-master-configuration
    elsevier-research/dkp-jenkinscontrol
    elsevier-research/dkp-ldr-batchprocess-deployment
    elsevier-research/dkp-ldr-devops
    elsevier-research/dkp-ldr-rest-deployment
    elsevier-research/dkp-ldr-site
    elsevier-research/dkp-prod-terraform
    elsevier-research/dkp-puppet-httpd24
    elsevier-research/dkp-puppet-maven
    elsevier-research/dkp-puppet-tomcat
    elsevier-research/dkp-puppetcontrol
    elsevier-research/dkp-sct-deployment
    elsevier-research/dkp-sct-terraform
    elsevier-research/dkp-solr-deployment
    elsevier-research/dkp-terraform
    elsevier-research/dkp-terraform-dkp-infra
    elsevier-research/dkp-terraform-ecs
    elsevier-research/dkp-terraform-elasticsearch
    elsevier-research/dkp-terraform-gravitee-ecs
    elsevier-research/dkp-terraform-if-infra
    elsevier-research/dkp-terraform-kong
    elsevier-research/dkp-terraform-new-relic
    elsevier-research/dkp-terraform-puppetserver
    elsevier-research/dkp-terraform-sct-infra
    elsevier-research/dkp-terraform-tags
    elsevier-research/dkp-terraform-zookeeper
    elsevier-research/dkp-terraformcontrol
    elsevier-research/dkp-vagrant-toolbox
    elsevier-research/linked-data-gateway
    elsevier-research/rdm-md-be-dkp-categories
)

# Concept                           {{{2
# ======================================

CONCEPT_REPOS=(
    elsevier-research/ces-annotations-spi
    elsevier-research/ces-brat-utility
    elsevier-research/ces-car-data-extractor
    elsevier-research/ces-car-enrichment-app
    elsevier-research/ces-cef-annotations
    elsevier-research/ces-cef-apps
    elsevier-research/ces-cef-aws-gateway
    elsevier-research/ces-cef-classifications
    elsevier-research/ces-cef-config
    elsevier-research/ces-cef-core
    elsevier-research/ces-cef-demo-app
    elsevier-research/ces-cef-enrichment-api
    elsevier-research/ces-cef-fci-ksf-aws-api-gateway-sdk
    elsevier-research/ces-cef-funding-bodies
    elsevier-research/ces-cef-lab
    elsevier-research/ces-cef-mlwb
    elsevier-research/ces-cef-text-enrichment
    elsevier-research/ces-cef-tools
    elsevier-research/ces-cicd-pipeline-library
    elsevier-research/ces-crf-annotations
    elsevier-research/ces-definitions-ml
    elsevier-research/ces-disambiguator
    elsevier-research/ces-dvs-data-repository
    elsevier-research/ces-emr-spark-scm
    elsevier-research/ces-enrichment-feedback
    elsevier-research/ces-enrichment-integration-service
    elsevier-research/ces-enrichment-utilities
    elsevier-research/ces-entity-extraction-app
    elsevier-research/ces-exception-api
    elsevier-research/ces-fci-java-fpe-smart-content
    elsevier-research/ces-fci-notifier
    elsevier-research/ces-fci-smart-content
    elsevier-research/ces-fpe-scm-integration
    elsevier-research/ces-jenkins-config
    elsevier-research/ces-jenkins-libraries
    elsevier-research/ces-jenkins-scripts
    elsevier-research/ces-jenkinscontrol
    elsevier-research/ces-jenkinscontrol-network-storage
    elsevier-research/ces-jfasttext-0-2-0
    elsevier-research/ces-json-util
    elsevier-research/ces-leadmine-annotations
    elsevier-research/ces-nlp-java-commons
    elsevier-research/ces-nlp-jbioc
    elsevier-research/ces-nlp-numerical-properties
    elsevier-research/ces-nlp-services
    elsevier-research/ces-nlp-services-cpx-ml-server
    elsevier-research/ces-nlp-services-experiments
    elsevier-research/ces-nlp-services-languages
    elsevier-research/ces-oogle
    elsevier-research/ces-plugins
    elsevier-research/ces-puppet-ckan
    elsevier-research/ces-puppetcontrol
    elsevier-research/ces-puppetcontrol-network-storage
    elsevier-research/ces-py-brat-tools
    elsevier-research/ces-python-utility-scripts
    elsevier-research/ces-rref-disambiguation-project
    elsevier-research/ces-s3-urihandlers
    elsevier-research/ces-section-classifications-app
    elsevier-research/ces-section-finder
    elsevier-research/ces-section-finder-app
    elsevier-research/ces-terraform-cef-asg
    elsevier-research/ces-terraform-cef-elb
    elsevier-research/ces-terraform-cef-iam-role
    elsevier-research/ces-terraform-cef-sqs
    elsevier-research/ces-terraform-newrelic-cef
    elsevier-research/ces-terraformcontrol-network-storage
    elsevier-research/ces-text-enrichment-services
    elsevier-research/ces-urihandlers
    elsevier-research/ces-wordnet-definitions
    elsevier-research/ces-xocs-parser
    elsevier-research/dp-concept-data-lake
    elsevier-research/dp-award-concept-cluster-predictor
    elsevier-research/dp-classification-ondemand-sdg-service
    elsevier-research/dp-classification-performance-test-app
    elsevier-research/dp-classification-sdg-quality-test
    elsevier-research/dp-classifications-lookup-service
    elsevier-research/dp-concept-processor
    elsevier-research/dp-document-dataset-pdf-head-sequence-classification
    elsevier-research/dp-enrich-classification-monitor-quality-moe
    elsevier-research/dp-enrich-classification-monitor-quality-sdg
    elsevier-research/dp-enrich-classification-response-s3-sink
    elsevier-research/dp-enrich-classification-sdg-cafe-harvester
    elsevier-research/dp-enrich-classification-sdg-orchestrator
    elsevier-research/dp-enrich-core-service
    elsevier-research/dp-enrich-dummy-content-listener
    elsevier-research/dp-enrich-kafka-headers
    elsevier-research/dp-enrich-moe-classifier
    elsevier-research/dp-enrich-india-ranking-classifier
    elsevier-research/dp-enrich-query-classification
    elsevier-research/dp-enrich-rdx-ml-inference
    elsevier-research/dp-enrich-rdx-patents
    elsevier-research/dp-enrich-sdg-classifier
    elsevier-research/dp-enrich-newrelic-monitoring
    elsevier-research/dp-enrich-sdg-ml-classifier
    elsevier-research/dp-enrich-sdg-sd-feed-harvester
    elsevier-research/dp-enrich-solr-classifier
    elsevier-research/dp-enrich-xocs-cafe-feed-harvester
    elsevier-research/ds-ces-funding-bodies-temp
    elsevier-research/ds-ces-funding-bodies-utility
    elsevier-research/ds-funding-bodies-candidates
    elsevier-research/rdm-datasearch-newrelic-monitoring
)

CONCEPT_INFRA_REPOS=(
    # elsevier-research/cef-puppet-ckan
    # elsevier-research/cef-puppet-mlapp
    # elsevier-research/cef-puppet-solr
    # elsevier-research/dp-concept-domain-adrs
    # elsevier-research/dp-concept-terraform-config
)

# Consumption                       {{{2
# ======================================

CONSUMPTION_REPOS=(
    elsevier-research/dp-consumption-avro-schemas
    elsevier-research/dp-consumption-component-test-library
    elsevier-research/dp-consumption-data-confidential
    elsevier-research/dp-consumption-domain-adrs
    elsevier-research/dp-consumption-infra
    elsevier-research/dp-consumption-lib-aws
    elsevier-research/dp-consumption-lib-data-model
    elsevier-research/dp-consumption-lib-dataset-builder
    elsevier-research/dp-consumption-lib-metadata-store
    elsevier-research/dp-consumption-lib-occ-to-entity-store
    elsevier-research/dp-consumption-databricks-report-generator
    elsevier-research/dp-consumption-lib-occ-to-occ-store
    elsevier-research/dp-consumption-lib-relationship-store
    elsevier-research/dp-consumption-spark-occ-linked-parquet-store
    elsevier-research/dp-consumption-spark-opinion-resolver
    elsevier-research/dp-consumption-parent-pom
    elsevier-research/dp-consumption-pipeline-dataset-parquet
    elsevier-research/dp-consumption-regression-test-suite
    elsevier-research/dp-consumption-lib-spark
    elsevier-research/dp-consumption-service-dataset-builder
    elsevier-research/dp-consumption-service-exhibit-found-store
    elsevier-research/dp-consumption-service-occ-to-entity-store
    elsevier-research/dp-consumption-service-occ-to-occ-store
    elsevier-research/dp-consumption-service-patent-dataset-builder
    elsevier-research/dp-consumption-service-patent-metadata-store
    elsevier-research/dp-consumption-service-patent-occ-to-entity-store
    elsevier-research/dp-consumption-service-patent-occ-to-occ-store
    elsevier-research/dp-consumption-service-status-updater
    elsevier-research/dp-consumption-service-test-data-producer
    elsevier-research/dp-consumption-spark-cdb-relationships-producer
    elsevier-research/dp-consumption-spark-template
    elsevier-research/dp-consumption-test-automation
    elsevier-research/dp-consumption-test-end-to-end
    elsevier-research/dp-consumption-test-relationship-store
    elsevier-research/dp-person-bingo-consumption-service
    elsevier-research/dp-person-events-consumption-utils
)

CONSUMPTION_INFRA_REPOS=(
)

# Foundations                       {{{2
# ======================================

FOUNDATIONS_REPOS=(
    elsevier-research/dp-foundation-alerts-lambda
    elsevier-research/dp-foundation-bosapi-redis-monitoring
    elsevier-research/dp-foundation-capabilities-onboarding
    elsevier-research/rdp-foundations-data-cost-model
    elsevier-research/rdp-foundations-al2-scanner
    elsevier-research/rdp-foundations-gradle-playground-service
    elsevier-research/dp-foundation-data-account-terraform
    elsevier-research/dp-foundation-data-ledger
    elsevier-research/dp-foundation-data-ledger-specs
    elsevier-research/dp-foundation-databricks-mounter
    elsevier-research/dp-foundation-dr
    elsevier-research/dp-foundation-druid-poc
    elsevier-research/dp-foundation-monitoring
    elsevier-research/dp-foundation-prometheus
    elsevier-research/dp-foundation-schema-registry-proxy
    elsevier-research/dp-foundation-storage-management-service
    elsevier-research/dp-foundation-topic-harvester
    elsevier-research/dp-foundation-utils
    elsevier-research/dp-foundations-kubedump
    elsevier-research/dp-foundations-spinnaker
    elsevier-research/rdp-cck-selfservice-alpha
    elsevier-research/rdp-cck-selfservice-nonprod
    elsevier-research/rdp-cck-selfservice-prod
    elsevier-research/rdp-foundations-acler
    elsevier-research/rdp-foundations-cck-utilities
    elsevier-research/rdp-foundations-confluent-clients
    elsevier-research/rdp-foundations-demo-service
    elsevier-research/rdp-foundations-golden-signal-kafka-consumer
    elsevier-research/rdp-foundations-golden-signal-kafka-producer
    elsevier-research/rdp-foundations-gradle-demo-service
    elsevier-research/rdp-foundations-julie
    elsevier-research/rdp-foundations-kafka-stream-application
    elsevier-research/rdp-foundations-meta-service-hello-world
    elsevier-research/rdp-foundations-perf-test
    elsevier-research/rdp-foundations-playground-service
    elsevier-research/rdp-foundations-python-demo-service
    elsevier-research/rdp-foundations-python-playground-service
    elsevier-research/rdp-foundations-s3-bucket-review-service
    elsevier-research/rdp-foundations-scala-demo-service
    elsevier-research/rdp-foundations-service-hello-world
    elsevier-research/rdp-works-mlops-distributed-training
    elsevier-research/rdp-works-mlops-example-bert-model-kserve-predictor
    elsevier-research/rdp-works-mlops-example-bert-model-kserve-transformer
    elsevier-research/rdp-works-mlops-example-bert-model-tensorrt-transformer
    elsevier-research/rdp-works-mlops-example-dataset
    elsevier-research/rdp-works-mlops-example-models
    elsevier-research/rdp-works-mlops-example-models-v2
    elsevier-research/rdp-works-mlops-infra
    elsevier-research/rdp-works-mlops-model-quantization-inferentia
    elsevier-research/rdp-works-mlops-model-quantization-tensorrt
    elsevier-research/rdp-works-mlops-peft
    elsevier-research/rdp-works-mlops-service-registry
    elsevier-research/rdp-works-mlops-service-workflow-orchestrator
    elsevier-research/rdp-works-mlops-toolkit
    elsevier-research/rdp-works-mlops-webapp
)

FOUNDATIONS_INFRA_REPOS=(
)

# Core                              {{{2
# ======================================

CORE_REPOS=(
    elsevier-research/dp-core-common
    elsevier-research/dp-core-data-accounts-infra
    elsevier-research/dp-core-eks
    elsevier-research/dp-core-eks-library
    elsevier-research/dp-core-gha-configurations
    elsevier-research/dp-core-github-actions
    elsevier-research/dp-core-helmcharts
    elsevier-research/dp-core-infra
    elsevier-research/dp-core-istio-ingress
    elsevier-research/dp-core-jenkins
    elsevier-research/dp-core-jenkins-scripts
    elsevier-research/dp-core-jfrog-tokens
    elsevier-research/dp-core-kibana-proxy
    elsevier-research/dp-core-spinnaker
    elsevier-research/dp-mvn-archetype-kafka-service
)

CORE_INFRA_REPOS=(
)

# Entellect                         {{{2
# ======================================

ENTELLECT_REPOS=(
    elsevier-research/techcontent-application-monitoring
    elsevier-research/techcontent-awscommon
    elsevier-research/techcontent-awsservices-clients
    elsevier-research/techcontent-cloud-common
    elsevier-research/techcontent-content-elsapi
    elsevier-research/techcontent-content-relational-db-scripts
    elsevier-research/techcontent-content-ssm-scripts
    elsevier-research/techcontent-crowdstrike
    elsevier-research/techcontent-ctorest
    elsevier-research/techcontent-docker
    elsevier-research/techcontent-editcommon
    elsevier-research/techcontent-elsapplite
    elsevier-research/techcontent-elscommon
    elsevier-research/techcontent-elsrslite
    elsevier-research/techcontent-harvester
    elsevier-research/techcontent-harvester-patent-reader
    elsevier-research/techcontent-harvester-patent-writer
    elsevier-research/techcontent-harvester-tasks
    elsevier-research/techcontent-hub-common
    elsevier-research/techcontent-infra
    elsevier-research/techcontent-jenkins-deployment-iam-role
    elsevier-research/techcontent-jenkins-pipelines
    elsevier-research/techcontent-kafka-header
    elsevier-research/techcontent-lambdas
    elsevier-research/techcontent-marklogic-scripts-sciencedirectcontent
    elsevier-research/techcontent-marklogic-scripts-scopuscontent
    elsevier-research/techcontent-oauthtoken-service
    elsevier-research/techcontent-patent-datatransformer
    elsevier-research/techcontent-sc-authorproxy
    elsevier-research/techcontent-sc-citescoretransparency
    elsevier-research/techcontent-sc-hq-accuracy-estimator
    elsevier-research/techcontent-sc-ohub
    elsevier-research/techcontent-sc-profileretrieval
    elsevier-research/techcontent-sc-source-service
    elsevier-research/techcontent-sc-tools
    elsevier-research/techcontent-sc-xabstractsmetadata
    elsevier-research/techcontent-sc-xabstractsretrieval
    elsevier-research/techcontent-scheduler
    elsevier-research/techcontent-scopus-parsing-pipeline
    elsevier-research/techcontent-sd-attachmentretrieval
    elsevier-research/techcontent-sd-contentmetadata
    elsevier-research/techcontent-sd-elsrslite
    elsevier-research/techcontent-sd-ihub
    elsevier-research/techcontent-sd-ihub-rest
    elsevier-research/techcontent-sd-olpkservice
    elsevier-research/techcontent-sd-textretrieval
    elsevier-research/techcontent-service-univentio
    elsevier-research/techcontent-source-api
    elsevier-research/techcontent-spark
    elsevier-research/techcontent-spring-boot-service-template
    elsevier-research/techcontent-sysman-api
    elsevier-research/techcontent-test-api-functional-test
    elsevier-research/techcontent-test-api-performance-test
    elsevier-research/techcontent-test-functional-testscripts
    elsevier-research/techcontent-test-ws-xfab-testscripts
    elsevier-research/techcontent-tools
    elsevier-research/techcontent-usage-reporting
    elsevier-research/techcontent-xfab
    elsevier-research/techcontent-xocs-mica-convertors
)

ENTELLECT_INFRA_REPOS=(
    elsevier-research/techcontent-puppet-module-jfrog
    elsevier-research/techcontent-puppet-module-s3
    elsevier-research/techcontent-puppet-tanium
    elsevier-research/techcontent-puppetcontrol-sciencedirectcontent
    elsevier-research/techcontent-puppetcontrol-scopuscontent
    elsevier-research/techcontent-puppetmodule-scopuscontent-ws-config-files
    elsevier-research/techcontent-puppetmodule-scopuscontent-xfab-config-files
    elsevier-research/techcontent-terraform-s3bucket
    elsevier-research/techcontent-terraformcontrol-sciencedirectcontent
    elsevier-research/techcontent-terraformcontrol-scopuscontent
    elsevier-research/techcontent-terraformmodule-alb
    elsevier-research/techcontent-terraformmodule-alb-listener
    elsevier-research/techcontent-terraformmodule-alb-sg
    elsevier-research/techcontent-terraformmodule-app-stack
    elsevier-research/techcontent-terraformmodule-bastion
    elsevier-research/techcontent-terraformmodule-bootstrap
    elsevier-research/techcontent-terraformmodule-cloudflare
    elsevier-research/techcontent-terraformmodule-cloudfront
    elsevier-research/techcontent-terraformmodule-data-pipeline
    elsevier-research/techcontent-terraformmodule-direct-connect-routes
    elsevier-research/techcontent-terraformmodule-ecr
    elsevier-research/techcontent-terraformmodule-ecs
    elsevier-research/techcontent-terraformmodule-ecs-service
    elsevier-research/techcontent-terraformmodule-efs
    elsevier-research/techcontent-terraformmodule-emr-cluster-sg
    elsevier-research/techcontent-terraformmodule-jenkins
    elsevier-research/techcontent-terraformmodule-kms-key
    elsevier-research/techcontent-terraformmodule-lambda
    elsevier-research/techcontent-terraformmodule-marklogic-cluster
    elsevier-research/techcontent-terraformmodule-marklogic-kms-key
    elsevier-research/techcontent-terraformmodule-puppetserver
    elsevier-research/techcontent-terraformmodule-rds
    elsevier-research/techcontent-terraformmodule-route53
    elsevier-research/techcontent-terraformmodule-s3-object
    elsevier-research/techcontent-terraformmodule-scopushq-ecs-stack
    elsevier-research/techcontent-terraformmodule-sns-topics
    elsevier-research/techcontent-terraformmodule-spot-termination-to-slack
    elsevier-research/techcontent-terraformmodule-vpc
    elsevier-research/techcontent-terraformmodule-waf-global-elsevier
    elsevier-research/techcontent-terraformmodule-xfab-app-sg
)

# SciBite                           {{{2
# ======================================

SCIBITE_REPOS=(
    #elsevier-health/scibite-adrs
    #elsevier-health/scibite-dataops
    #elsevier-health/scibite-kong-config
    #elsevier-health/scibite-ontology-rh-test
    #elsevier-health/scibite-tst
    elsevier-health/scibite-aardwolf
    elsevier-health/scibite-centree-ontology-loading-scripts
    elsevier-health/scibite-centree-ui
    elsevier-health/scibite-centree2hgraph
    elsevier-health/scibite-challenge
    elsevier-health/scibite-companion
    elsevier-health/scibite-data-store
    elsevier-health/scibite-dataops
    elsevier-health/scibite-dataops-filetrack
    elsevier-health/scibite-dataops-hgnc
    elsevier-health/scibite-dataops-termite-release
    elsevier-health/scibite-datatools
    elsevier-health/scibite-doc-app
    elsevier-health/scibite-dockerhub-cli
    elsevier-health/scibite-dsps-customer
    elsevier-health/scibite-dsps-rnd
    elsevier-health/scibite-dsps-search-ir-evaluation
    elsevier-health/scibite-dsps-search-ir-evaluation-dashboard
    elsevier-health/scibite-framework
    elsevier-health/scibite-keycloak-client
    elsevier-health/scibite-keycloak-user-importer
    elsevier-health/scibite-licenses-python
    elsevier-health/scibite-local-entellect-model
    elsevier-health/scibite-notifications
    elsevier-health/scibite-ontology
    elsevier-health/scibite-ontology-ai-golden-datsets
    elsevier-health/scibite-ontology-rachaelh
    elsevier-health/scibite-ontology-rebeccaf
    elsevier-health/scibite-ontology-service
    elsevier-health/scibite-ontology-xrefs
    elsevier-health/scibite-qdrant-framework-store
    elsevier-health/scibite-r-toolkit
    elsevier-health/scibite-react-ui-shared
    elsevier-health/scibite-saas-swagger-fixer
    elsevier-health/scibite-security
    elsevier-health/scibite-security-ui
    elsevier-health/scibite-skosxl
    elsevier-health/scibite-smart-forms
    elsevier-health/scibite-sparql-tutorial
    elsevier-health/scibite-techconsultants
    elsevier-health/scibite-termite
    elsevier-health/scibite-termite-cli
    elsevier-health/scibite-termite-core
    elsevier-health/scibite-termite-ui
    elsevier-health/scibite-toolkit
    elsevier-health/scibite-toolshed
    elsevier-health/scibite-translation
    elsevier-health/scibite-ts-repo
    elsevier-health/scibite-ui-mui4
    elsevier-health/scibite-ui-mui5
    elsevier-health/scibite-wb-mappings
    elsevier-health/scibiteai-augment
    elsevier-health/scibiteai-corroborate
    elsevier-health/scibiteai-devops
    elsevier-health/scibiteai-huggingface-models
    elsevier-health/scibiteai-patterns
    elsevier-health/scibiteai-sagemaker-gooey
    elsevier-health/scibiteai-slackqa
    elsevier-health/scibiteai-vocabmaker
    elsevier-health/scibiteai-vocabreader
    elsevier-health/scibitesearch-default-pipelines
    elsevier-health/scibitesearch-saas-instances
)

SCIBITE_INFRA_REPOS=(
    elsevier-health/scibite-cm-terraformcontrol
    elsevier-health/scibite-docstore-alb
    elsevier-health/scibite-docstore-tf
    elsevier-health/scibite-dsps-infra
    elsevier-health/scibite-elasticsearch
    elsevier-health/scibite-framework-tf
    elsevier-health/scibite-generic-tf
    elsevier-health/scibite-github-runner
    elsevier-health/scibite-hcm-terraformcontrol
    elsevier-health/scibite-helm-charts
    elsevier-health/scibite-infrastructure
    elsevier-health/scibite-integration-poc
    elsevier-health/scibite-kubernetes-infrastructure
    elsevier-health/scibite-kubernetes-instances
    elsevier-health/scibite-license-tf
    elsevier-health/scibite-migration
    elsevier-health/scibite-nginx
    elsevier-health/scibite-nonprod-instances
    elsevier-health/scibite-nonprod-jenkins-config
    elsevier-health/scibite-nonprod-terraform-modules
    elsevier-health/scibite-ontology-infra
    elsevier-health/scibite-sagemaker-tf
    elsevier-health/scibite-termite-tf-module
    elsevier-health/scibite-termite6-terraform
    elsevier-health/scibite-terraform-modules
    elsevier-health/scibiteai-infra
    elsevier-health/scibiteai-vocabmaker-tf-module
    elsevier-health/scibitesearch-saas-instances
    elsevier-health/scibitesearch-saas-terraform-modules
    elsevier-health/scibitesearch-saas-tf
)

# Sandbox                           {{{2
# ======================================

SANDBOX_REPOS=(
    elsevier-research/dp-simulator
)

# KD repos                                                                  {{{1
# ==============================================================================

# Recommenders                      {{{2
# ======================================

RECOMMENDERS_REPOS=(
    elsevier-research/kd-graphql-documentation
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
    elsevier-research/kd-recs-dataset-pruner
    elsevier-research/kd-recs-domain-lib
    elsevier-research/kd-recs-event-log-processor
    elsevier-research/kd-recs-event-logger-lambda
    elsevier-research/kd-recs-events-common
    elsevier-research/kd-recs-feature-store
    elsevier-research/kd-recs-funding-opportunities-processor
    elsevier-research/kd-recs-genai-explanations-invitations
    elsevier-research/kd-recs-integration-testing-utils
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
    elsevier-research/kd-recs-scripts
    elsevier-research/kd-recs-sd-article-metadata-extractor
    elsevier-research/kd-recs-sd-article-recommender-api
    elsevier-research/kd-recs-sd-citation-snippets-generator
    elsevier-research/kd-recs-sd-generator
    elsevier-research/kd-recs-sd-learning-to-rank
    elsevier-research/kd-recs-spark-emr-stack
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
    elsevier-research/kd-work-recommendations-graphql
    elsevier-research/kd-work-recommendations-graphql-infra
    elsevier-research/kd-work-recommendations-graphql-test
    elsevier-research/kd-work-recommendations-graphql-test
)

RECOMMENDERS_INFRA_REPOS=(
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

# RECOMMENDERS_DS_REPOS=(
#     elsevier-research/datascience-recs-reviewers-bias-causality
#     elsevier-research/kd-recs-api-performance-tests
#     elsevier-research/kd-recs-causal-inference
#     elsevier-research/kd-recs-cicd-test-repo
#     elsevier-research/kd-recs-manuscript-fit-ds
#     elsevier-research/kd-recs-reviewer-pytorch
#     elsevier-research/kd-recs-reviewers-ds-daniel-kershaw
#     elsevier-research/kd-recs-reviewers-ds-evaluation-libary
#     elsevier-research/kd-recs-reviewers-ds-experiments
#     elsevier-research/kd-recs-reviewers-ds-pipelines
#     elsevier-research/kd-recs-sd-homie
#     elsevier-research/kd-recs-specter
# )

# RECOMMENDERS_ARCHIVED_REPOS=(
#     elsevier-research/kd-recs-aws-test
#     elsevier-research/kd-recs-data-pipeline-newrelic-lambda
#     elsevier-research/kd-recs-data-pipeline-trigger-lambda
#     elsevier-research/kd-recs-elasticsearch-common
#     elsevier-research/kd-recs-elasticsearch-loader
#     elsevier-research/kd-recs-enhanced-reading
#     elsevier-research/kd-recs-events-service
#     elsevier-research/kd-recs-evise-reviewers-tests
#     elsevier-research/kd-recs-funding-institutional-recommendations-api
#     elsevier-research/kd-recs-mendeley-funding-recommendations-api
#     elsevier-research/kd-recs-mendeley-profile-data-converter
#     elsevier-research/kd-recs-mendeley-user-representation-common
#     elsevier-research/kd-recs-mendeley-user-representation-generator
#     elsevier-research/kd-recs-mendeley-user-representation-infra
#     elsevier-research/kd-recs-rev-sagemaker
#     elsevier-research/kd-recs-ros-recommender-dataformats
#     elsevier-research/kd-recs-sutd-offline-evaluation
#     elsevier-research/kd-recs-sutd-recs-generator
# )

# Butter Chicken                    {{{2
# ======================================

BUTTER_CHICKEN_REPOS=(
    elsevier-research/kd-apollo-router
    elsevier-research/kd-apollo-router-perf-test
    elsevier-research/kd-apollo-router-test
    elsevier-research/kd-app-framework
    elsevier-research/kd-app-infra-template
    elsevier-research/kd-app-template
    elsevier-research/kd-app-test-template
    elsevier-research/kd-artefacts
    elsevier-research/kd-automation-autocomplete
    elsevier-research/kd-automation-document-embeddings
    elsevier-research/kd-automation-embeddings
    elsevier-research/kd-automation-enricher
    elsevier-research/kd-automation-genai
    elsevier-research/kd-automation-shared-genai
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
    elsevier-research/kd-hallucination-detection
    elsevier-research/kd-helm-charts
    elsevier-research/kd-hydration-dynamodb-client
    elsevier-research/kd-hydration-graphql-app
    elsevier-research/kd-hydration-ingestion
    elsevier-research/kd-ingestion-components-configuration
    elsevier-research/kd-ingestion-performance-poc
    elsevier-research/kd-ingestion-scripts
    elsevier-research/kd-ingestion-sync
    elsevier-research/kd-java-app-framework
    elsevier-research/kd-java-app-template
    elsevier-research/kd-jenkins-pipelines
    elsevier-research/kd-kafka-common
    elsevier-research/kd-labs-genai-query-logs-analysis
    elsevier-research/kd-labs-sret-backend-nestjs
    elsevier-research/kd-labs-sret-frontend
    elsevier-research/kd-labs-webapp-search-relevance
    elsevier-research/kd-mic-lambda
    elsevier-research/kd-multibranch-test
    elsevier-research/kd-orgdb-parser
    elsevier-research/kd-performance-embeddings
    elsevier-research/kd-performance-genai
    elsevier-research/kd-performance-mendeley
    elsevier-research/kd-performance-sss
    elsevier-research/kd-person-finder-service
    elsevier-research/kd-person-relations-store
    elsevier-research/kd-person-traversal-graphql
    elsevier-research/kd-personfinder-performance
    elsevier-research/kd-pf-tools
    elsevier-research/kd-python-app-framework
    elsevier-research/kd-python-app-test
    elsevier-research/kd-query-intent
    elsevier-research/kd-query-simulation
    elsevier-research/kd-queryintent-analysis
    elsevier-research/kd-queryintent-performancetesting
    elsevier-research/kd-scopus-search
    elsevier-research/kd-scripts-etc
    elsevier-research/kd-sda-batch-full-ingestion-poc
    elsevier-research/kd-sebright-app
    elsevier-research/kd-shared-genai-service
    elsevier-research/kd-shared-search-api
    elsevier-research/kd-shared-search-client
    elsevier-research/kd-shared-search-graphql
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
    elsevier-research/kd-work-hydration-graphql
    elsevier-research/kd-xocs-feed-translator-test
    elsevier-research/poc-kd-genai-multiagent
)

BUTTER_CHICKEN_INFRA_REPOS=(
    elsevier-research/kd-author-relations-store-infra
    elsevier-research/kd-aws-newrelic-infra
    elsevier-research/kd-cto-legacy-rest-infra
    elsevier-research/kd-document-relations-store-infra
    elsevier-research/kd-evaluation-service-infra
    elsevier-research/kd-shared-genai-infra
    elsevier-research/kd-genai-service-infra
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

# Spirograph                        {{{2
# ======================================

SPIROGRAPH_REPOS=(
    elsevier-research/kd-concept-traversal-graphql
    elsevier-research/kd-conflict-of-interest
    elsevier-research/kd-graph-airflow
    elsevier-research/kd-graph-automation
    elsevier-research/kd-graph-comparer
    elsevier-research/kd-graph-data-validator
    elsevier-research/kd-graph-metrics-api
    elsevier-research/kd-graph-neo4j-h-index
    elsevier-research/kd-graph-neo4j-poc
    elsevier-research/kd-graph-performance-test
    elsevier-research/kd-graph-quality-notebooks
    elsevier-research/kd-graph-service-api-test
    elsevier-research/kd-graph-service-test-automation
    elsevier-research/kd-graph-spark-scripts
    elsevier-research/kd-graph-updater
    elsevier-research/kd-graph-version-manager
    elsevier-research/kd-graphql-gateway
    elsevier-research/kd-organization-hydration-graphql-test
    elsevier-research/kd-person-hydration-graphql-test
    elsevier-research/kd-person-traversal-graphql-test
    elsevier-research/kd-work-hydration-graphql-test
    elsevier-research/kd-work-traversal-graphql-test
)

# Misc                              {{{2
# ======================================

MISC_REPOS=(
    elsevier-research/kd-architecture-n-design
    elsevier-research/kd-automation-graphql-mendeley-search
    elsevier-research/kd-automation-shared-search
    elsevier-research/kd-ds-pagerank-graph
    elsevier-research/kd-graph-service-infra
    elsevier-research/kd-graphql-gateway-infra
    elsevier-research/kd-performance-shared-search
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

# Newsflo                           {{{2
# ======================================

NEWSFLO_REPOS=(
    elsevier-research/rdp-newsflo-batch-dataset-analyser
    elsevier-research/rdp-newsflo-batch-news-classifier
    elsevier-research/rdp-newsflo-batch-news-clustering
    elsevier-research/rdp-newsflo-batch-news-indexer
    elsevier-research/rdp-newsflo-batch-news-mention-dataset
    elsevier-research/rdp-newsflo-batch-plum-dataset-analyser
    elsevier-research/rdp-newsflo-batch-plum-publish
    elsevier-research/rdp-newsflo-batch-scopus-db-update
    elsevier-research/rdp-newsflo-data-pipeline-airflow
    elsevier-research/rdp-newsflo-dataset-monitoring
    elsevier-research/rdp-newsflo-eks-cluster
    elsevier-research/rdp-newsflo-elasticsearch-logs
    elsevier-research/rdp-newsflo-emr-serverless
    elsevier-research/rdp-newsflo-java-lambda-maven-archetype
    elsevier-research/rdp-newsflo-java-service-maven-archetype
    elsevier-research/rdp-newsflo-jenkins
    elsevier-research/rdp-newsflo-lambda-batch-job-runner
    elsevier-research/rdp-newsflo-lambda-helper
    elsevier-research/rdp-newsflo-lambda-logs-publisher
    elsevier-research/rdp-newsflo-lambda-news-api
    elsevier-research/rdp-newsflo-lambda-news-feed-replay
    elsevier-research/rdp-newsflo-lambda-news-index-housekeeper
    elsevier-research/rdp-newsflo-lambda-news-retriever
    elsevier-research/rdp-newsflo-lambda-newshistory-publisher
    elsevier-research/rdp-newsflo-lambda-plum-publisher
    elsevier-research/rdp-newsflo-mentions-and-feedback-poc
    elsevier-research/rdp-newsflo-newrelic-monitoring
    elsevier-research/rdp-newsflo-news-dataset-publisher
    elsevier-research/rdp-newsflo-news-enricher-poc
    elsevier-research/rdp-newsflo-opensearch-logs
    elsevier-research/rdp-newsflo-opensearch-news-index
    elsevier-research/rdp-newsflo-poc-eks-service-quarkus
    elsevier-research/rdp-newsflo-service-news-api
    elsevier-research/rdp-newsflo-service-news-indexer
    elsevier-research/rdp-newsflo-service-news-ingestion
    elsevier-research/rdp-newsflo-service-poc-eks-api
    elsevier-research/rdp-newsflo-terraform-bootstrap
    elsevier-research/rdp-newsflo-terraform-common
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

# Script                                                                    {{{1
# ==============================================================================

pushd ~/dev

# RDP                               {{{2
# ======================================

#clone-projects-into rdp/architecture        "${ARCHITECTURE_REPOS[@]}"

clone-projects-into rdp/dkp                 "${DKP_REPOS[@]}"
clone-projects-into rdp/dkp/infra           "${DKP_INFRA_REPOS[@]}"

clone-projects-into rdp/concept             "${CONCEPT_REPOS[@]}"
clone-projects-into rdp/concept/infra       "${CONCEPT_INFRA_REPOS[@]}"

clone-projects-into rdp/consumption         "${CONSUMPTION_REPOS[@]}"
clone-projects-into rdp/consumption/infra   "${CONSUMPTION_INFRA_REPOS[@]}"

clone-projects-into rdp/foundations         "${FOUNDATIONS_REPOS[@]}"
clone-projects-into rdp/foundations/infra   "${FOUNDATIONS_INFRA_REPOS[@]}"

clone-projects-into rdp/core                "${CORE_REPOS[@]}"
clone-projects-into rdp/core/infra          "${CORE_INFRA_REPOS[@]}"

clone-projects-into rdp/entellect           "${ENTELLECT_REPOS[@]}"
clone-projects-into rdp/entellect/infra     "${ENTELLECT_INFRA_REPOS[@]}"

clone-projects-into rdp/scibite             "${SCIBITE_REPOS[@]}"
clone-projects-into rdp/scibite/infra       "${SCIBITE_INFRA_REPOS[@]}"

clone-projects-into rdp/sandbox             "${SANDBOX_REPOS[@]}"

clone-projects-into rdp/newsflo             "${NEWSFLO_REPOS[@]}"

# KD                                {{{2
# ======================================

clone-projects-into kd/recs                 "${RECOMMENDERS_REPOS[@]}"
clone-projects-into kd/recs/infra           "${RECOMMENDERS_INFRA_REPOS[@]}"

clone-projects-into kd/butter-chicken       "${BUTTER_CHICKEN_REPOS[@]}"
clone-projects-into kd/butter-chicken/infra "${BUTTER_CHICKEN_INFRA_REPOS[@]}"

clone-projects-into kd/spirograph           "${SPIROGRAPH_REPOS[@]}"
clone-projects-into kd/misc                 "${MISC_REPOS[@]}"

popd
