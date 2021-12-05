---
sidebar_navigation:
  title: Development
  priority: 920
robots: index, follow
---

# Develop ProyeksiApp

We are pleased that you are thinking about contributing to ProyeksiApp! This guide details how to contribute to ProyeksiApp.

## Get in touch

Please get in touch with us using our [development forum](https://community.proyeksiapp.com/projects/proyeksiapp/forums/7) or send us an email to info@proyeksi.id.



## Issue tracking and coordination

We eat our own ice cream so we use ProyeksiApp for roadmap planning and team collaboration. Please have a look at the following pages:

- [Development roadmap](https://community.proyeksiapp.com/projects/proyeksiapp/work_packages?query_id=1993)

- [Wish list](https://community.proyeksiapp.com/versions/26)

- [Bug backlog](https://community.proyeksiapp.com/projects/proyeksiapp/work_packages?query_id=491)

- [Reporting a bug](report-a-bug)

- [Submit a feature idea](submit-feature-idea)

  

## Development Environment

Take a look at the bottom under Additional resources to see how to setup your development environment.



## Branching model and development flow

Please see this separate guide for the [git branching model and core development](git-workflow).



## Development concepts

We prepared a set of documentation concepts for an introduction into various backend and frontend related topics of ProyeksiApp. Please see the [concepts main page](concepts/) for more.



## Translations

If you want to contribute to the localization of ProyeksiApp and its plugins you can do so on the [Crowdin ProyeksiApp page](https://crowdin.com/project/proyeksiapp). Once a day we fetch those locales and automatically them to GitHub. Contributing there will ensure your language will be up to date for the next release!

More on this topic can be found in our [blog post](https://www.proyeksi.id/blog/help-translate-proyeksiapp-into-your-language/).

## Testing

Please add tests to your code to verify functionality, especially if it is a new feature.

Pull requests will be verified by TravisCI as well, but please run them locally as well and make sure they are green before creating your pull request. We have a lot of pull requests coming in and it takes some time to run the complete suite for each one.

If you push to your branch in quick succession, please consider stopping the associated Travis builds, as Travis will run for each commit. This is especially true if you force push to the branch.

Please also use `[ci skip]` in your commit message to suppress builds which are not necessary (e.g. after fixing a typo in the `README`).

## Inactive pull requests

We want to keep the Pull request list as cleaned up as possible - we will aim close pull requests after an **inactivity period of 30 days** (no comments, no further pushes) which are not labeled as `work in progress` by us.

## Security

If you notice a security issue in ProyeksiApp, please send us a GPG encrypted email to security@proyeksiapp.com and describe the issue you found. Download our public GPG key BDCF E01E DE84 EA19 9AE1 72CE 7D66 9C6D 4753 3958 [here](https://keys.openpgp.org/vks/v1/by-fingerprint/BDCFE01EDE84EA199AE172CE7D669C6D47533958).

Please include a description on how to reproduce the issue if possible. Our security team will get your email and will attempt to reproduce and fix the issue as soon as possible.

## Contributor code of conduct

As contributors and maintainers of this project, we pledge to respect all people who contribute through reporting issues, posting feature requests, updating documentation, submitting pull requests or patches, and other activities.

We are committed to making participation in this project a harassment-free experience for everyone, regardless of level of experience, gender, gender identity and expression, sexual orientation, disability, personal appearance, body size, race, age, or religion.

Examples of unacceptable behavior by participants include the use of sexual language or imagery, derogatory comments or personal attacks, trolling, public or private harassment, insults, or other unprofessional conduct.

Project maintainers have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned to this Code of Conduct. Project maintainers who do not follow the Code of Conduct may be removed from the project team.

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by opening an issue or contacting one or more of the project maintainers.

This code of conduct is adapted from the [Contributor Covenant](https://www.contributor-covenant.org/), version 1.0.0, available at http://contributor-covenant.org/version/1/0/0/



## ProyeksiApp Contributor License Agreement (CLA)

If you want to contribute to ProyeksiApp, please make sure to accept our Contributor License Agreement first. The contributor license agreement documents the rights granted by contributors to ProyeksiApp.

[Read and accept the Contributor License Agreement here.](https://www.proyeksi.id/contributor-license-agreement/)

# Additional resources


* [Development environment for Ubuntu 18.04](development-environment-ubuntu)
* [Development environment for Mac OS X](development-environment-osx)
* [Development environment using docker](development-environment-docker)

* [Developing Plugins](create-proyeksiapp-plugin)
* [Running Tests](running-tests)
* [API Documentation](../api)
* [Report a Bug](report-a-bug)
