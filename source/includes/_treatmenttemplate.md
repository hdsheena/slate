# Treatment Templates

This API allows to get the list of active treatment templates in the clinic. You may want to use this API to allow users to select a treatment template before submitting a new patient into SmartFlow. 

## The treatment template object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events. Should be assigned `treatmenttemplate` value
**name** | String | **Required**. The unique name of treatment template. You should use this value to specify the treatment template when creating a new [hospitalization](#the-hospitalization-object)

<aside class="warning">
You may want to use this APIs right before creating a new hospitalization. Do not store treatment templates in your database because they may change quite frequently.
</aside>

## Retreive active treatment templates

> Example Request:

```http
GET /treatmenttemplates HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
```
```json
[
{
     "objectType":"treatmenttemplate",
     "name":"FLUTD"
},
{
     "objectType":"treatmenttemplate",
     "name":"Seizure"
}
]
```

* Url: /treatmenttemplates
* Method: GET
* Synchronous 
* Returns HTTP status 200 and a collection of all [`treatment template`](#the-treatment-template-object) objects 
* In case of error returns the [`Error`](#the-error-object) object


