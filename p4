#!/bin/bash
#

#****************************************************************
## Start timer:
START=$(date +%s)

#****************************************************************
## Set version info:
romname=Mackay_ROM
trgt=p4
cmrv=2.9.3-$trgt-cm
aorv=2.9.3-$trgt-aokp

#****************************************************************
## Check for missing parameters:

if [ "$1" != "a"  ] && [ "$1" != "cm"  ]
  then
  echo "No build specification defined"
  exit 0
fi

#****************************************************************
## Set AOKP folder parameters:
if [ "$1" = "a"  ]
  then
  echo "Setting aokp folders"
  finalout=~/android/aokp/out/target/product/$trgt
  androidtop=~/android/aokp
  secsign=~/android/aokp/build/target/product/security
fi

#****************************************************************
## Set CM folder parameters:
if [ "$1" = "cm"  ]
  then
  echo "Setting CM folders"
  finalout=~/android/cm101/out/target/product/$trgt
  androidtop=~/android/cm101
  secsign=~/android/cm101/build/target/product/security
fi

#****************************************************************
## Clean environment:
if [ "$1" = "a"  ]
  then
  cd $androidtop
  make installclean
  rm $finalout/system/build.prop
  rm $finalout/obj/PACKAGING/target_files_intermediates/aokp_$trgt-target_files-eng.kasper.zip
  rm $finalout/obj/PACKAGING/target_files_intermediates/aokp_$trgt-target_files-eng.kasper/SYSTEM/build.prop
fi

if [ "$1" = "cm"  ]
  then
  cd $androidtop
  make installclean
  rm $finalout/system/build.prop
  rm $finalout/obj/PACKAGING/target_files_intermediates/cm_$trgt-target_files-eng.kasper.zip
  rm $finalout/obj/PACKAGING/target_files_intermediates/cm_$trgt-target_files-eng.kasper/SYSTEM/build.prop
fi

#****************************************************************
## Set ROM version:
if [ "$1" = "a"  ]
  then
  cd $androidtop/vendor/aokp
  sed "/Mackay/c\        ro.aokp.version=`echo $romname`_`echo $aorv`" $androidtop/vendor/aokp/configs/common_versions.mk > $androidtop/vendor/aokp/configs/common_versions.updated
  mv $androidtop/vendor/aokp/configs/common_versions.updated $androidtop/vendor/aokp/configs/common_versions.mk
  git add configs/common_versions.mk
  git commit -m "Bump ROM version to `echo $aorv`"
fi

if [ "$1" = "cm"  ]
  then
  cd $androidtop/vendor/cm
  sed "/Mackay/c\    CM_VERSION := `echo $romname`_`echo $cmrv`" $androidtop/vendor/cm/config/common.mk > $androidtop/vendor/cm/config/common.updated
  mv $androidtop/vendor/cm/config/common.updated $androidtop/vendor/cm/config/common.mk
  git add config/common.mk
  git commit -m "Bump ROM version to `echo $cmrv`"
fi

#****************************************************************
## Make the build:
cd $androidtop/
. build/envsetup.sh && brunch $trgt

#****************************************************************
## Move the ROM to the final location:
mv $finalout/Mackay* ~/AndroidFlash/$trgt

#****************************************************************
## Report timer:
END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "${txtgrn}Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n ${txtrst}" $E_SEC
