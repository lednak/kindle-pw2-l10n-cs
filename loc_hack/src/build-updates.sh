#! /bin/bash

source config

PKGNAME="$HACKNAME"
PKGVER="${VERSION}-${RELEASE}"

# Prepare our files for this specific kindle model...
ARCH=${PKGNAME}_${PKGVER}

tar cvz --xform "s|^install/||" --show-transformed-names -f localization.pack  -C ../.. install
recode -f utf8..flat < cti-me-utf8.txt > cti-me.txt
unix2dos cti-me.txt

# Build install update
cp -f install.sh run.ffs
./kindletool create ota2 --device paperwhite2 run.ffs localization.conf localization.pack Update_${ARCH}_install.bin

# Build uninstall update
cp -f uninstall.sh run.ffs
./kindletool create ota2 --device paperwhite2 run.ffs Update_${ARCH}_uninstall.bin

rm -f run.ffs
rm -f localization.pack

[ -f ../${PKGNAME}_${PKGVER}.zip ] && rm -f ../${PKGNAME}_${PKGVER}.zip
zip ../${PKGNAME}_${PKGVER}.zip *.bin cti-me.txt original_margins
rm -f *.bin
