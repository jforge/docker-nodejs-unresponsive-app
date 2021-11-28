#!/usr/bin/env bash
#
# Simple API test for the unresponsive app
#
set -Euxo pipefail

# ensure script folder as the exec location
cd $(dirname `[[ $0 = /* ]] && echo "$0" || echo "$PWD/${0#./}"`)

TEST_IMAGE_TAG=test-`uuidgen | tr "[:upper:]" "[:lower:]"`

cleanup () {
  docker rm -f $(docker ps -aqf "ancestor=${TEST_IMAGE_TAG}")
}

# catch unexpected failures, do cleanup and output an error message
trap 'cleanup'\
  HUP INT QUIT PIPE TERM

# startup
docker build -t ${TEST_IMAGE_TAG} .. && docker run -d -p 8080:8095 ${TEST_IMAGE_TAG}
if [ $? -ne 0 ] ; then
  printf "Creating container failed\n"
  cleanup
  exit -1
fi

# trigger requests
HTTP_CLIENT_CALL_PREFIX="wget -qO-"
BASE_URI=http://localhost:8080

${HTTP_CLIENT_CALL_PREFIX} ${BASE_URI}/api/health
echo $?

${HTTP_CLIENT_CALL_PREFIX} --tries=1 --timeout=3 ${BASE_URI}/any/other/uri
echo $?

${HTTP_CLIENT_CALL_PREFIX} ${BASE_URI}/manage/set_responsive
echo $?

${HTTP_CLIENT_CALL_PREFIX} ${BASE_URI}/any/other/uri
echo $?

${HTTP_CLIENT_CALL_PREFIX} --method=POST ${BASE_URI}/any/other/uri/with/post
echo $?

${HTTP_CLIENT_CALL_PREFIX} ${BASE_URI}/manage/block_head_requests
echo $?

${HTTP_CLIENT_CALL_PREFIX} --tries=1 --timeout=3 --method=HEAD ${BASE_URI}/manage/health
echo $?

${HTTP_CLIENT_CALL_PREFIX} ${BASE_URI}/manage/allow_head_requests
echo $?

${HTTP_CLIENT_CALL_PREFIX} --method=HEAD ${BASE_URI}/manage/health
echo $?

${HTTP_CLIENT_CALL_PREFIX} ${BASE_URI}/manage/set_unresponsive
echo $?

cleanup

exit $?
