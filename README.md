# s2i-oasp

This repository contains the source for building various versions of the [reference application for OASP](https://github.com/oasp/my-thai-star) as a reproducible build using [Source-to-Image](https://github.com/openshift/source-to-image)(S2I).

## Usage

### Deploy the builder images

#### Java

To build the server-side developed using the 2.4 version of oasp4j.

The builder image

    oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/s2i/java/s2i-oasp-java-imagestream.json

The application template

    oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/templates/oasp-mythaistar-java-template.json

#### Environment variables

Application developers can use the following environment variables to configure the runtime behavior of the build process:

NAME        | Description
------------|-------------
CONTEXT_DIR | The directory with in the git repo that contains the source code to build
APP_OPTIONS | Application options. These options will be passed to the Spring Boot command line
ARTIFACT_DIR | The location of the deployable artifacts, rel. to APP_OPTIONS

