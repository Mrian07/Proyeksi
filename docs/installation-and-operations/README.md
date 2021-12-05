---
sidebar_navigation:
  title: Installation & Upgrade Guide
  priority: 940
robots: index, follow
---

# Installation & operations guide

This page summarizes the options for getting ProyeksiApp, some hosted and some on-premise. With this information you should be able to decide what option is best for you. Find a full feature comparison [here](https://www.proyeksi.id/pricing/#compare).

### On-premises

* **Community edition** - The free, no license, edition of ProyeksiApp that you install on-premise. The additional features of the Enterprise edition are not included. See the "Installation" row of the table below.
* **Enterprise on-premise edition** - Builds on top of the Community edition: additional features, professional support, hosted on-premise with optional installation support. See more [on the website](https://www.proyeksi.id/enterprise-edition/), where you can apply for a free trial, or in the [documentation](../enterprise-guide/enterprise-on-premises-guide/).

### Hosted

* **Enterprise cloud edition** - Hosted by ProyeksiApp in an EU Data Center, with premium features and professional support . See more on the [website](https://www.proyeksi.id/hosting/), where you can apply for a free trial, or in the [documentation](../enterprise-guide/enterprise-cloud-guide/).

* **Univention App Center** - Download the free Community edition as a pre-installed virtual environment and upgrade to the Enterprise edition with premium features and support. See the [documentation](installation/univention/) for details.



All editions can be enhanced by adding **[the BIM module](https://www.proyeksi.id/bim-project-management/)**, including features for construction project management, i.e. 3D model viewer, BCF management. See how to [switch to that edition](changing-to-bim-edition) in the documentation or how to start a [BIM cloud edition](https://start.proyeksiapp.com/go/bim).

Compare the features of these versions [on the website](https://www.proyeksi.id/pricing/#compare). The Community edition can easily be upgraded to the Enterprise edition.

* **Development** - ProyeksiApp is open source; if you want to help with the code, check the [development instructions](../development/) and install a [development environment.](../development/#additional-resources)

<div class="alert alert-info" role="alert">
**Note**: there are some minor options given in the "Other" row of the table below. These are not recommended but you may wish to try them.
</div>

## On-premises installation overview

| Main Topics | Content |
| ----------- | :---------- |
| [System requirements](system-requirements) | Learn the minimum configuration required to run ProyeksiApp |
| [Installation](installation/) | How to install ProyeksiApp and the methods available |
| [Operations & Maintenance](operation/) | Guides on how to configure, backup, **upgrade**, and monitor your ProyeksiApp installation |
| [Advanced configuration](configuration/) | Guides on how to perform advanced configuration of your ProyeksiApp installation |
| [Other](misc/) | Guides on infrequent operations such as MySQL to PostgreSQL migration |

For production environments and when using a [supported distribution](system-requirements), we recommend using the [packaged installation](installation/packaged/). This will install ProyeksiApp as a system dependency using your distribution's package manager, and provide updates in the same fashion that all other system packages do.

A [manual installation](installation/manual) option is also documented, but due to the large number of components involved and the rapid evolution of ProyeksiApp, we cannot ensure that the procedure is either up-to-date or that it will correctly work on your machine. This means that manual installation is NOT recommended.

