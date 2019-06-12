default:
	$(MAKE) pdf

pdf: standalone.html
	./scripts/pdf.py

standalone.html: resume.html
	./scripts/standalone.py

resume.html: resume.xml themes/default.xsl
	./scripts/resume.py

clean:
	./scripts/clean.py
