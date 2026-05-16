.PHONY: lint

lint:
	gawk --lint -f app/pronouns.awk /dev/null
	gawk --lint -f app/conjunctions.awk /dev/null
