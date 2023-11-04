PROG=hello
SRC_NAME=hello.c
LL=hi
COUNTRY=IN
TEXT_DOMAIN = hello

# May cause inconsistency in calls
time=$$(date +'%Y%m%d-%H%M%S')
POT_PREFIX=$(PROG)
POT_NAME=$(POT_PREFIX)-$(time).pot
TR_LOCALE=$(LL)_$(COUNTRY)
PO_FILE=$(TR_LOCALE).po
MO_FILE=$(TEXT_DOMAIN).mo

locale:
	mkdir -p po
	mkdir -p i18n/$(TR_LOCALE)

	xgettext -d $(TEXT_DOMAIN) -s -o "po/$(POT_NAME)" $(SRC_NAME)
	
	if [ ! -f "i18n/$(TR_LOCALE)/$(PO_FILE)" ]; then \
		msginit -l $(TR_LOCALE) -o "i18n/$(TR_LOCALE)/$(PO_FILE)" -i "po/$(POT_NAME)"; \
	else \
		msgmerge -s -U "i18n/$(TR_LOCALE)/$(PO_FILE)" "po/$(POT_NAME)"; \
	fi

edit-locale:
	$(EDITOR) "i18n/$(TR_LOCALE)/$(PO_FILE)"

patch-locale:
	msgfmt -c -v -o "i18n/$(TR_LOCALE)/$(MO_FILE)" "i18n/$(TR_LOCALE)/$(PO_FILE)"

	if [ -e  "/usr/share/locale/$(LL)/" ]; then \
		sudo mkdir -p /usr/share/locale/$(LL)/LC_MESSAGES; \
		sudo cp "i18n/$(TR_LOCALE)/$(MO_FILE)" /usr/share/locale/$(LL)/LC_MESSAGES; \
	fi
	
	if [ -e  "/usr/share/locale/$(LL)_$(COUNTRY)/" ]; then \
		sudo mkdir -p /usr/share/locale/$(LL)_$(COUNTRY)/LC_MESSAGES; \
		sudo cp "i18n/$(TR_LOCALE)/$(MO_FILE)" /usr/share/locale/$(LL)_$(COUNTRY)/LC_MESSAGES; \
	fi

run-default:
	./$(PROG)

run:
	LANGUAGE=$(TR_LOCALE) ./$(PROG)

clean:
	rm $(PROG) po/$(POT_PREFIX)-*.pot "i18n/$(TR_LOCALE)/$(MO_FILE)"
	sudo rm /usr/share/locale/$(LL)/LC_MESSAGES/$(MO_FILE)
	sudo rm /usr/share/locale/$(LL)_$(COUNTRY)/LC_MESSAGES/$(MO_FILE)
