LANGUAGE_PKGS=\
	fcitx \
	fcitx-hangul \
	fcitx-module-cloudpinyin \
	fcitx-mozc \
	fcitx-pinyin \
	fcitx-table \
	fcitx-unikey \
	fcitx-ui-qimpanel \
	firefox-locale-de \
	firefox-locale-en \
	firefox-locale-es \
	firefox-locale-fr \
	firefox-locale-it \
	firefox-locale-pt \
	firefox-locale-ru \
	firefox-locale-zh-hans \
	fonts-arphic-ukai \
	fonts-arphic-uming \
	fonts-dejavu-core \
	fonts-droid-fallback \
	fonts-freefont-ttf \
	fonts-guru \
	fonts-guru-extra \
	fonts-kacst \
	fonts-kacst-one \
	fonts-khmeros-core \
	fonts-lao \
	fonts-liberation \
	fonts-lklug-sinhala \
	fonts-lohit-guru \
	fonts-nanum \
	fonts-noto-cjk \
	fonts-noto-mono \
	fonts-opensymbol \
	fonts-sil-abyssinica \
	fonts-sil-padauk \
	fonts-symbola \
	fonts-takao-pgothic \
	fonts-thai-tlwg \
	fonts-tibetan-machine \
	fonts-tlwg-garuda \
	fonts-tlwg-garuda-ttf \
	fonts-tlwg-kinnari \
	fonts-tlwg-kinnari-ttf \
	fonts-tlwg-laksaman \
	fonts-tlwg-laksaman-ttf \
	fonts-tlwg-loma \
	fonts-tlwg-loma-ttf \
	fonts-tlwg-mono \
	fonts-tlwg-mono-ttf \
	fonts-tlwg-norasi \
	fonts-tlwg-norasi-ttf \
	fonts-tlwg-purisa \
	fonts-tlwg-purisa-ttf \
	fonts-tlwg-sawasdee \
	fonts-tlwg-sawasdee-ttf \
	fonts-tlwg-typewriter \
	fonts-tlwg-typewriter-ttf \
	fonts-tlwg-typist \
	fonts-tlwg-typist-ttf \
	fonts-tlwg-typo \
	fonts-tlwg-typo-ttf \
	fonts-tlwg-umpush \
	fonts-tlwg-umpush-ttf \
	fonts-tlwg-waree \
	fonts-tlwg-waree-ttf \
	gnome-getting-started-docs \
	gnome-getting-started-docs-de \
	gnome-getting-started-docs-es \
	gnome-getting-started-docs-fr \
	gnome-getting-started-docs-it \
	gnome-getting-started-docs-pt \
	gnome-getting-started-docs-ru \
	gnome-user-docs \
	hunspell-de-at-frami \
	hunspell-de-ch-frami \
	hunspell-de-de-frami \
	hunspell-en-au \
	hunspell-en-ca \
	hunspell-en-gb \
	hunspell-en-us \
	hunspell-en-za \
	hunspell-es \
	hunspell-fr \
	hunspell-fr-classical \
	hunspell-it \
	hunspell-pt-br \
	hunspell-pt-pt \
	hunspell-ru \
	hyphen-de \
	hyphen-en-ca \
	hyphen-en-gb \
	hyphen-en-us \
	hyphen-fr \
	hyphen-it \
	hyphen-pt-br \
	hyphen-pt-pt \
	hyphen-ru \
	ibus-gtk \
	ibus-gtk3 \
	language-pack-gnome-de \
	language-pack-gnome-en \
	language-pack-gnome-es \
	language-pack-gnome-fr \
	language-pack-gnome-it \
	language-pack-gnome-pt \
	language-pack-gnome-ru \
	language-pack-gnome-zh-hans \
	libreoffice-help-de \
	libreoffice-help-en-gb \
	libreoffice-help-en-us \
	libreoffice-help-es \
	libreoffice-help-fr \
	libreoffice-help-it \
	libreoffice-help-pt \
	libreoffice-help-pt-br \
	libreoffice-help-ru \
	libreoffice-help-zh-cn \
	libreoffice-help-zh-tw \
	libreoffice-l10n-de \
	libreoffice-l10n-en-gb \
	libreoffice-l10n-en-za \
	libreoffice-l10n-es \
	libreoffice-l10n-fr \
	libreoffice-l10n-it \
	libreoffice-l10n-pt \
	libreoffice-l10n-pt-br \
	libreoffice-l10n-ru \
	libreoffice-l10n-zh-cn \
	libreoffice-l10n-zh-tw \
	mozc-utils-gui \
	mythes-de \
	mythes-de-ch \
	mythes-en-au \
	mythes-en-us \
	mythes-fr \
	mythes-it \
	mythes-pt-pt \
	mythes-ru \
	onboard \
	wamerican \
	wbrazilian \
	wbritish \
	wfrench \
	witalian \
	wngerman \
	wogerman \
	wportuguese \
	wspanish \
	wswiss

ifeq ($(DISTRO_VERSION),17.10)
LANGUAGE_PKGS += \
	gnome-user-docs-de \
	gnome-user-docs-es \
	gnome-user-docs-fr \
	gnome-user-docs-it \
	gnome-user-docs-pt \
	gnome-user-docs-ru \
	gnome-user-docs-zh-hans
endif
