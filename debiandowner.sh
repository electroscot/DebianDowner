#!/bin/bash
clear
echo '#########################'
echo '# debiandowner          #'
echo '#                       #'
echo '# a1/1.0                #'
echo '# www.electro.scot      #'
echo '#########################'
echo
if [[ $EUID -ne 0 ]]; then
   echo 'This script must be run as root!'
   sudo ./debiandowner.sh $UID
fi
if [[ $EUID -ne 0 ]]; then
   exit 1
fi
echo
echo 'Type name of package to download. Its dependencies'
echo 'will be downloaded automatically'
read -p 'Package to Download: ' packagename
echo
echo $packagename 'will be downloaded, CTRL + C to cancel, Enter to continue'
read

pwds=$(pwd)
pwds2=$pwds"/"$packagename
mkdir -p $pwds2
cd $pwds2
apt download $packagename | for i in $(apt-cache depends $packagename | grep -E 'Depends|Recommends|Suggests' | cut -d ':' -f 2,3 | sed -e s/'<'/''/ -e s/'>'/''/); do apt download $i 2>>errors.txt; done
chown -R $1:$1 $pwds2
echo
echo '#####################################################################'
echo 'The packages and dependencies for' $packagename 'have been'
echo 'downloaded to: ' $pwds2
echo 'Any errors will be in the errors.txt file'
echo '#####################################################################'
