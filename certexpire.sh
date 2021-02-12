#!/bin/bash

function countdown_cert(){
   if [ -z $2 ];then
      #Se o parametro porta vier vazio, considera a porta 443
      EXPDATE=$(echo | openssl s_client -connect $1:443 -servername $1 2> /dev/null | openssl x509 -noout -dates | awk -F"=" '/notAfter/ {print $2}' | awk '{print $1" "$2}')

   else
      #Insere no comando a porta indicada pelo usuario
      EXPDATE=$(echo | openssl s_client -connect $1:$2 -servername $1 2> /dev/null | openssl x509 -noout -dates | awk -F"=" '/notAfter/ {print $2}' | awk '{print $1" "$2}')

   fi
DTEXP=$(date -d "$EXPDATE" +%j)
echo "$DTEXP dias"

}

countdown_cert $1 $2
