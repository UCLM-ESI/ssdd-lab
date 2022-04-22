.PHONY: all clean

all:
	jb build -W .

clean:
	jb clean .
	find . -name "*~" -delete
	rm -rf _build

check:
	pre-commit run --all
