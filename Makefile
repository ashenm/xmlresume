.DEFAULT_GOAL=help

.PHONY: all
.SILENT: all
all: ## build all artefacts
	$(MAKE) resume.pdf

.PHONY: clean
clean: gh-pages/clean ## remove build artefacts
	./scripts/clean.py

.PHONY: help
.SILENT: help
help: ## list make targets
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-.]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: install
install: ## install build dependencies
	./scripts/install.sh

resume.html: resume.xml resume.xsl themes/default.xsl ## build standalone html
	./scripts/resume.py

resume.pdf: resume.html ## build standalone pdf
	./scripts/pdf.py

.PHONY: gh-pages/build
gh-pages/build:
	./.github/scripts/build.sh

.PHONY: gh-pages/clean
gh-pages/clean:
	./.github/scripts/clean.sh

.PHONY: gh-pages/tarball
gh-pages/tarball: gh-pages/build
	./.github/scripts/tarball.sh
