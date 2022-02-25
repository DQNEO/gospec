# force GNU sed
ifeq ($(shell uname),Linux)
	# for Linux
	SED := sed
else
	# for MacOS assuming GNU sed is installed as "gsed"
	SED := gsed
endif

all: docs/spec.html docs/dic.ja.js docs/word2lemma.js

.PHONY: spec_orig.html
spec_orig.html:
	wget -O spec_orig.html 'https://tip.golang.org/ref/spec'

docs/spec.html: spec_orig.html
	perl -p -e 'BEGIN{undef $$/;}  s|<script\s*>[^<]*</script>||smg' $< > spec_noscript.html
	cat spec_noscript.html | $(SED) '6 a <link type="text/css" rel="stylesheet" href="dictionary.css"><script src="word2lemma.js"></script><script src="dic.ja.js"></script><script src="main.js"></script><script src="toc.js"></script>' > $@
	perl -pi -e 's#/css/#css/#g' $@
	perl -pi -e 's#/images/#images/#g' $@
	perl -pi -e 'BEGIN{undef $$/;}  s|(<h1>\s+The)|$$1 <span id="word-wise">Word Wise</span>|' $@
	perl -pi -e 's|<title>.*</title>|<title>Word Wise Go Spec</title>|' $@
	perl -pi -e 's|(<main)|$$1 ontouchstart |' $@

docs/dic.ja.js: docs/dic.ja.json
	echo 'var dic = ' > $@
	cat $< >> $@

docs/word2lemma.js: docs/word2lemma.json
	echo 'var word2lemma = ' > $@
	cat $< >> $@

