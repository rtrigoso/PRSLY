.PHONY: lint test build clean

OUT = out

lint:
	awk -f parsley.awk /dev/null
	awk -f app/pos_classifier.awk /dev/null
	awk -f app/run_pos.awk /dev/null

test:
	bash tests/test_pronouns.sh
	bash tests/test_conjunctions.sh
	bash tests/test_prepositions.sh
	bash tests/test_nouns.sh
	bash tests/test_verbs.sh

build: $(OUT)/prsly

$(OUT)/prsly: app/pos_classifier.awk app/run_pos.awk
	mkdir -p $(OUT)
	printf '#!/bin/sh\nset -e\n\n' > $@
	printf '_PRSLY_CLASSIFIER=$$(mktemp)\n' >> $@
	printf '_PRSLY_RUNNER=$$(mktemp)\n' >> $@
	printf 'trap '"'"'rm -f "$$_PRSLY_CLASSIFIER" "$$_PRSLY_RUNNER"'"'"' EXIT\n\n' >> $@
	printf 'cat > "$$_PRSLY_CLASSIFIER" << '"'"'CLASSIFIER_EOF'"'"'\n' >> $@
	cat app/pos_classifier.awk >> $@
	printf 'CLASSIFIER_EOF\n\n' >> $@
	printf 'cat > "$$_PRSLY_RUNNER" << '"'"'RUNNER_EOF'"'"'\n' >> $@
	cat app/run_pos.awk >> $@
	printf 'RUNNER_EOF\n\n' >> $@
	printf 'awk -v CLASSIFIER="$$_PRSLY_CLASSIFIER" -f "$$_PRSLY_RUNNER" "$$@"\n' >> $@
	chmod u+x $@

clean:
	rm -rf $(OUT)
