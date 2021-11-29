

set -e

run() {
  echo $1;
  eval $1;

  echo $2;
  eval $2;
}

run "psql -c 'create database travis_ci_test;' -U postgres"
run "cp script/templates/database.travis.postgres.yml config/database.yml"

