

set -e

# script/ci/setup.sh

# $1 = TEST_SUITE
# $2 = PROYEKSIAPP_EDITION

run() {
  echo $1;
  eval $1;

  echo $2;
  eval $2;
}

run "bash $(dirname $0)/db_setup.sh"

# run migrations for postgres
# setup binstubs
if [ $1 != 'npm' ]; then
  run "bundle binstubs parallel_tests"
  run "bundle exec rake db:migrate"
fi

if [ $1 = 'npm' ]; then
  run "for i in {1..3}; do (cd frontend; npm install && break || sleep 15;) done"
  echo "No asset compilation required"
fi

if [ $1 = 'units' ]; then
  # Install pandoc for testing textile migration
  run "sudo apt-get update -qq"
  run "sudo apt-get install -qq pandoc"
fi

if [ ! -f "public/assets/frontend_assets.manifest.json" ]; then
  if [ -z "${RECOMPILE_ON_TRAVIS_CACHE_ERROR}" ]; then
    echo "ERROR: asset manifest was not properly cached. exiting"
    exit 1
  else
    run "bash $(dirname $0)/cache_prepare.sh"
  fi
fi

run "cp -rp public/assets/frontend_assets.manifest.json config/frontend_assets.manifest.json"
