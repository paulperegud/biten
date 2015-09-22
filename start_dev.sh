#! /bin/sh

erl -pa deps/*/ebin -pa ebin -boot start_sasl -s biten_app -s sync
