PROJECT = biten

ERLC_OPTS = +debug_info +'{parse_transform, lager_transform}'
TEST_ERLC_OPTS = +debug_info +'{parse_transform, lager_transform}'

ERL_CT_OPTS = -erl_args -config $(CT_CONFIG)

PLT_APPS = lager erlsha2
PLT_APPS += crypto runtime_tools stdlib ssl

REBAR_DEPS_DIR = $(shell pwd)/deps
export REBAR_DEPS_DIR

RELX_OUTPUT_DIR = release

DEPS = erlsha2 lager
DEPS += sync eper

dep_lager = git https://github.com/basho/lager 2.1.0
dep_erlsha2 = git https://github.com/vinoski/erlsha2.git master

dep_sync = git https://github.com/rustyio/sync.git master
dep_eper = git https://github.com/massemanet/eper.git master

.PHONY : check_config

default: app # will compile project only, without deps

check_config: rel/files/app.config relx.config

rel/files/app.config: rel/files/app.config.sample
	false
relx-dev.config: relx-dev.config.sample
	false

include erlang.mk # defines: app deps tests clean rel

# fast eunit test
funit: ERLC_OPTS=$(TEST_ERLC_OPTS)
funit: clean app
	@$(MAKE) --no-print-directory app-build test-dir ERLC_OPTS="$(TEST_ERLC_OPTS)"
	$(gen_verbose) $(EUNIT_RUN)

rel: $(RELX) relx.config check_config
	$(RELX) -V 2 -n $(PROJECT) -o $(RELX_OUTPUT_DIR) -c relx.config

devclean: clean
	rm -rf ./$(RELX_OUTPUT_DIR)/*
	rm -rf ./ebin/*
