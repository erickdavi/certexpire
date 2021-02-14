#!/bin/bash

function certexpire(){
   if [ -z $HOST ];then
      echo "O campo host nao pode vir vazio"
   else
      if [ -z $PORTA ];then
         #Se o parametro porta vier vazio, considera a porta 443
         PORTA="443"
      else
         #Insere no comando a porta indicada pelo usuario
         PORTA=$PORTA
      fi

      EXPDATE=$(echo | openssl s_client -connect $HOST:$PORTA -servername $HOST 2> /dev/null | openssl x509 -noout -dates | awk -F"=" '/notAfter/ {print $2}' | awk '{print $1" "$2}' 2> /dev/null)
      DTEXP=$(expr $(date -d "$EXPDATE" +%j) - $(date +%j))

      if [ $DTEXP -lt 100 ]; then
         DTEXP="$DTEXP dias(!)"
      else
         DTEXP="$DTEXP dias"
      fi

      echo "$HOST: $DTEXP"

   fi

}


function check_by_file(){
   if [ -z $FILE ];then
      echo "O campo arquivo nao pode ser vazio"
   else

      while read LINE
      do
         HOST=$(echo $LINE | awk -F"," '{print $1}')
         PORTA=$(echo $LINE | awk -F"," '{print $2}')
         #echo $HOST

         certexpire $HOST $PORTA

      done < $FILE

   fi

}

function option(){
   case $1 in
      "-h")
         HOST=$2
         PORTA=$3
         certexpire $HOST $PORTA
      ;;
      "-f")
         FILE=$2
         check_by_file $FILE
      ;;
      *)
         echo "Opcao invalida"
      ;;
   esac

}
option $*
