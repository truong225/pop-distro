$(BUILD)/iso_create.tag:
	# Remove old ISO
	sudo rm -rf "$(BUILD)/iso"

	# Create new ISO
	mkdir -p "$(BUILD)/iso"

	touch "$@"

$(BUILD)/iso_casper.tag: $(BUILD)/squashfs $(BUILD)/chroot.tag $(BUILD)/live.tag $(BUILD)/iso_create.tag
	# Remove old casper directory
	sudo rm -rf "$(BUILD)/iso/casper"

	# Create new casper directory
	mkdir -p "$(BUILD)/iso/casper"

	# Copy vmlinuz
	sudo cp "$(BUILD)/squashfs/vmlinuz" "$(BUILD)/iso/casper/vmlinuz.efi"

	# Copy initrd
	sudo cp "$(BUILD)/squashfs/initrd.img" "$(BUILD)/iso/casper/initrd.gz"

	# Update manifest
	cp "$(BUILD)/live.tag" "$(BUILD)/iso/casper/filesystem.manifest"
	grep -F -x -v -f "$(BUILD)/chroot.tag" "$(BUILD)/live.tag" | cut -f1 > "$(BUILD)/iso/casper/filesystem.manifest-remove"

	# Update filesystem size
	sudo du -sx --block-size=1 "$(BUILD)/squashfs" | cut -f1 > "$(BUILD)/iso/casper/filesystem.size"

	# Rebuild filesystem image
	sudo mksquashfs "$(BUILD)/squashfs" "$(BUILD)/iso/casper/filesystem.squashfs" -noappend -fstime "$(DISTRO_EPOCH)"

	sudo chown -R "$(USER):$(USER)" "$(BUILD)/iso/casper"

	touch "$@"

$(BUILD)/iso_pool.tag: $(BUILD)/pool $(BUILD)/iso_create.tag
	# Remove dists and pool directory
	sudo rm -rf "$(BUILD)/iso/dists" "$(BUILD)/iso/pool"

	# Copy package pool
	sudo cp -r "$</pool" "$(BUILD)/iso/pool"
	sudo chown -R "$(USER):$(USER)" "$(BUILD)/iso/pool"

	# Update pool package lists
	cd "$(BUILD)/iso" && \
	mkdir -p "dists/$(UBUNTU_CODE)" && \
	for pool in $$(ls -1 pool); do \
		mkdir -p "dists/$(UBUNTU_CODE)/$$pool/binary-amd64" && \
		apt-ftparchive packages "pool/$$pool" > "dists/$(UBUNTU_CODE)/$$pool/binary-amd64/Packages" && \
		gzip -k "dists/$(UBUNTU_CODE)/$$pool/binary-amd64/Packages" && \
		sed "s|COMPONENT|$$pool|g; $(SED)" "../../../data/Release" > "dists/$(UBUNTU_CODE)/$$pool/binary-amd64/Release"; \
	done; \
	apt-ftparchive \
		-o "APT::FTPArchive::Release::Acquire-By-Hash=yes" \
		-o "APT::FTPArchive::Release::Architectures=amd64" \
		-o "APT::FTPArchive::Release::Codename=$(UBUNTU_CODE)" \
		-o "APT::FTPArchive::Release::Components=$$(ls -1 pool | tr $$'\n' ' ')" \
		-o "APT::FTPArchive::Release::Description=$(DISTRO_NAME) $(DISTRO_VERSION)" \
		-o "APT::FTPArchive::Release::Label=Ubuntu" \
		-o "APT::FTPArchive::Release::Origin=Ubuntu" \
		-o "APT::FTPArchive::Release::Suite=$(UBUNTU_CODE)" \
		-o "APT::FTPArchive::Release::Version=$(DISTRO_VERSION)" \
		release "dists/$(UBUNTU_CODE)" \
		> "dists/$(UBUNTU_CODE)/Release" && \
	gpg --batch --yes --digest-algo sha512 --sign --detach-sign --armor --local-user "$(GPG_NAME)" -o "dists/$(UBUNTU_CODE)/Release.gpg" "dists/$(UBUNTU_CODE)/Release" && \
	cd "dists" && \
	ln -s "$(UBUNTU_CODE)" stable && \
	ln -s "$(UBUNTU_CODE)" unstable

	touch "$@"

$(BUILD)/grub:
	rm -rf "$@.partial"
	mkdir "$@.partial"

	grub-mkimage \
		--directory /usr/lib/grub/i386-pc \
		--prefix /boot/grub \
		--output "$@.partial/eltorito.img" \
		--format i386-pc-eltorito \
		--compression auto \
		--config data/grub/load.cfg \
		biosdisk iso9660

	mkdir -p "$@.partial/efi/boot/"
	grub-mkimage \
		--directory /usr/lib/grub/x86_64-efi \
		--prefix "()/boot/grub" \
		--output "$@.partial/efi/boot/bootx64.efi" \
		--format x86_64-efi \
		--compression auto \
		--config data/grub/load.cfg \
		part_gpt part_msdos fat part_apple iso9660

	mformat -C -f 2880 -L 16 -i "$@.partial/efi.img" ::
	mcopy -s -i "$@.partial/efi.img" "$@.partial/efi" ::/

	touch "$@.partial"
	mv "$@.partial" "$@"

