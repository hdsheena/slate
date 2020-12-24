#!/usr/bin/env bash
bundle exec middleman build --clean
cp -r build/. ../docs-sfs/.
