# s2i-oasp

Source-2-Image stream for 'The Open Application Standard Platform for Java', [oasp4j](https://github.com/oasp/oasp4j).

## Usage

### builder

oc create -f openshift/images/s2i-oasp-imagestream.json
oc create -f openshift/templates/oasp4j-sample-template.json

### cleanup

oc delete bc s2i-oasp
oc delete is s2i-oasp

oc delete template oasp4j-sample-maven

### build parameters

HTTP_PROXY_HOST
HTTP_PROXY_PORT
HTTP_PROXY_USERNAME
HTTP_PROXY_PASSWORD
HTTP_PROXY_NONPROXYHOSTS

MAVEN_GOALS install
MAVEN_PROFILE jsclient
MAVEN_ARGS clean install package -DskipTests -B
MAVEN_OPTS -Xmx700m -Xms700m
MAVEN_MIRROR_URL http://nexus-cicd.192.168.42.81.nip.io/nexus/content/groups/public
MAVEN_ARGS_APPEND

NPM_PROXY_URL

ARTIFACT_DIR samples/server/target
APP_SUFFIX bootified
CLIENT_SOURCE_DIR samples/server/src/main/client



oc delete bc oasp4j-sample
oc delete dc oasp4j-sample
oc delete route oasp4j-sample
oc delete service oasp4j-sample
oc delete is oasp4j-sample

oc delete template oasp4j-sample-maven