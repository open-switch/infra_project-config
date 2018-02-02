# Moving Docker Installation

- Problem: Jenkins slave root volume out of space from docker
- Solution: Move docker installation to 100GB EBS volume and implement more
  stringent docker cleanup

You can change Docker's storage base directory (where container and images go) using the `-g` option when starting the Docker daemon.

Ubuntu/Debian: edit your `/etc/default/docker` file with the `-g` option: `DOCKER_OPTS="-g /mnt/docker"`

**Caution** - These steps depend on your current `/var/lib/docker` being an actual directory (not a symlink to another location).

1. Stop docker: `service docker stop`. Verify no docker process is running `ps faux | grep docker`
2. Double check docker really isn't running. Take a look at the current docker directory: `ls /var/lib/docker/`
3. Make a backup: `tar -zcC /var/lib docker > /mnt/var_lib_docker-backup-$(date +%s).tar.gz`
4. Move the `/var/lib/docker` directory to your new partition: `mv /var/lib/docker /mnt/docker`
5. Make a symlink: `ln -s /mnt/docker /var/lib/docker`
6. Take a peek at the directory structure to make sure it looks like it did before the mv: `ls /var/lib/docker/` (note the trailing slash to resolve the symlink)
7. Start docker back up `service docker start`
8. Restart your containers

> From [Docker Forums](https://forums.docker.com/t/how-do-i-change-the-docker-image-installation-directory/1169)
