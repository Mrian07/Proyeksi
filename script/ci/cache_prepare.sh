

set -e

run() {
  echo $1;
  eval $1;

  echo $2;
  eval $2;
}

run "bundle exec rake db:create db:migrate webdrivers:chromedriver:update webdrivers:geckodriver:update"

run "cd frontend; npm install ; cd -"

run "bundle exec rake assets:precompile assets:clean"

run "cp -rp config/frontend_assets.manifest.json public/assets/frontend_assets.manifest.json"

