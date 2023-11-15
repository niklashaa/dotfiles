# Deploy of complex Nuxt (v2) app to Google App Engine

Most tutorials that I found only show how to deploy simple static apps.
The following article describes how to build a gitlab pipeline for more complicated nuxt v2 apps including
- Environment variables
- server target
- Parts of AutoDevops for testing

The complete resulting .gitlab-ci.yaml can be found at the end of this article.

## app.yaml and environment variables

First, to deploy an app to Google App Engine (GAE), we need an app.yaml file.
A basic one can be copied from [Nuxt's official documentation](https://develop365.gitlab.io/nuxtjs-2.8.X-doc/en/faq/appengine-deployment/).

GAE currently does not really support environment variables.
The following section about how to still include them builds upon [this article](https://dev.to/mungell/google-cloud-app-engine-environment-variables-5990).

In general I want to achieve the following goals:
- Use production environment variables only on master branch
- Use development (staging) environment variables for all other branches

This can be achieved by setting placeholder values for our environment variables in our app.yaml.
These are then replaced by actual values in our gitlab pipeline depending on the current branch name.

### 1) Set placeholder variables in app.yaml
This might look as follows:
```
env_variables:
  HOST: '0.0.0.0'
  NODE_ENV: 'production'
  VARIABLE1: _VARIABLE1
  VARIABLE2: _VARIABLE2
```

### 2) Define two gitlab environments
The gitlab environment defines which environment variables should be used.
This is achieved by adding the following lines at the beginning of my .gitlab-ci.yaml:

```
variables:
  ENVIRONMENT: "dev"

workflow:
  rules:
    - if: '$CI_COMMIT_REF_NAME == "master"'
      variables:
        ENVIRONMENT: "prod"
    - if: '$CI_COMMIT_REF_NAME != "master"'
      when: always
```

These lines define the global variable ENVIRONMENT that can be used in all subsequent jobs.
It is "dev" by default and is changed to "prod" if the branch name is "master".

### 3) Add environment variables to gitlab
Define values for VARIABLE1 and VARIABLE2 for each of the defined environments.
Remember to tick the masked checkbox for passwords and other secrets.

### 4) Add gitlab job to replace variable placeholders
This can be done by adding the following job to our pipeline.

```
stages:
  - setup

set_app_variables:
  stage: setup
  environment: $ENVIRONMENT
  script:
    -  sed -i "s/_VARIABLE1/${VARIABLE1}/g" app.yaml
    -  sed -i "s/_VARIABLE2/${VARIABLE2}/g" app.yaml
    -  cat app.yaml
  artifacts:
    paths:
      - app.yaml
    expire_in: 1h
```

The job uses the script section to replace the placeholder values with
sed. The values used depend on the value of the above defined ENVIRONMENT variable.
The line `cat app.yaml` is only for debugging purposes and shows the resulting file in the job logs. Masked variable values will be replaced with [Masked] in the logs.
The app.yaml file is exposed as an artifact so that subsequent jobs can use it.

## Build pipeline
Until now we only made sure that the right environment variables are used in GAE.
The following section describes how to deploy the app to Google Cloud. As recommended [here](https://stackoverflow.com/a/49749873/10895550) we will deploy the production and staging app on two separate Google cloud projects.
In my case these projects already exist so I won't go into the details of how to set them up.

### Add a deploy service account
Has to be done for both Google Cloud projects.
Before building the pipeline add a new service account `gitlab-appengine` with the roles described [here](https://cloud.google.com/appengine/docs/flexible/roles#recommended_role_for_application_deployment). This account will be used when deploying the app to GAE. Generate a json key for this service account and save it as the environment variable 'SERVICE\_ACCOUNT' in Gitlab under the corresponding environment.
Note: I removed all line breaks from the key file before saving it as an environment variable. Not sure if this is needed though.

### Install dependencies
Add the following lines at the bottom of the .gitlab-ci.yaml:
```
install:
  stage: setup
  script:
    - yarn install --frozen-lockfile
  cache:
    key:
      files:
        - yarn.lock
    paths:
      - node_modules
  artifacts:
    paths:
      - node_modules
    expire_in: 1h
```

This job pulls cached node\_modules if they exist already. Then it does a yarn install without changing yarn.lock This way we ensure that the packages we used locally are the same that are installed with gitlab. That way the pipeline stays reproducible. A more detailed explanation can be found in [this article](https://dev.to/drakulavich/gitlab-ci-cache-and-artifacts-explained-by-example-2opi). node\_modules are then saved to the cache again and exposed as artifacts for subsequent jobs to download.

### Build
Add the stage "build" .gitlab-ci.yaml, then add the following lines at the bottom:
```
build:
  stage: build
  environment: $ENVIRONMENT
  dependencies:
    - install
    - set_app_variables
  script:
    - yarn run build
  artifacts:
    paths:
      - .nuxt/
    expire_in: 1h
```

The build step exposes the [build directory](https://v2.nuxt.com/docs/directory-structure/nuxt/) which is [needed to deploy an SSR application](https://v2.nuxt.com/docs/directory-structure/nuxt/#deploying). Build variables can also be included here by again specifying the environment.

### Deploy
Add the stage "deploy" .gitlab-ci.yaml, then add the following job at the bottom:
```
deploy:
  image: google/cloud-sdk:alpine
  stage: deploy
  dependencies:
    - build
    - set_app_variables
  environment: $ENVIRONMENT
  script:
    - gcloud auth activate-service-account --key-file $SERVICE_ACCOUNT
    - gcloud app deploy --quiet --project=$PROJECT_ID --service-account=gitlab-appengine@$PROJECT_ID.iam.gserviceaccount.com
```

The deploy step is based on [this article](https://medium.com/google-cloud/automatically-deploy-to-google-app-engine-with-gitlab-ci-d1c7237cbe11). The improvement is saving SERVICE\_ACCOUNT as a file. That way we can skip creating and deleting a temporary json file each time the job runs.

The SERVICE\_ACCOUNT and PROJECT\_ID variables are again both dependend on the current environment. That ensures deployment to diffrent Google Cloud projects for staging and production.

### Deploy rules

If you want to include build and deploy only for two specific branches you could add the `only` keyword to both jobs specifying the branch names. I wanted to keep things a little more DRY so I added the following rules at the beginning of the .gitlab-ci.yaml

```
# Only include build and deploy steps if branch name is dev or master
.deploy_rules:
  rules:
    - if: '$CI_COMMIT_REF_NAME == "master" || $CI_COMMIT_REF_NAME == "dev"'
```

Then include the rules to each job with the following lines:

```
  rules:
    - !reference [.deploy_rules, rules]
```
