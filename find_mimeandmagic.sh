#!/bin/bash

VAR_DIR_TO_SCAN=`grep "VAR_DIR_TO_SCAN=" $1 | cut -d "=" -f2`;
VAR_FILE_MAGIC_SYS=`grep "VAR_FILE_MAGIC_SYS=" $1 | cut -d "=" -f2`;
 
function find_to(){
found=`file "$1" -i --mime-type -m $2`; 
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
	echo "the mime of $file  : $mime is not autorised" >> $PWD/output.txt
fi

}
export -f find_to;

function find_me(){
    echo "" > output.txt ;
    export PATH_MAGIC="$2";
	find $1 -type f -print0 | xargs -0 bash -c env | grep PATH_MAGIC  &>/dev/null && find_to $0 $PATH_MAGIC ; 
}

# Variables
number=1

find_me $VAR_DIR_TO_SCAN $VAR_FILE_MAGIC_SYS &
 PID=$!

# Proof of concept
while kill -0 $PID 2> /dev/null; do 
    printf "\rVeuillez patientez scann en cours!";
	number=`expr ${number}+1`;
	
done
printf "\r"
printf "Scan du répertoire $VAR_DIR_TO_SCAN terminé!, récupérez le résultat du scan dans le fichier $PWD/output.txt\n"
