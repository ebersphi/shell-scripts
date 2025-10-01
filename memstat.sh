#!/bin/bash
thisREVISION=250924
set -u
set -e
# Memstat.sh is a shell script that calculates linux memory usage for each program / application.
# Script outputs shared and private memory for each program running in linux. Since memory calculation is bit complex,
# this shell script tries best to find more accurate results. Script use 2 files ie /proc//status (to get name of process)
# and /proc//smaps for memory statistic of process. Then script will convert all data into Kb, Mb, Gb using awk.
# This version does NOT need paste or bc.
fail() {
   echo "ERROR! $*" >&2
   exit 1
}

#Source : https://github.com/asmund1/shell-scripts/blob/master/memstat.sh
#Source : http://www.linoxide.com/linux-shell-script/linux-memory-usage-program/
#Parent : http://www.linoxide.com/guide/scripts-pdf.html
while [ $# -ne 0 ]; do
   case $1 in
      -V|--version) echo "$thisREVISION"; exit 0;;
      -h|--help|--usage) 
         cat << _HELP_

Usage: memstat.sh [ -V | --version | -h | --help | <pid> ]
Shows memory usage for the processe id provided, or for all processes otherwise.

_HELP_
         exit 0
         ;;
      [0-9]+) [ -z "$PID" ] || fail "Unexpected argument '$1'. Try --help"
         PID=$1;;
      *) fail "Invalid argument '$1'. Try --help" ;;
   esac
   shift
done

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   fail "This script must be run as root" 
fi
# Remove the temp files however we quit the program
trap 'rm -f /tmp/$$.*' EXIT QUIT TERM
### Functions
#This function will count memory statistic for passed PID
get_process_mem ()
{
PID=$1
#we need to check if 2 files exist
if [ -f /proc/"$PID"/status ] && [ -f /proc/"$PID"/smaps ]; then
    #here we count memory usage, Pss, Private and Shared = Pss-Private
    Pss=$( awk '/^Pss:/ { sum+=$2} END {print sum}' /proc/"$PID"/smaps )
    Private=$(awk '/^Private/ { sum+=$2} END {print sum}' /proc/"$PID"/smaps )
    #we need to be sure that we count Pss and Private memory, to avoid errors
    if [ -n "$Pss" ] || [ -n "$Private"  ]; then
        Shared=$(( Pss - Private ))
        Name=$( grep -e "^Name:" /proc/"$PID"/status|cut -d':' -f2)
        #we keep all results in bytes
        Shared=$(( Shared * 1024 ))
        Private=$(( Private * 1024 ))
        Sum=$(( Shared + Private ))
        printf "%s  + %s = %s \t %s\n" "$Private" "$Shared" "$Sum" "$Name"
    fi
fi
}
#if argument passed script will show statistic only for that pid, of not Ã¯ we list all processes in /proc/ #and get statistic for all of them, all result we store in file /tmp/res
if [ $# -eq 0 ]
then
    pids=$(cd /proc && ls -1d [0-9]* )
    for i in $pids
    do
        get_process_mem "$i" >> /tmp/$$.res
    done
else
    get_process_mem "$1">> /tmp/$$.res
fi
awk 'BEGIN { split("kb mb gb tb pb eb",unit); }
function pretty( size,    p){
   if(size < 1024)
     return sprintf("%4d    b ", size);
   while(size >= 1024) {
     p++;size=size /1024.0;
   }
   return sprintf( "%7.2f %s", size,(""==unit[p]?"??":unit[p]));
}
{  Name=$6; Count[Name]++; VmSizeKB[Name]+=$1; VmRssKB[Name]+=$3; Total[Name]+=$1+$3; }
END {
   for(Name in Total) {
      bySize[Name]= sprintf( "%024d", Total[Name]) " : " Name;
      totalRAM+=Total[Name];
   }
   n=asort(bySize);
   printf "   Private +     Shared =   RAM used  Program\n"
   printf "--------------------------------------------------------\n"
   for(i=1; i <= n; i++) {
      data=bySize[i];
      Name=substr(data, index(data, ":") + 2);
      SizeRAM=substr(data, 1, index(data, ":") - 2 ) + 0;
      nbprocesses=""
      if( Count[Name] > 1) nbprocesses="(" Count[Name] ")";
      printf "%s + %s = %s  %s%s\n", pretty(VmSizeKB[Name]), pretty(VmRssKB[Name]),pretty(SizeRAM),Name,nbprocesses;
   }
   printf "--------------------------------------------------------\n"
   printf "   Private +     Shared = %s\n", pretty(totalRAM);
}
' /tmp/$$.res
echo "========================================================"
date
echo "Memory usage (mb)"
free -m
