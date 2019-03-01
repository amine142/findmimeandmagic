#!/bin/bash

VAR_DIR_TO_SCAN=`grep "VAR_DIR_TO_SCAN=" $1 | cut -d "=" -f2`

function find_me(){
    echo "" > output.txt ;
	find $1 -type f -exec sh -c '
found=`file "$0" -i --mime-type -m /usr/share/file/magic.mgc`; 
file=`echo $found | cut -d ":" -f1`; 
part=`echo $found | cut -d ":" -f2`; 
mime=`echo $part | cut -d ";" -f1`;

if [ $mime != "application/CDFV2-corrupt" ] && 
   [ $mime != "text/plain" ] && 
   [ $mime != "application/vnd.ms-outlook" ] &&
   [ $mime != "message/rfc822" ] &&
   [ $mime != "application/pdf" ] &&
   [ $mime != "application/x-pdf" ] &&
   [ $mime != "application/msword" ] &&
   [ $mime != "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ] &&
   [ $mime != "application/vnd.oasis.opendocument.text" ] &&
   [ $mime != "image/jpeg" ] &&
   [ $mime != "image/png" ] &&
   [ $mime != "application/vnd.ms-excel" ] &&
   [ $mime != "application/msexcel" ] &&
   [ $mime != "application/x-msexcel" ] &&
   [ $mime != "application/x-ms-excel" ] &&
   [ $mime != "application/x-excel" ] &&
   [ $mime != "application/x-dos_ms_excel" ] &&
   [ $mime != "application/xls" ] &&
   [ $mime != "application/excel" ] &&
   [ $mime != "application/vnd-xls" ] &&
   [ $mime != "application/x-xls" ] &&
   [ $mime != "application/vnd.ms-office" ] &&
   [ $mime != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ]; then
	echo "le fichier $file contient le mime non autorisé : $mime"  >> $PWD/output.txt
fi
' {} \; 
}

# Variables
number=1
# This accounts as the "totalState" variable for the ProgressBar function
_end=$(find $PWD -type f | wc -l);

find_me $VAR_DIR_TO_SCAN $VAR_DIR_MAGIC_SYS &
 PID=$!
if [[ ${_end}/100 -lt 1 ]] ; then
		let _sleep=1;
	else  
		let _sleep=${_end}/100/100;
	fi
# Proof of concept
while kill -0 $PID 2> /dev/null; do 
    printf "\rVeuillez patientez scann en cours!";
	number=`expr ${number}+1`;
		sleep $_sleep
done
printf "\r"
printf "Scan du répertoire $PWD terminé!, récupérez le résultat du scan dans le fichier $PWD/output.txt\n"
