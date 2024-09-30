FROM manjarolinux/base:20240926
RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm pamac-cli libsoup3
RUN pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
RUN pacman-key --lsign-key 3056513887B78AEB
RUN pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
RUN pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
RUN echo '[chaotic-aur]' >> /etc/pacman.conf
RUN echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf
RUN mkdir -p /var/tmp/pamac/dbs/sync
RUN pamac install pacman-contrib --no-confirm
RUN sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf
RUN paccache -rk 0
RUN pamac clean -b
