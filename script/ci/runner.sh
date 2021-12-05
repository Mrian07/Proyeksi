


# script/ci/runner.sh
# $1 = TEST_SUITE
# $2 = GROUP_SIZE
# $3 = GROUP
# $4 = PROYEKSIAPP_EDITION

#!/bin/sh

set -e

# Use the current HEAD as input to the seed
export CI_SEED=$(git rev-parse HEAD | tr -d 'a-z' | cut -b 1-5 | tr -d '0')
# Do not assume to have the angular cli running to serve assets. They are provided
# by rails assets:precompile
export PROYEKSIAPP_CLI_PROXY=''

case "$1" in
        npm)
            cd frontend && npm run test
            ;;
        *)
            bundle exec rake parallel:$1 -- --group-number $2 --only-group $3 --seed $CI_SEED
esac
