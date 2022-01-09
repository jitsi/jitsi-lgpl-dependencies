[![Maven Central](https://maven-badges.herokuapp.com/maven-central/org.jitsi/jitsi-lgpl-dependencies/badge.svg)](https://search.maven.org/artifact/jitsi/jitsi-lgpl-dependencies)
[![Hosted By: Cloudsmith](https://img.shields.io/badge/Debian%20package%20hosting%20by-cloudsmith-blue?logo=cloudsmith)](https://cloudsmith.com)
[![Javadocs](https://javadoc.io/badge/org.jitsi/jitsi-lgpl-dependencies.svg)](https://javadoc.io/doc/jitsi/jitsi-lgpl-dependencies)

# jitsi-lgpl-dependencies
This is a submodule of [libjitsi](https://github.com/jitsi/libjitsi) that
encapsulates references to external
 [LGPL](http://opensource.org/licenses/lgpl-license) licensed libraries.

## Raison d'être
[libjitsi](https://github.com/jitsi/libjitsi) is licensed under the
[Apache License](https://github.com/jitsi/libjitsi/blob/master/LICENSE).
Some people, e.g. the
[Apache Foundation](http://www.apache.org/legal/resolved.html) for their
own projects, consider the Apache License and the LGPL to be incompatible.
We do not share their opinion. But for those who do, we provide the possibility
to leave all LGPL related components out of libjitsi.

## Usage in OSGi
**jitsi-lgpl-dependencies** is a [fragment](http://wiki.osgi.org/wiki/Fragment)
that is hosted by **libjitsi**. Simply install the fragment before starting
the libjitsi bundle.

## Debian/Ubuntu Packages
Debian package repository hosting is graciously provided by [Cloudsmith](https://cloudsmith.com).

![Cloudsmith Logo](https://cloudsmith.com/img/cloudsmith-logo-dark.svg)

Browse packages:
- [Java Releases](https://cloudsmith.io/~jitsi/repos/jitsi-desktop/packages/?q=name%3A%27%5Elibjitsi-lgpl-dependencies-java%24%27)
- [JNI Releases](https://cloudsmith.io/~jitsi/repos/jitsi-desktop/packages/?q=name%3A%27%5Elibjitsi-lgpl-dependencies-jni%24%27)
- [Java Snapshots](https://cloudsmith.io/~jitsi/repos/jitsi-desktop-snapshots/packages/?q=name%3A%27%5Elibjitsi-lgpl-dependencies-java%24%27)
- [JNI Snapshots](https://cloudsmith.io/~jitsi/repos/jitsi-desktop-snapshots/packages/?q=name%3A%27%5Elibjitsi-lgpl-dependencies-jni%24%27)

### Ubuntu
Ubuntu users can alternatively use the ppa.

[Releases](https://launchpad.net/~jitsi/+archive/ubuntu/jitsi-desktop)
```
sudo add-apt-repository ppa:jitsi/jitsi-desktop
sudo apt-get update
```

[Snapshots](https://launchpad.net/~jitsi/+archive/ubuntu/jitsi-desktop-snapshots)
```
sudo add-apt-repository ppa:jitsi/jitsi-desktop-snapshots
sudo apt-get update
```
