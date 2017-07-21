# Open Application Standard Platform Source-To-Image (S2I)

This project provides OpenShift builder images for each of the Open Application Standard Platform (OASP) components.


## Overview

In order to build the OASP components, OpenShift's [Source-to-Image](https://github.com/openshift/source-to-image) (S2I) functionallity is used. 

Currently there are OpenShift builder images for

* OASP4J (Java)
* OASP4JS (JavaScript)

In order to get started, there are additional templates to build and deploy the [OASP 'My Thai Star'](https://github.com/oasp/my-thai-star) reference application. 


## Usage

Before using the OASP builder images, deploy them onto the OpenShift cluster.

### Deploy the Source-2-Image builder images

The builder images are shared across projects on the OpenShift cluster. First, create a dedicated `oasp` project.

    oadm new-project oasp --display-name='OASP' --description='Open Application Standard Platform'

Now add the builder image configuration and start the build.

    $ oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/s2i/java/s2i-oasp-java-imagestream.json --namespace=oasp
    $ oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/s2i/angular/s2i-oasp-angular-imagestream.json --namespace=oasp
    $ oc start-build s2i-oasp-java --namespace=oasp
    $ oc start-build s2i-oasp-angular --namespace=oasp
    
Make sure other projects can access the builder images:

    $ oadm policy add-role-to-group system:image-puller system:authenticated --namespace=oasp

That's all !


## Deploy the 'My Thai Star' Reference Application

To quickly deploy the [My Thai Star](https://github.com/oasp/my-thai-star) reference application, create a new project:

    $ oadm new-project mythaistar --display-name='My Thai Star' --description='My Thai Star reference application for OASP'

Add the application templates:

    $ oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/templates/oasp-mythaistar-java-template.json --namespace=mythaistar
    $ oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/templates/oasp-mythaistar-angular-template.json --namespace=mythaistar

Create the backend application:

    $ oc new-app --template=oasp-mythaistar-java-sample --namespace=mythaistar
    $ oc start-build mythaistar-java --namespace=mythaistar

Create the front-end application

    $ oc new-app --template=oasp-mythaistar-angular-sample --namespace=mythaistar

Connect the front-end application with the backend:

    $ oc set env bc/mythaistar-angular REST_ENDPOINT_URL=http://`oc get routes mythaistar-java --no-headers=true --namespace=mythaistar | sed -e's/  */ /g' | cut -d" " -f 2` --namespace=mythaistar

Build the front-end application:

    $ oc start-build mythaistar-angular --namespace=mythaistar

## Build

Use script `build.sh` to automatically install all templates and build the reference application. 