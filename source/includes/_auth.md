# Authentication

```http
GET /inventoryitems HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

You authenticate to the SmartFlow API by providing both EMR API key and clinic API key in all API requests to the server in a header. 

`emrApiKey: emr-api-key-received-from-sfs`

`clinicApiKey: clinic-api-key-taken-from-account-web-page`

You must replace `emr-api-key-received-from-sfs` with your personal **emr API key** and `clinic-api-key-taken-from-account-web-page` with the **clinic API key** taken from the [Settings](#clinic-setup) web-page.

All API requests must be made over HTTPS. Calls made over plain HTTP will fail. You must authenticate for all requests.

We also recommend providing the time zone name with the `timezoneName` header of the HTTP request (e.g. timezoneName: Europe/Helsinki). Please visit this [web-page](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for the complete list of the time zone names.



