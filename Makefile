default:
	$(MAKE) pdf

pdf: resume.html
	./scripts/pdf.py

resume.html: resume.xml resume.xsl themes/default.xsl
	./scripts/resume.py

clean:
	./scripts/clean.py
