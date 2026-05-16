.PHONY: lint

lint:
	gawk --lint -f app/pronouns.awk /dev/null
