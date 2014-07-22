DOCBASE = treeview-tutorial
DOCEXT  = xml

DOCFILE = $(DOCBASE).$(DOCEXT)

SRCBASE = $(DOCBASE)-$(DOCEXT)

default:
	@echo
	@echo "Makefile targets: html pdf ps force clean check"
	@echo
	@echo "  e.g.   make html    will create a html version of the tutorial."
	@echo

html: $(DOCFILE) docbook-utils-a4.dsl treeview-tutorial.css
	 db2html --dsl docbook-utils-a4.dsl#html $(DOCFILE) ; \
	 test -d html && rm -rf ./html/; \
	 mv $(DOCBASE) html ; \
	 mkdir html/images; \
	 cp images/*.png html/images
	 cp treeview-tutorial.css html/
	 cat html/treeview-tutorial.html | sed -e 's%</head%<meta name="keywords" content="gtk tree view,treeview,gtk,GtkTreeView,tutorial,documentation,help,introduction,FAQ"><meta name="description" content="Gtk Tree View tutorial"></head%i' > tmp.html
	 mv tmp.html html/treeview-tutorial.html 

pdf: $(DOCFILE)
	db2pdf --dsl "docbook-utils-a4.dsl#print" $(DOCFILE)

ps: $(DOCFILE)
	db2ps --dsl "docbook-utils-a4.dsl#print" $(DOCFILE)

force:
	touch $(DOCFILE) && make html

clean:
	rm -rf ./html/ 2>/dev/null
	rm -f $(DOCBASE).ps $(DOCBASE).pdf $(DOCBASE).out $(DOCBASE).aux $(DOCBASE).dvi $(DOCBASE).log 2>/dev/null 
	rm -f examples.tar.gz 2>/dev/null
	rm -f *~ 2>/dev/null
	rm -rf $(SRCBASE)/ $(SRCBASE).tar.gz 2>/dev/null

check: $(DOCFILE)
	xmllint --valid --noout $(DOCFILE)

examples.tar.gz: examples
	( test -e examples.tar.gz && rm examples.tar.gz ) || /bin/true
	cd examples/ && make clean && cd ..
	tar --exclude CVS --exclude .cvsignore -cf examples.tar examples/
	gzip examples.tar

src: $(DOCFILE) docbook-utils-a4.dsl treeview-tutorial.css images check
	rm -rf $(SRCBASE)/ $(SRCBASE).tar $(SRCBASE).tar.gz 2>/dev/null || /bin/null
	mkdir $(SRCBASE)/
	cp -R Makefile $(DOCFILE) docbook-utils-a4.dsl treeview-tutorial.css images/ $(SRCBASE)/
	tar --exclude CVS --exclude .cvsignore -cf $(SRCBASE).tar $(SRCBASE)/*
	gzip $(SRCBASE).tar


dist: html examples
	rm -rf treeview-tutorial/ 2>/dev/null || /bin/true
	mkdir treeview-tutorial/
	rm html/examples.tar.gz 2>/dev/null  || /bin/true
	cp -R html/ treeview-tutorial/
	cp -R examples/ treeview-tutorial/
	rm treeview-tutorial.tar.gz 2>/dev/null || /bin/true
	tar --exclude CVS --exclude .cvsignore -cf treeview-tutorial.tar treeview-tutorial/
	gzip treeview-tutorial.tar
	rm -rf treeview-tutorial/

#upload: examples.tar.gz dist html src pdf
#	mv examples.tar.gz html/
#	mv treeview-tutorial.tar.gz html/
#	mv $(SRCBASE).tar.gz html/
#	mv $(DOCBASE).pdf html/
#	cd html/ && rm -f uploadball.tar && tar cf ../uploadball.tar *html *css examples.tar.gz treeview-tutorial.tar.gz $(SRCBASE).tar.gz $(DOCBASE).pdf images/*png
#	rm -f uploadball.tar.bz2
#	bzip2 uploadball.tar
#	scp uploadball.tar.bz2 uberdork@scentric.sourceforge.net:/home/groups/s/sc/scentric/htdocs/temp/tutorial/
#	ssh uberdork@scentric.sourceforge.net "cd /home/groups/s/sc/scentric/htdocs/temp/tutorial && tar xjf uploadball.tar.bz2 && rm uploadball.tar.bz2"
#	echo "**** Done. "


upload-html: html
	rsync -Cavz \
		--rsh="ssh -l uberdork" \
		./html/* \
		uberdork@shell.sourceforge.net:/home/groups/s/sc/scentric/htdocs/tutorial/

upload: clean upload-html examples.tar.gz src pdf dist
	rsync -Cav  \
		--rsh="ssh -l uberdork" \
		./examples.tar.gz \
		./$(SRCBASE).tar.gz \
		./$(DOCBASE).pdf \
		./treeview-tutorial.tar.gz \
		uberdork@shell.sourceforge.net:/home/groups/s/sc/scentric/htdocs/tutorial/

#upload: examples.tar.gz dist html src pdf
#	mv examples.tar.gz html/
#	mv treeview-tutorial.tar.gz html/
#	mv $(SRCBASE).tar.gz html/
#	mv $(DOCBASE).pdf html/
#	cd html/ && rm -f uploadball.tar && tar cf ../uploadball.tar *html *css examples.tar.gz treeview-tutorial.tar.gz $(SRCBASE).tar.gz $(DOCBASE).pdf images/*png
#	rm -f uploadball.tar.bz2
#	bzip2 uploadball.tar
#	scp uploadball.tar.bz2 uberdork@scentric.sourceforge.net:/home/groups/s/sc/scentric/htdocs/temp/tutorial/
#	ssh uberdork@scentric.sourceforge.net "cd /home/groups/s/sc/scentric/htdocs/temp/tutorial && tar xjf uploadball.tar.bz2 && rm uploadball.tar.bz2"
#	echo "**** Done. "




