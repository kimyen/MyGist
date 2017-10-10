# remove the last build clone
set +e
rm -R ${REPO_NAME}
set -e

# clone/pull the github repo
git clone https://github.com/${GITHUB_ACCOUNT}/${REPO_NAME}.git
# https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/

cd ${REPO_NAME}

git remote add upstream https://${USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_ACCOUNT}/${REPO_NAME}.git
git config user.name "${USERNAME}"
git config user.email "${USER_EMAIL}"

git fetch upstream
git checkout -b ${BRANCH} upstream/${BRANCH}

# replace DESCRIPTION with $VERSION
VERSION_LINE=`grep Version DESCRIPTION`
sed "s|$VERSION_LINE|Version: $VERSION|g" DESCRIPTION > DESCRIPTION.temp

# replace DESCRIPTION with $DATE
DATE=`date +%Y-%m-%d`
DATE_LINE=`grep Date DESCRIPTION.temp`
sed "s|$DATE_LINE|Date: $DATE|g" DESCRIPTION.temp > DESCRIPTION2.temp

rm DESCRIPTION
mv DESCRIPTION2.temp DESCRIPTION
rm DESCRIPTION.temp

cat man/synapser-package.Rd

# replace man/synapser-package.Rd with $VERSION
VERSION_LINE=`grep Version man/synapser-package.Rd`
sed "s|$VERSION_LINE|Version: \tab $VERSION \cr|g" man/synapser-package.Rd > man/synapser-package.Rd.temp
# replace man/synapser-package.Rd with $DATE
DATE=`date +%Y-%m-%d`
DATE_LINE=`grep Date man/synapser-package.Rd.temp`
sed "s|$DATE_LINE|Date: \tab $DATE \cr|g" man/synapser-package.Rd.temp > man/synapser-package.Rd2.temp

rm man/synapser-package.Rd
mv man/synapser-package.Rd2.temp man/synapser-package.Rd
rm man/synapser-package.Rd.temp

cat man/synapser-package.Rd

git add --all
git commit -m "Version $VERSION is succesfully built on $DATE"
git push upstream ${BRANCH}

git tag $VERSION
git push upstream $VERSION

cd ..
rm -rf ${REPO_NAME}

