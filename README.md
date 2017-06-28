


### References

https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-a-centos-7-server



oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/ose3/s2i-oasp-imagestream.json
oc create -f https://raw.githubusercontent.com/mickuehl/s2i-oasp/master/ose3/s2i-oasp-build_in_ose3.json


oc create -f https://raw.githubusercontent.com/jorgemoralespou/osev3-examples/master/wildfly-swarm/wildfly-swarm-s2i/wildfly-swarm-s2i-all.json


# builder

oc create -f ose3/s2i-oasp-imagestream.json

# cleanup

oc delete bc s2i-oasp
oc delete is s2i-oasp
oc delete template oasp-sample-maven

# stuff

git clone --recursive https://github.com/mickuehl/oasp4j -b develop-2.4.0
git config --global url."https://".insteadOf git://
mvn install --activate-profiles=jsclient

https://blog.openshift.com/improving-build-time-java-builds-openshift/
https://docs.openshift.com/container-platform/3.4/dev_guide/app_tutorials/maven_tutorial.html


sed: can't read /opt/app-root/src/.m2/settings.xml: No such file or directory
