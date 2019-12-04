##############################################################
#       SCRIPT TO copy ssh keys to devices                   #
#       WRITTEN BY KEN DAVIS AUGUST 2019                     #
#                                                            #
##############################################################

# SETTING VARIABLES
ans1=`date +"%d%m%Y"`
line=0
ans2=1
ans3=1000
dir2=/home/itadmin
mkdir $dir2/LOGs
file=$dir2/host_list.cfg
dir1=$dir2/.ssh
LOG0=$dir2/logs/results
LOG1=$dir2/logs/key_copy_$ans1.log
LOG2=$dir2/logs/failed_$ans1.log
LOG3=$dir2/logs/not_networked_$ans1.log
LOG4=$dir2/logs/not_on_DNS_$ans1.log
LOG5=$dir2/logs/success_$ans1.log
mess1=$dir2/failedmessage.txt
mess2=$dir2/successmessage.txt
mess3=$dir2/whats_left.txt
email1="ken.davis@dyson.com"
gonogo=`ls -l $dir1 | wc -l` # CHECK THE FAILOVER/LIVE CLUSTER STATUS

#GONOGO
if
  [ $gonogo -ge 1 ]
then
  echo " Key Share Started on `date`" >> $LOG1
else
  exit
fi

while
[ $line -le $ans3 ]

do

line=`expr $line + 1 `
laptop=`awk 'NR=='$line' {print $1}' $file` # GET hostname NAME
echo "" >> $LOG1

# CHECK FOR END OF LIST
if
  [ $laptop = "end" ]
then
  echo "Share Complete" >> $LOG1
  ans5=`ls $LOG2 | wc -l`

  if
    [ $ans5 -ge 1 ]
  then
  # SEND ERROR EMAIL
    cat $mess1 $LOG2 | mailx -s " Warning, Some machines were not accessible " $email2 #LIVE
  else
    echo ""  >> $LOG1
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOG1
    echo "" >> $LOG1
    echo " No Errors Detected " >> $LOG1
  fi

  #SENDS THE REPORT EMAIL
  cat $mess2 $LOG1 | mailx -s " Key Share Report for $ans1 " $email1 # LIVE

  # CLEAN UP THE LOGS
  #cd $dir2/LOGs
 find $dir2/logs/key_copy_* -mtime +7 -ls -exec rm -f {} \; # DELETES THE LOGFILES
 find $dir2/logs/failed_* -mtime +7 -ls -exec rm -f {} \; # DELETES THE LOGFILES
 find $dir2/logs/not_networked_* -mtime +7 -ls -exec rm -f {} \; # DELETES THE LOGFILES
 find $dir2/logs/not_on_DNS_* -mtime +7 -ls -exec rm -f {} \; # DELETES THE LOGFILES
 find $dir2/logs/success_* -mtime +7 -ls -exec rm -f {} \; # DELETES THE LOGFILES

exit

############################ END OF SCRIPT ################################################

else
  echo " laptop = $laptop" >> $LOG1

  line=`expr $line + 1 `
  laptop=`awk 'NR=='$line' {print $1}' $file`
  echo " User = $name " >> $LOG1

  echo "testing $laptop"
  echo "testing $laptop" >> $LOG1
  ping -c 1 $laptop &> $LOG0
  cat $LOG0 >> $LOG1
  COUNT1=`more $LOG0 | grep "100% packet loss" | wc -l`
  COUNT2=`more $LOG0 | grep "Name or service not known" | wc -l`
  echo $COUNT1
  echo $COUNT2
      if
        [ $COUNT1 -gt 0 ]
      then
        echo " $laptop not networked " >> $LOG2
        echo $laptop >> $LOG3
      elif
      [ $COUNT2 -gt 0 ]
    then
      echo " $laptop not in DNS " >> $LOG2
      echo $laptop >> $LOG4 then
        #statements
      else
        echo "sharing key to $laptop"
        echo "sharing key to $laptop" >> $LOG1
        ssh-copy-id $laptop
        echo "$laptop fixed " >> $LOG5
      fi


  line=`expr $line + 1 `
  echo "Next laptop"  >> $LOG1
fi

done
