# Open Application Standard Platform Source-To-Image (S2I)

This project provides OpenShift builder images for each of the Open Application Standard Platform ([OASP](https://github.com/oasp)) components.


## Overview

To build the OASP components, OpenShift's [Source-to-Image](https://github.com/openshift/source-to-image) (S2I) functionallity is used. 

Currently there are builder images for

* OASP4J (Java)
* OASP4JS (JavaScript)

In order to get started, additional templates to deploy the [OASP 'My Thai Star'](https://github.com/oasp/my-thai-star) reference application are provided.


## Usage

Before using the builder images, add them to the OpenShift cluster.

#### Deploy the Source-2-Image builder images

First, create a dedicated `oasp` project.

    oadm new-project oasp --display-name='OASP' --description='Open Application Standard Platform'

Now add the builder image configuration and start their build.

    $ oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/s2i/java/s2i-oasp-java-imagestream.json --namespace=oasp
    $ oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/s2i/angular/s2i-oasp-angular-imagestream.json --namespace=oasp
    $ oc start-build s2i-oasp-java --namespace=oasp
    $ oc start-build s2i-oasp-angular --namespace=oasp
    
Make sure other projects can access the builder images:

    $ oadm policy add-role-to-group system:image-puller system:authenticated --namespace=oasp

That's all !

#### Build All

Use script `build.sh` to automatically install and build all image streams. The script also creates a project 'My Thai Star' and deploys the reference application.

### References

* The '[My Thai Star](MyThaiStar.md)' reference application templates

