[![Maven Central](https://maven-badges.herokuapp.com/maven-central/org.jitsi/jitsi-lgpl-dependencies/badge.svg)](https://search.maven.org/artifact/jitsi/jitsi-lgpl-dependencies)
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
Browse packages:
- [Stable](https://nexus.ingo.ch/jitsi-desktop/)
- [Unstable](https://nexus.ingo.ch/jitsi-desktop-unstable/)
