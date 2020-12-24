# Introduction

Welcome to the SmartFlow API! 
The SmartFlow API is organized around [REST](http://en.wikipedia.org/wiki/Representational_State_Transfer) and is designed to have predictable, resource-oriented URLs and to use HTTP response codes to indicate API errors. [JSON](http://www.json.org/) will be returned in all responses from the API, including errors.

By using the SmartFlow API the third-party software (hereinafter `EMR`) can create, edit and read patient data, as well as receive different events from the SmartFlow services.

## Environment Setup

> API Sandbox Endpoint:

```shell
https://sandbox.smartflowsheet.com/api/v3
```

> API Production Endpoint:

```shell
https://www.smartflowsheet.com/api/v3
```

To make the SmartFlow API as explorable as possible, we provide test-mode API keys as well as live-mode API keys. The test-mode API keys should be used in our sandbox environment, while live-mode keys should be used in our production environment. 

To retrieve the events from SmartFlow you should register two [webhooks](http://en.wikipedia.org/wiki/Webhook): one for sandbox environment, and another for production. 
SmartFlow then sends an HTTP POST request with the event object to the URLs you provided.

To receive your API keys, please prepare the urls that will be used for the webhooks, and send us a request at [info@smartflowsheet.com](mailto:info@smartflowsheet.com).

Your API keys carry many privileges, so be sure to keep them secret!

You can find the API endpoints for sandbox and production in `Details` section in the right part of this page.

You may also register a custom webhook per each clinic account (see [Register custom webhook](#register-custom-webhook) for more information). 

## Clinic Setup

> Sandbox Home and Settings pages:

```shell
https://sandbox.smartflowsheet.com
https://sandbox.smartflowsheet.com/Settings?page=emr
```

> Production Home and Settings pages:

```shell
https://www.smartflowsheet.com
https://www.smartflowsheet.com/Settings?page=emr
```

Our API is intended for use with a registered clinic account. You can register a clinic account on the `Home` page both in sandbox and production environments.

After a new clinic account has been registered in SmartFlow, there is a clinic API Key automatically generated. This key should be used to authenticate against our API (see [Authentication](#authentication) for more information). It is also used with the Events sent to EMR to identify the account. 

The clinic API key can be obtained by user from `Settings` page on our web-site after registration. We assume that SmartFlow user will be able to register this key in EMR's user interface.

<aside class="notice">
After registering the account with SmartFlow it will be assigned a 14-day trial period. To keep the test clinic account 'alive' in a sandbox environment after the trial period expiration, you can contact us for assistance.  
</aside>

