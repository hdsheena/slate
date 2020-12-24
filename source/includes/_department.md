# Departments

This API allows to get the list of departments in the clinic. You may want to use this API to allow users to select a department before submitting a new patient into SmartFlow. 

## The department object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events. Should be assigned `department` value
**departmentId** | Integer | **Required**. The ID of the department. You should use this value to specify the department when creating a new [hospitalization](#the-hospitalization-object)
**name** | String | **Required**. The unique name of department

<aside class="warning">
You may want to use this APIs right before creating a new hospitalization. Do not store departments in your database because they may change quite frequently.
</aside>

## Retreive existing departments

> Example Request:

```http
GET /departments HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
```
```json
[
{
     "objectType":"department",
     "name":"Treatment Room",
     "departmentId":0
},
{
     "objectType":"department",
     "name":"Internal Medicine",
     "departmentId":1
}
]
```

* Url: /departments
* Method: GET
* Synchronous 
* Returns HTTP status 200 and a collection of all [`department`](#the-department-object) objects 
* In case of error returns the [`Error`](#the-error-object) object


