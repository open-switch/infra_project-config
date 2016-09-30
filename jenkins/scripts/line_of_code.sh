Usage: ./line_of_code <branch_name>


# Clone ops-build if it does not exist already
if [ ! -d ops-build ]; then
    echo "Cloning ops-build with desired branch"
    git clone -b $1 ssh://openswitch-jenkins@review.openswitch.net:29418/openswitch/ops-build
    cloc --report-file=ops-build.txt ops-build
    cd ops-build
else
    echo "ops-build already exists."
    cloc ops-build
    cd ops-build
fi

if [ ! -d src ]; then
    mkdir src
fi


#Parse the recipe files and clone all the repos
for recipe in `find yocto/openswitch/meta-distro-openswitch/recipes-ops/. -name *.bb`
do
    repo=`echo $recipe | cut -d'/' -f7 | cut -d'.' -f1`
    mkdir -p src/$repo
    cd src/$repo
    git clone -b $1 ssh://openswitch-jenkins@review.openswitch.net:29418/openswitch/$repo .
      echo "######################################################"
      echo "######################################################"
      echo "######Repo $repo lines of code######"
      cd ..
      cloc --report-file=$repo.txt $repo
      echo "######################################################"
      echo "######################################################"
      cd ..
done

cd $WORKSPACE/ops-build/src
cp ../../ops-build.txt .
cloc --sum-reports --report_file=line_of_code_report *.txt
