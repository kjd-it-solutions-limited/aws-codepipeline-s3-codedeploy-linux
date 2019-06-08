   cd ~/aws-codepipeline-s3-codedeploy-linux/
   git add *
   echo ""
   echo "ken@kjdsolutions.co.uk"
   echo "Yassmine22"
   echo ""
   git commit -m "test"
   git push 
   git status
   git status > git_status.txt
   git add *
   git status
   mess=`date`
   git commit -m "updated on $mess"
   git status
   mail -s "git status" ken@kjdsolutions.co.uk < git_status.txt
