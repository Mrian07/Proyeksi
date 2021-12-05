---
sidebar_navigation:
  title: Upgrading
  priority: 7
---

# Upgrading your ProyeksiApp installation

<div class="alert alert-warning" role="alert">
**Note**: In the rest of this guide, we assume that you have taken the necessary steps to [backup](../backing-up) your ProyeksiApp installation before upgrading.
</div>

| Topic                                                        | Content                                                     |
| ------------------------------------------------------------ | ----------------------------------------------------------- |
| [Package-based installation](#package-based-installation-debrpm) | How to upgrade a package-based installation of ProyeksiApp. |
| [Docker-based installation](#compose-based-installation)      | How to upgrade a Docker-based installation of ProyeksiApp.  |
| [Upgrade notes for 8.x to 9.x](#upgrade-notes-for-8x-to-9x)  | How to upgrade from ProyeksiApp 8.x to ProyeksiApp 9.x.     |
| [Upgrade notes for 7.x to 8.x](#upgrade-notes-for-proyeksiapp-7x-to-8x) | How to upgrade from ProyeksiApp 7.x to ProyeksiApp 8.x.     |

## Package-based installation (DEB/RPM)

Upgrading ProyeksiApp is as easy as installing a newer ProyeksiApp package and
running the `proyeksiapp configure` command.

<div class="alert alert-info" role="alert">

Please note that the package-based installation uses different release channels for each MAJOR version of ProyeksiApp. This means that if you want to switch from (e.g.) 9.x to 10.x, you will need to perform the steps described in the [installation section](../../installation/packaged) to update your package sources to point to the newer release channel. The rest of this section is only applicable if you want to upgrade a (e.g.) 10.x version to a 10.y version.

</div>

### Debian / Ubuntu

```bash
sudo apt-get update
sudo apt-get install --only-upgrade proyeksiapp
sudo proyeksiapp configure
```

### CentOS / RHEL

```bash
sudo yum update
sudo yum install proyeksiapp
sudo proyeksiapp configure
```

### SuSE

```bash
sudo zypper update proyeksiapp
sudo proyeksiapp configure
```


<div class="alert alert-info" role="alert">
Using `proyeksiapp configure`, the wizard will display new steps that weren't available yet or had not been configured in previous installations.

If you want to perform changes to your configuration or are unsure what steps are available, you can safely run `proyeksiapp reconfigure` to walk through the entire configuration process again.

Note that this still takes previous values into consideration. Values that should not change from your previous configurations can be skipped by pressing `<Return>`. This also applies for steps with passwords, which are shown as empty even though they may have a value. Skipping those steps equals to re-use the existing value.
</div>


## Compose-based installation

When using the Compose-based docker installation, you can simply do the following:

```bash
docker-compose pull
docker-compose up -d
```

Please note that you can override the `TAG` that is used to pull the ProyeksiApp image from the [Docker Hub](https://hub.docker.com/r/proyeksiapp/community).

### All-in-one container

When using the all-in-one docker container, you need to perform the following steps:

1. First, pull the latest version of the image:

```bash
docker pull proyeksiapp/community:VERSION
# e.g. docker pull proyeksiapp/community:10
```

Then stop and remove your existing container (we assume that you are running with the recommended production setup here):

```bash
docker stop proyeksiapp
docker rm proyeksiapp
```

Finally, re-launch the container in the same way you launched it previously.
This time, it will use the new image:

```
docker run -d ... proyeksiapp/community:VERSION
```

#### I have already started ProyeksiApp without mounted volumes. How do I save my data during an update?

You can extract your data from the existing container and mount it in a new one with the correct configuration.

1. Stop the container to avoid changes to the data. Stopping the container does not delete any data as long as you don't remove the container.
2. Copy the data to a new directory on the host, e.g. `/var/lib/proyeksiapp`, or a mounted network drive, say `/volume1`.
3. Launch the new container mounting the folders in that directory as described above.
4. Delete the old container once you confirmed the new one is working correctly.

You can copy the data from the container using `docker cp` like this:

```
# Find out the container name with `docker ps`, we use `proyeksiapp-community1` here.
# The target folder should be what ever persistent volume you have on the system, e.g. `/volume1`.
docker cp proyeksiapp-community1:/var/proyeksiapp/assets /volume1/proyeksiapp/assets
docker cp proyeksiapp-community1:/var/proyeksiapp/pgdata /volume1/proyeksiapp/pgdata
```

Make sure the folders have the correct owner so the new container can read and write them.

```
sudo chown -R 102 /volume1/proyeksiapp/*
```

After that it's simply a matter of launching the new container mounted with the copied `pgdata` and `assets` folders
as described in the [installation section](../../installation/docker/#one-container-per-process-recommended).

## Upgrade notes for 8.x to 9.x

These following points are some known issues regarding the update to 9.0.

### MySQL is being deprecated

ProyeksiApp 9.0. is deprecating MySQL support. You can expect full MySQL support for the course of 9.0 releases, but we are likely going to be dropping MySQL completely in one of the following releases.

For more information regarding motivation behind this and migration steps, please see [this blog post](https://www.proyeksi.id/blog/deprecating-mysql-support/). In the post, you will find documentation for a mostly-automated migration script to PostgreSQL to help you get up and running with PostgreSQL.

### Package repository moved into opf/proyeksiapp

The ProyeksiApp community installation is now using the same repository as the ProyeksiApp development core.

Please update your package source according to our [installation section](../../installation/packaged).

You will need to replace `opf/proyeksiapp-ce` with `opf/proyeksiapp` together with a change from `stable/8` to `stable/9` in order to perform the update.

If you have currently installed the stable 8.x release of ProyeksiApp by using the `stable/8` package source,
you will need to adjust that package source.

#### APT-based systems (Debian, Ubuntu)

 - Update the reference to `opf/proyeksiapp-ce` in `/etc/apt/sources.list.d/proyeksiapp.list` to `opf/proyeksiapp`.
 - Update the reference to `stable/8` in `/etc/apt/sources.list.d/proyeksiapp.list` to `stable/9`.
 - Perform the Upgrade steps as mentioned above in *Upgrading your ProyeksiApp installation*

#### YUM-based systems (CentOS, RHEL)

 - Update the reference to `opf/proyeksiapp-ce` in `/etc/yum.repos.d/proyeksiapp.repo` to `opf/proyeksiapp`.
 - Update the reference to `stable/8` in `/etc/yum.repos.d/proyeksiapp.repo` to `stable/9`.
 - Perform the Upgrade steps as mentioned above in *Upgrading your ProyeksiApp installation*

#### SUSE Linux Enterprise Server 12

 - Update the reference to `opf/proyeksiapp-ce` in `/etc/zypp/repos.d/proyeksiapp.repo` to `opf/proyeksiapp`.
 - Update the reference to `stable/8` in `/etc/zypp/repos.d/proyeksiapp.repo` to `stable/9`.
 - Perform the Upgrade steps as mentioned above in *Upgrading your ProyeksiApp installation*

## Upgrade notes for ProyeksiApp 7.x to 8.x

These following points are some known issues around the update to 8.0. It does not contain the entire list of changes. To see all changes, [please browse the release notes](../../../release-notes/8-0-0/).

### Upgrades in NPM may result in package inconsistencies

As has been reported from the community, [there appear to be issues with NPM leftover packages](https://community.proyeksiapp.com/projects/proyeksiapp/work_packages/28571) upgrading to ProyeksiApp 8.0.0. This is due to the packages applying a delta between your installed version and the to-be-installed 8.0. package. In some cases such as SLES12 and Centos 7, the `frontend/node_modules` folder is not fully correctly replaced. This appears to hint at an issue with yum, the package manager behind both.

To ensure the package's node_modules folder matches your local version, we recommend you simply remove `/opt/proyeksiapp/frontend/node_modules` entirely **before** installing the package

```
rm -rf /opt/proyeksiapp/frontend/node_modules
# Continue with the installation steps described below
```

### Migration from Textile to Markdown

ProyeksiApp 8.0. has removed Textile, all previous content is migrated to GFM Markdown using [pandoc](https://pandoc.org). This will happen automatically during the migration run. A recent pandoc version will be downloaded by ProyeksiApp.

For more information, please visit [this separate guide](../../misc/textile-migration).
