#!/usr/bin/env bash
set -e
cd "$(realpath "$(dirname "$0")/../")"
VERSION=$1
DIST=$2
SINCE=$(git describe --match "v[0-9\.]*" --abbrev=0)
if debian-distro-info --all | grep -Fqxi "$RELEASE"; then
    DIST_VERSION=$(debian-distro-info --series="${RELEASE}" -r)
elif ubuntu-distro-info --all | grep -Fqxi "$RELEASE"; then
    DIST_VERSION=$(ubuntu-distro-info --series="${RELEASE}" -r)
    # strip LTS suffix if present
    DIST_VERSION="${DIST_VERSION%%\ *}"
fi

FULL_VERSION="${VERSION}-${DIST_VERSION}~${DIST}"

rm -rf debian/javah
cp -r target/native/javah debian/ || (echo "Need pre-compiled javah files, run 'mvn compile' first" && exit 1)
gbp dch \
  --ignore-branch \
  --since "${SINCE}" \
  --meta \
  --release \
  --distribution="${DIST}" \
  --force-distribution \
  --spawn-editor=never \
  --new-version="${FULL_VERSION}"
dpkg-source -I.git -I.target -b .
dpkg-genchanges -S > ../jitsi-lgpl-dependencies_"${FULL_VERSION}"_source.changes
