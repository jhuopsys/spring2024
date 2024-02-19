#!/bin/bash
# CS 418/618 lab submission script
#
# We highly recommend that you create your submission using this script to ensure
# that everything needed for grading in included If you create your submission
# manually in ignorance of these directions, please be advised that there will be
# a _significant_ deduction if your submission is missing any requirements.
#
# Please contact the teaching staff if you encounter any issues with this script.
# If you get the error "bash: ./create_submission.sh: Permission denied" or some
# variant thereof, please run `chmod u+x ./create_submission.sh`.

###########################################
# Configuration parameters, DO NOT CHANGE
###########################################
DESIGN_DOC_LOC="src/threads/DESIGNDOC"
ASSIGNMENT_NAME="OS Lab 1"
CLASS="CS418/618"
GITHUB_ORG="jhuopsys"
SUBMISSION_STAGING_DIR="submission_staging_temp"
SUBMISSION_FILE_NAME="submission.zip"

###########################################
# SCript body
###########################################
echo -e "Welcome to the '${ASSIGNMENT_NAME}' submission script."
echo -e "You may be asked to authenticate with git while we verify your repo."
echo -e "Please note that we are not handling your creditials in any way and "
echo -e "they are directly being requested and processed by the 'git' command.\n"

if [[ ! -f "${DESIGN_DOC_LOC}" ]]; then
    echo "ERROR: We couldn't find a design doc at the expected location"
    echo "Please put your design doc at the following location and check"
    echo "it into github, and run this script again:"
    printf "    ${DESIGN_DOC_LOC}\n"
    exit 1
fi

GIT_REPO_URL=$(git config --get remote.origin.url)
GIT_REPO=$(echo -n "${GIT_REPO_URL}" | sed -E --expression="s|.*${GITHUB_ORG}/(.*)|\1|")
GIT_REPO=${GIT_REPO%.git}
if [[ "${GIT_REPO}" == "" ]]; then
    echo "Oops, we couldn't recognize your repo from the git metadata. Please report this error to the CAs."
    echo "    Addt'l info: ORIG_LINK=${GIT_REPO_URL}"
    exit 1
fi

if [[ -z $(git status -s) ]]; then
    echo "You have uncommitted changes, please commit them before attempting to submit."
    echo "You can also stash them if you would prefer not to submit the changes."
    exit 1
fi

GIT_HEAD_COMMIT=$(git rev-parse HEAD)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git fetch origin ${GIT_BRANCH}
UNPUSHED_COMMITS=$(git rev-list FETCH_HEAD..${GIT_BRANCH} --count)
if [[ ${UNPUSHED_COMMITS} -ne 0 ]]; then
    echo "You have unpushed commits on this branch, please push them before attempting to submit."
    exit 1
fi

echo "We will turn in the current state of the '${GIT_BRANCH}' branch for grading."
echo "The current commit at the head of your branch is:"
git -P show -s HEAD
echo -e "Please do not overwrite this commit after making your final submission. We will consider"
echo -e "any attempt to tamper with the commit history and files included in the history after"
echo -e "submission to be academic dishonesty."
echo -e "You can press ctrl-c now to cancel if this doesn't look right.\n"

echo -e "We will now ask you to enter the base commit so we can ensure we are grading "
echo -e "the right files. This is the commit before you started working on this lab."
echo -e "You can find this info by going to github and clicking the 'history' button "
echo -e "for your repo, and scrolling until you find the first commit you made for this lab"
echo -e "and copying the hash of the commit before that."
echo -e "Please ensure this info is accurate to the best of your knowledge.\n"
read -p "Please enter the base commit: " GIT_BASE_COMMIT
GIT_BASE_COMMIT=$(printf ${GIT_BASE_COMMIT} | tr -d '\n')
if ! git merge-base --is-ancestor "${GIT_BASE_COMMIT}" "${GIT_HEAD_COMMIT}" &> /dev/null; then
    echo "We couldn't find that base commit, please check your commit hash and try again."
    exit 1
fi
IFS='' read -p "Please enter your group members, separated by commas: " MEMBERS
GIT_DIFF=$(git diff ${GIT_BASE_COMMIT} ${GIT_HEAD_COMMIT} --stat)

echo -e "\nPlease wait, we are packaging your submission..."
rm -rf  "${SUBMISSION_STAGING_DIR}" "${SUBMISSION_FILE_NAME}"
mkdir "${SUBMISSION_STAGING_DIR}"
cat << EOF > "${SUBMISSION_STAGING_DIR}/submission-receipt.txt"
Submission Receipt File
-----------------------
Assignment: ${ASSIGNMENT_NAME}
Class: ${CLASS}
Authors: ${MEMBERS}
System time: $(date)

#######################################################

Please ensure that you do not overwrite this commit!

Git Info:
* Branch: ${GIT_BRANCH}
* HEAD commit: ${GIT_HEAD_COMMIT}
* Base commit: ${GIT_BASE_COMMIT}

Grading Links:
* Repo link: https://github.com/${GITHUB_ORG}/${GIT_REPO}
* HEAD link: https://github.com/${GITHUB_ORG}/${GIT_REPO}/commit/${GIT_HEAD_COMMIT}
* Base commit link: https://github.com/${GITHUB_ORG}/${GIT_REPO}/commit/${GIT_BASE_COMMIT}
* Branch link: https://github.com/${GITHUB_ORG}/${GIT_REPO}/tree/${GIT_BRANCH}
* Compare link: https://github.com/${GITHUB_ORG}/${GIT_REPO}/compare/${GIT_BASE_COMMIT}..${GIT_HEAD_COMMIT}


#######################################################

Modified files summary:
${GIT_DIFF}
EOF

cp ${DESIGN_DOC_LOC} "${SUBMISSION_STAGING_DIR}/"
cd ""${SUBMISSION_STAGING_DIR}""
echo -e "    Creating submission zip..."
zip -q -9 "../${SUBMISSION_FILE_NAME}" ./*
cd ..
rm -rf submission_staging_temp
echo "Done! You may now submit '${SUBMISSION_FILE_NAME}' to Gradescope."
