# jitsi-lgpl-dependencies
This is a submodule of [libjitsi](https://github.com/jitsi/libjitsi) that
encapsulates references to external
 [LGPL](http://opensource.org/licenses/lgpl-license) licensed libraries.

## Raison d'être
**libjitsi** is licensed under the
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
