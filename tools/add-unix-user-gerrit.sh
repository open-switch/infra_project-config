#!/bin/bash
# The script would accept two positional arguments 
#./script.sh krishna.cha.kurnala@hpe.com review-ops/review-nos

#Global Variables
#Gerrit Host names
review-ops=review.openswitch.net
review-nos=

#validate number of arguments

if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters"
    echo "This script need two arguments as inputs, the first being users email address and the second being gerrit hostname"
    echo "Gerrit Hostname can be review-ops/review-nos"
    echo "Usage: script.sh krishna.cha.kurnala@hpe.com kkurnala review-ops"
    echo "Usage: script.sh krishna.cha.kurnala@hpe.com kkurnala review-nos"
    exit 1
    
fi

user_email=$1
unix_username=$2
gerrit_host=$3

#validate user arguments
if [ $my_error_flag == *.hp.com ] ||  [ $my_error_flag_o == *.hpe.com ]; then
      echo " Provided Email address is valid"
else
    echo "Please provide valid email address that ends in hp.com or hpe.com and try again"
fi

#Obtain Account id
account_id=`echo "select account_id from accounts where preferred_email='$user_email';" | ssh -p 29418 $review-ops gerrit gsql | tail -n 3 | head -n 1`
echo "Account id of user is $account_id "

echo "Account info of user $user_email"
echo "select * from account_external_ids where account_id=$account_id;" | ssh -p 29418 $review-ops gerrit gsql

echo "Inserting user's account id"
echo "INSERT INTO account_external_ids (account_id,external_id)VALUES($account_id,'username:$unix_username');" | ssh -p 29418 $review-ops gerrit gsql

echo "Account info of user $user_email after the insert "
echo "select * from account_external_ids where account_id=$account_id;" | ssh -p 29418 $review-ops gerrit gsql

echo "Re-starting gerrit"

ssh -i ~/Downloads/aws review-aws 'sudo service gerrit restart'

