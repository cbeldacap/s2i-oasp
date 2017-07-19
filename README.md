# s2i-oasp

This repository contains the source for building various versions of the [reference application for OASP](https://github.com/oasp/my-thai-star) as a reproducible build using [Source-to-Image](https://github.com/openshift/source-to-image) (S2I).

## Usage

### Deploy the builder images

The builder images will be shared across projects and applications on the OpenShift cluster. To get started, create a dedicated `oasp` project first.

    oadm new-project oasp --display-name='OASP' --description='Open Application Standard Platform'

Now add the builder images to the project and build them:

    oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/s2i/java/s2i-oasp-java-imagestream.json --namespace=oasp
    oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/s2i/angular/s2i-oasp-angular-imagestream.json --namespace=oasp

    oc start-build s2i-oasp-java --namespace=oasp
    oc start-build s2i-oasp-angular --namespace=oasp

Make sure other projects can access the builder images:

    oadm policy add-role-to-group system:image-puller system:authenticated --namespace=oasp

## My Thai Star DEMO

To quickly deploy the [My Thai Star](https://github.com/oasp/my-thai-star) reference application, create a new project:

    oadm new-project mythaistar --display-name='My Thai Star' --description='My Thai Star reference application for OASP'

Add the application templates:

    oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/templates/oasp-mythaistar-java-template.json --namespace=mythaistar
    oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/templates/oasp-mythaistar-angular-template.json --namespace=mythaistar

Create the backend application:

    oc new-app --template=oasp-mythaistar-java-sample --namespace=mythaistar
    oc start-build mythaistar-java --namespace=mythaistar

Create the front-end application

    oc new-app --template=oasp-mythaistar-angular-sample --namespace=mythaistar

Connect the front-end application with the backend:

    oc set env bc/mythaistar-angular REST_ENDPOINT=http://`oc get routes mythaistar-java --no-headers=true | sed -e's/  */ /g' | cut -d" " -f 2`

Build the front-end application:

    oc start-build mythaistar-angular --namespace=mythaistar

