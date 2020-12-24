# Errors

> HTTP Status Code Summary

```shell
200 OK - Everything worked as expected.

204 No Content - May happen when trying to access the patient report that was not generated for the patient.

400 Bad Request - Often missing a required parameter.

401 Unauthorized - No valid emrApiKey or clinicApiKey provided.

402 Payment Required - If reached clinic`s patient limit. This may happen when trying to create a new patient, but clinic`s subscription expired.

403 Forbidden - If trying to update clinic with different clinicApiKey.

404 Not Found - The requested item doesn`t exist.

409 Conflict - If the request with the same “id“ (e.g. “inventoryitems.id“) has been already received and is currenly under processing. Normally means that second request is not needed.

429 Too Many Requests - May happen when trying to upload a lot of inventory items. Need to slown down. 

465 Access to the Document Denied - Heppens when manager turns off the document on the `Settings / Documents Management` page.

500, 502, 503, 504 Server errors - something went wrong on SmartFlow`s end.
```

SmartFlow uses conventional HTTP response codes to indicate success or failure of an API request. In general, codes in the 2xx range indicate success, codes in the 4xx range indicate an error that resulted from the provided information (e.g. a required parameter was missing), and codes in the 5xx range indicate an error with SmartFlow's servers.

Not all errors map cleanly onto HTTP response codes, however. Please refer to the documentation on a particular API method for the details on possible HTTP codes and responses.

## The Error object

```http
GET /inventoryitem HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
```
```http
HTTP/1.1 404 Not Found
Accept: application/json

{
   "Message" : "Inventory item not found"
}
```

SmartFlow may send the Error object in the response to the API methods that failed with the [4xx HTTP status codes](#errors). 

Also, SFS expects EMR to send the Error object (optionally) in the response to the event calls that fail together with the 4xx HTTP status codes. 

### Attributes


Parameter | Type | Description
---------- | ------- | -------
Message | String | The message describing the cause of fail 
