#!/bin/bash
#

#****************************************************************
## Start timer:
START=$(date +%s)

#****************************************************************
## Check for missing parameters:

if [ "$1" != "s"  ] && [ "$1" != "p4"  ] && [ "$1" != "p4t"  ] && [ "$1" != "p4v"  ] && [ "$1" != "p4w"  ] && [ "$1" != "p970"  ] && [ "$1" != "m7ul"  ]
then
  echo "No target device defined"
  exit 0
fi

#****************************************************************
## Set target:

if [ "$1" = "s" ]
then
trgt=galaxysmtd
fi

if [ "$1" = "s2" ]
then
trgt=i9100
fi

if [ "$1" = "p4" ]
then
trgt=p4
fi

if [ "$1" = "p4t" ]
then
trgt=p4tmo
fi

if [ "$1" = "p4v" ]
then
trgt=p4vzw
fi

if [ "$1" = "p4w" ]
then
trgt=p4wifi
fi

if [ "$1" = "p970" ]
then
trgt=p970
fi


if [ "$1" = "m7ul" ]
then
trgt=m7ul
fi

#****************************************************************
## Set basic folder parameters:
echo "Setting folders"
finalout=~/android/pac/out/target/product/$trgt
androidtop=~/android/pac
secsign=~/android/pac/build/target/product/security

#****************************************************************
## Start the build:
echo "An Infamous PAC ROM will be build for $trgt"

#****************************************************************
## Clean environment:
cd $androidtop
make installclean
rm $finalout/system/build.prop
rm $finalout/obj/PACKAGING/target_files_intermediates/pac_$trgt-target_files-eng.kasper.zip
rm $finalout/obj/PACKAGING/target_files_intermediates/pac_$trgt-target_files-eng.kasper/SYSTEM/build.prop

#****************************************************************
## Make the build:
cd $androidtop/
./build-pac.sh $trgt

#****************************************************************
## Copy the build:
echo "Copying fininalized build to AndroidFlash directory"
mv $finalout/pac_*.zip ~/AndroidFlash/$trgt

#****************************************************************
## Report timer:
END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "${txtgrn}Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n ${txtrst}" $E_SEC