---
sidebar_navigation:
  title: Nextcloud integration
  priority: 600
description: Nextcloud and ProyeksiApp integration
robots: index, follow
keywords: integrations, apps, Nextcloud
---

# ProyeksiApp and Nextcloud integration 

The ProyeksiApp and Nextcloud integration will improve the productivity of their enterprise users. It combines the strengths of the market leading content collaboration platform Nextcloud and the leading open source project management software ProyeksiApp.

The integration is available starting with Nextcloud 20. It enables users to keep an eye on ongoing project activities directly in their Nextcloud instance.

## Benefits of the integration

The first step of the combined effort is the integration of ProyeksiApp in the Nextcloud dashboard. Users can add an ProyeksiApp widget to display latest changes to project's work packages. With this, it offers users a view of ongoing projects and activities.

## Step by step instructions

The integration is available starting with Nextcloud 20. It enables users to keep an eye on ongoing project activities directly out of their Nextcloud instance.

**Add ProyeksiApp integration app**

To activate your integration to ProyeksiApp in Nextcloud, navigate to the built in app store under your user name in Your apps. You can use the search field in the top right corner to look for the ProyeksiApp integration. Click the button Download and enable.

![Nextcloud_app_store](Nextcloud_app_store.png)

**Activate the ProyeksiApp integration app**

To activate your integration, navigate to your personal settings and choose Connected accounts in the menu on the left.

![Nextcloud_connected_account](Nextcloud_connected_account.png)

Enter the URL of your ProyeksiApp instance and your access token which you can find in ProyeksiApp under My Account and then Access token. Reset the API token and copy/paste it.

![ProyeksiApp_API_key](ProyeksiApp_API_key.png)

![ProyeksiApp_API_key_copy](ProyeksiApp_API_key_copy.png)

**Display of ProyeksiApp in the Nextcloud dashboard**

On the Nextcloud dashboard you can add an ProyeksiApp widget. Display the latest changes to your project's work packages to keep an eye on your ongoing project activities directly from your Nextcloud instance.

![Add_ProyeksiApp_widget](Add_ProyeksiApp_widget.png)

![Nextcloud_dashboard](Nextcloud_dashboard.png)

In your personal settings in Connected accounts, please remember to also activate the Enable navigation link to display a link to your ProyeksiApp instance in the header navigation.

![Nextcloud_connected_account](Nextcloud_connected_account.png)

The link will show here:

![Navigation_link_ProyeksiApp](Navigation_link_ProyeksiApp.png)

By activating "enable unified search for tickets" in your personal settings, the Nextcloud dashboard will include ProyeksiApp information in the the built-in universal search:

![Unified_search](Unified_search.png)

**Set up of OAuth to ProyeksiApp**

Within your Settings under Administration and then Connected Accounts you can set-up the OAuth authentication to your ProyeksiApp instance.

![OAuth](OAuth.png)

In ProyeksiApp, add Nextcloud as application under Administration then Authentication and OAuth and enter the information in your Nextcloud instance.

![ProyeksiApp_OAuth](ProyeksiApp_OAuth.png)

## Where do I find the Nextcloud integration in ProyeksiApp?

Further integration efforts are under way, which will deliver a Nextcloud integration also on the ProyeksiApp side.

## What if project notifications are not displayed?

If the notifications are not displayed in your Nextcloud dashboard, please check the following in your Nextcloud basic settings: in the background jobs, Cron must be activated.

![Cron_job_settings](Cron_job_settings.png)