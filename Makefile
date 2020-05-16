.DEFAULT_GOAL=help

.PHONY: all
.SILENT: all
all: ## build all artefacts
	$(MAKE) resume.pdf

.PHONY: help
.SILENT: help
help: ## list make targets
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-.]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

resume.pdf: resume.html ## build standalone pdf
	./scripts/pdf.py

resume.html: resume.xml resume.xsl themes/default.xsl ## build standalone html
	./scripts/resume.py

.PHONY: install
install: ## install build dependencies
	./.travis/install.sh

.PHONY: clean
clean: ## remove build artefacts
	./scripts/clean.py
