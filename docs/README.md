---
sidebar_navigation:
  title: ProyeksiApp Documentation
  priority: 999
description: Help and documentation for ProyeksiApp Community Edition, Enterprise on-premises and Enterprise cloud.
robots: index, follow
keywords: help, documentation
---
# ProyeksiApp Documentation

<div class="alert alert-info" role="alert">
**Note**: To better read our ProyeksiApp Documentation, please go to [www.proyeksi.id/docs/](https://www.proyeksi.id/docs/).
</div>

ToDo: check all links.

## Installation

Get started with installing and upgrading ProyeksiApp using [our Installation Guide starting point](https://www.proyeksi.id/docs/installation-and-operations/).

The guides for [manual](./installation-and-operations/installation/manual), [packaged](./installation-and-operations/installation/packaged) and [Docker-based](./installation-and-operations/installation/docker) installations are provided.

## Upgrading

The detailed upgrade instructions for our packaged installer are located on the [official website](https://www.proyeksi.id/download/upgrade-guides/).

The guides for [upgrading](./installation-and-operations/operation/upgrading) are provided.

## Operation

* [Backing up you installation](./installation-and-operations/operation/backing-up)
* [Alter configuration of ProyeksiApp](./installation-and-operations/configuration)
* [Manual repository integration for Git and Subversion](./installation-and-operations/configuration/repositories)
* [Configure incoming mails](./installation-and-operations/configuration/incoming-emails)
* [Install custom plugins](./installation-and-operations/configuration/plugins)


## User Guides

Please see our [User Guide pages](https://www.proyeksi.id/docs/user-guide/) for detailed documentation on the functionality of ProyeksiApp.


## Development

* [Full development environment for developers on Ubuntu](./development/development-environment-ubuntu) and [Mac OS X](./development/development-environment-osx)
* [Developing plugins](./development/create-proyeksiapp-plugin)
* [Developing OmniAuth Plugins](./development/create-omniauth-plugin)
* [Running tests](./development/running-tests)
* [Code review guidelines](./development/code-review-guidelines)
* [API documentation](./api)


## APIv3 documentation sources

The documentation for APIv3 is written in the [API Blueprint Format](http://apiblueprint.org/) and its sources are being built from the entry point `apiv3-documentation.apib`.

You can use [aglio](https://github.com/danielgtaylor/aglio) to generate HTML documentation, e.g. using the following command:

```bash
aglio -i apiv3-documentation.apib -o api.html
```

The output of the API documentation at `dev` branch is continuously built and pushed to Github Pages at [opf.github.io/apiv3-doc/](opf.github.io/apiv3-doc/).