$(BUILD)/iso_data.tag: $(BUILD)/iso_create.tag $(BUILD)/grub
	git submodule update --init data/default-settings

	sed "$(SED)" "data/README.diskdefines" > "$(BUILD)/iso/README.diskdefines"

	# Replace disk info
	rm -rf "$(BUILD)/iso/.disk"
	mkdir -p "$(BUILD)/iso/.disk"
	sed "$(SED)" "data/disk/base_installable" > "$(BUILD)/iso/.disk/base_installable"
	sed "$(SED)" "data/disk/cd_type" > "$(BUILD)/iso/.disk/cd_type"
	sed "$(SED)" "data/disk/info" > "$(BUILD)/iso/.disk/info"
	sed "$(SED)" "data/disk/release_notes_url" > "$(BUILD)/iso/.disk/release_notes_url"

	# Replace preseeds
	rm -rf "$(BUILD)/iso/preseed"
	mkdir -p "$(BUILD)/iso/preseed"
	sed "$(SED)" "data/preseed.seed" > "$(BUILD)/iso/preseed/$(DISTRO_CODE).seed"

	# Update grub config
	rm -rf "$(BUILD)/iso/boot/grub"
	mkdir -p "$(BUILD)/iso/boot/grub/"
	sed "$(SED)" "data/grub/grub.cfg" > "$(BUILD)/iso/boot/grub/grub.cfg"
	sed "$(SED)" "data/grub/loopback.cfg" > "$(BUILD)/iso/boot/grub/loopback.cfg"
	cp /usr/share/grub/unicode.pf2 "$(BUILD)/iso/boot/grub/font.pf2"

	# Copy grub modules (BIOS)
	mkdir -p "$(BUILD)/iso/boot/grub/i386-pc/"
	cp "$(BUILD)/grub/eltorito.img" "/usr/lib/grub/i386-pc/"* "$(BUILD)/iso/boot/grub/i386-pc/"

	# Copy grub modules (EFI)
	cp "$(BUILD)/grub/efi.img" "$(BUILD)/iso/boot/grub"
	mkdir -p "$(BUILD)/iso/boot/grub/x86_64-efi/"
	cp "/usr/lib/grub/x86_64-efi/"* "$(BUILD)/iso/boot/grub/x86_64-efi/"

	# Copy grub theme
	cp -r "data/default-settings/usr/share/grub/themes" "$(BUILD)/iso/boot/grub/themes"

	touch "$@"

$(BUILD)/iso_sum.tag: $(BUILD)/iso_casper.tag $(BUILD)/iso_pool.tag $(BUILD)/iso_data.tag
	# Calculate md5sum
	cd "$(BUILD)/iso" && \
	rm -f md5sum.txt && \
	find -type f -print0 | sort -z | xargs -0 md5sum > md5sum.txt

	touch "$@"

$(BUILD)/$(ISO_NAME).tar: $(BUILD)/iso_sum.tag
	tar --create \
		--mtime="@$(DISTRO_EPOCH)" --sort=name \
	    --owner=0 --group=0 --numeric-owner --mode='a=,u+rX' \
	    --file "$@.partial" --directory "$(BUILD)/iso" .

	mv "$@.partial" "$@"

$(ISO): $(BUILD)/iso_sum.tag
	xorriso -as mkisofs \
		--protective-msdos-label \
		-b boot/grub/i386-pc/eltorito.img \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--grub2-boot-info --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
		--efi-boot "boot/grub/efi.img" -efi-boot-part --efi-boot-image \
		-r -V "$(DISTRO_NAME) $(DISTRO_VERSION) amd64" \
		-o "$@.partial" "$(BUILD)/iso" -- \
		-volume_date all_file_dates ="$(DISTRO_EPOCH)"

	mv "$@.partial" "$@"

$(ISO).zsync: $(ISO)
	cd "$(BUILD)" && zsyncmake -o "`basename "$@.partial"`" "`basename "$<"`"

	mv "$@.partial" "$@"

$(BUILD)/SHA256SUMS: $(ISO)
	cd "$(BUILD)" && sha256sum -b "`basename "$<"`" > "`basename "$@.partial"`"

	mv "$@.partial" "$@"

$(BUILD)/SHA256SUMS.gpg: $(BUILD)/SHA256SUMS
	cd "$(BUILD)" && gpg --batch --yes --output "`basename "$@.partial"`" --detach-sig "`basename "$<"`"

	mv "$@.partial" "$@"
