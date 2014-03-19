NAME=collins
VERSION=1.2.3
ITERATION=1
SHA=c9fe4935882eb7ff0d3e945425151a3dc5d9c25ce1ea6ad4c29d5a2c54b1bc24
INSTALLDIR=/usr/local
USER=collins

.PHONY: clean

# TODO - get --directories working so that all dirs are owned by $(USER)
package: checksum preinstall postinstall
	sudo \rm -rf $(NAME)
	unzip $(NAME)-$(VERSION).zip
	fpm -s dir -t rpm \
	  --verbose \
	  --description "Infrastructure management for engineers" \
          --version $(VERSION) \
          --iteration $(ITERATION) \
	  --architecture noarch \
          --rpm-user $(USER) \
          --rpm-group $(USER) \
          --rpm-os linux \
	  --prefix $(INSTALLDIR) \
	  --before-install preinstall \
	  --after-install postinstall \
	  --name $(NAME) \
          $(NAME)
	sudo \rm -rf $(NAME)

preinstall:
	echo "getent passwd $(NAME) || useradd $(NAME)" > $@

postinstall:
	echo "chown -R $(USER):$(USER) $(INSTALLDIR)/$(NAME)" > $@

known.sum: 
	echo "SHA256($(NAME)-$(VERSION).zip)= $(SHA)" > known.sum

challenge.sum: $(NAME)-$(VERSION).zip
	openssl dgst -sha256 $< > challenge.sum

checksum: known.sum challenge.sum
	diff $^ || sudo \rm *.sum ... 2>/dev/null || false
	
$(NAME)-$(VERSION).zip:
	wget http://tumblr.github.io/collins/releases/$(NAME)-$(VERSION).zip

clean:
	sudo \rm -rf *.sum *.rpm

distclean:
	sudo \rm -rf *.sum preinstall postinstall *.zip $(NAME) *.rpm
