# Manjaro Linux docker with `paru`

As per description, this is just a Manjaro Linux docker image with `paru` installed.
To use `paru`, an user named `build` is created with no password and passwordless sudo access.
The container still defaults to the `root` user,
to run a paru command, you can use `sudo -u build paru <command>`.
