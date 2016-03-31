#!/bin/bash -x

[ -d _deploy ] || git clone . _deploy

pushd _deploy
git pull

head=$(git rev-parse HEAD)

git checkout --detach
make
git add -f --all
git reset HEAD -- org-mode htmlize
git commit -m "Deployed $(date)"
git tag deploy-$(date +%Y-%m-%d-%H-%M)
git push -f $1 HEAD:refs/heads/gh-pages

trap "git reset $head" EXIT
trap "popd; rm -r _deploy" INT
