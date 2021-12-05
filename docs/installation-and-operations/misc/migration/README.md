# Migrating your packaged ProyeksiApp installation to another environment

**Note:** this guide only applies if you've installed ProyeksiApp using our DEB/RPM packages.

Migrating your ProyeksiApp packaged installation to another host or environment is trivial and may be combined with, e.g., minor or major package upgrades due to our migration system.

## Backing up

To create a dump of all your data in the old installation, please follow our [backup and restore guides](../../operation) for our packaged installation.

This guide should leave you with a set of archives that you should manually move to your new environment:

- **Database**: postgresql-dump\<timestamp>.pgdump
- **Attachments**: attachments-\<timestamp>.tar.gz
- **Custom env configuration**: conf-\<timestamp>.tar.gz
- **Repositories**: svn- and git-\<timestamp>.tar.gz

## Migration

The following steps outline the migration process to the ProyeksiApp package (possibly, a newer version).

## Stop ProyeksiApp on old server

To stop the servers from being accessed on the old installation, stop the service with `service proyeksiapp stop` or `systemctl stop proyeksiapp` depending on your distribution.

## Install new package

Follow the first step (**Installation**) of our packaged installation guides at https://www.proyeksi.id/download-and-installation/.

After this step, you should have an installed version of `proyeksiapp`.

### Moving Configuration

On your old host, the configuration of the package resides in `/etc/proyeksiapp`.

This folder is split into two relevant files:

**The installer.dat file**
The `/etc/proyeksiapp/installer.dat` is the result of your input in the installation wizard (`proyeksiapp configure`). It contains all configuration options that the wizard generates, such as database URL, storage paths, hostname et cetera.

If most of your environment is the same (e..g, new server under the same domain), you will want to copy the entire configuration folder `/etc/proyeksiapp`. This will cause `proyeksiapp configure` to take all values from your previous installation.

You can simply look through the installer.dat and change those values you need.

**The conf.d folder**

Additional environment, either generated from the wizard or entered by you through `proyeksiapp config:set` is written to  `/etc/proyeksiapp/conf.d/{server,database,other}`. Also look through those and check which contain relevant values for your new installation. 

### PostgreSQL database

On your new host or cluster, ensure you have created a database user and database, ideally using the same names as the old environment (You may want to choose a different random password, however).

In the following, the values `<dbuser>`, `<dbhost>` and `<dbname>` variables have to be replaced with your database user and database above.
To read the values from the old installation, you can execute the following command:

```bash
proyeksiapp config:get DATABASE_URL
#=> e.g.: postgres://dbusername:dbpassword@dbhost:dbport/dbname
```

First the dump has to be extracted (unzipped) and then restored. The command used should look very similar to the following. The `--clean` option is used to drop any database object within `<dbname>` so ensure this is the correct database you want to restore, as you will lose all data within it!

```
# Restore the PostgreSQL dump
pg_restore -h <dbhost> -u <dbuser> -W <dbname> --clean postgresql-dump-20180408095521.pgdump
```


### Attachments

Your storage path can be shown on the old installation can be shown using the following command:

```
proyeksiapp config:get ATTACHMENTS_STORAGE_PATH
#=> e.g., /var/db/proyeksiapp/files
```

Simply extract your attachments dump into that folder with `tar -vxfz <dump>.tar.gz`, creating it beforehand if needed.



### Repositories

For repositories, the same approach applies as for the attachments:

Your SVN and Git storage paths can be shown on the old installation can be shown using the following command:

```
# Subversion
proyeksiapp config:get SVN_REPOSITORIES
#=> e.g., /var/db/proyeksiapp/svn

# Git
proyeksiapp config:get GIT_REPOSITORIES
#=> e.g., /var/db/proyeksiapp/git
```

Simply extract your respective repository dumps into ech folder, creating it beforehand if needed. The dumps will only be created if you use that feature in your old installation.



## Running proyeksiapp configure

After you restored all data and updated your installer.dat, all you need to do is run through the configuration process of the packaged installation:

```bash
proyeksiapp configure
```

It will take all values from your previous installation. *It may ask you additional wizard questions*  for new features that did not exist on the old installations, or the ones you removed/left empty in the `installer.dat` file.

This step will also perform database migrations, install and configure all necessary dependencies and start the server.
