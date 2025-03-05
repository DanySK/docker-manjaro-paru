FROM manjarolinux/base:20250302

# Set the base options for pacman
RUN pacman -Sy --noconfirm patch
WORKDIR /etc
COPY pacman.conf.patch /etc/pacman.conf.patch
RUN patch < pacman.conf.patch
RUN rm /etc/pacman.conf.patch
WORKDIR /

# Configure chaotic-aur
RUN pacman -Syu --noconfirm
RUN pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
RUN pacman-key --lsign-key 3056513887B78AEB
RUN pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
RUN pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
RUN echo '[chaotic-aur]' >> /etc/pacman.conf
RUN echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf

# Install paru
RUN pacman -Sy
RUN pacman -S --noconfirm binutils
RUN pacman -S --noconfirm git
RUN pacman -S --noconfirm pacman-contrib
RUN pacman -S --noconfirm pkgconf
RUN pacman -S --noconfirm rust
WORKDIR /paru
RUN useradd -m build
RUN echo 'build ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN chown -R build:build /paru
USER build
COPY paru /paru
RUN makepkg
USER root
RUN pacman -U --noconfirm paru-*.pkg.tar.zst
WORKDIR /
RUN rm -rf /paru
WORKDIR /
RUN paru --help
RUN paccache -rk 0
RUN paru -Sccd --noconfirm
