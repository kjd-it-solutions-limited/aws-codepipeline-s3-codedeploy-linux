   cd /Users/git/aws-codepipeline-s3-codedeploy-linux/
   git add *
   #echo ""
   #echo "ken@kjdsolutions.co.uk"
   #echo "Yassmine22"
   #echo ""
   mess=`date`
   git commit -m "updated on $mess to latest files"
   git push 
   git status
   #git status > git_status.txt
   git add *
   git status
   mess=`date`
   git commit -m "updated on $mess"
   #git status
   #mail -s "git status" ken@kjdsolutions.co.uk < git_status.txt

chk1=`sudo ls /Volumes/Qweb | wc -l`
if 
[ $chk1 -ge 1 ]
then
echo "Sending Files to QNAP, Please wait"
sudo rsync -aruv /Users/git/aws-codepipeline-s3-codedeploy-linux/* /Volumes/Qweb
sleep 5
echo "files updated"
echo "open http://192.168.3.56/"
else 
echo "no mountpoint"
fi
