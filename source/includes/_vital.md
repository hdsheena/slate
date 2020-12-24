# Vitals

There are the `vitaltypes` and `vitaltype` objects used to tell SmartFlow what vital signs you have in the EMR.

## The vitaltypes object

> Example `vitaltypes` object with 2 nested `vitaltype` objects:

```json
{
	"objectType": "vitaltypes",
    "id": "some-operation-id",
    "vitaltypes": [
		{
			"dataType": "text",
			"objectType": "vitaltype",
			"id": "vtype_3",
			"name": "CRT (Text)"
		},
		{
			"dataType": "list",
			"options": [
				{
					"id": "vtype_4_opt1",
					"name": "RR Option 1"
				},
				{
					"id": "vtype_4_opt2",
					"name": "RR Option 2"
				}
			],
			"objectType": "vitaltype",
			"id": "vtype_4",
			"name": "Resp Rate (List)",
			"units": []
		}
	]
}
```

This object should be sent with the `/vitaltypes` API method (POST or PUT method).

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events (e.g. `inventory.imported`). Should be assigned `vitaltypes` value
**id** | String | *Optional*. Identificator of the object. Will be transferred to EMR with the SmartFlow events (e.g. `inventory.imported`)
**vitaltypes** | Array | The array of `vitaltype` objects. See description of the `vitaltype` object [below](#the-vitaltype-object)


## The vitaltype object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events (e.g. `inventory.imported`). Should be assigned `vitaltype` value
**id** | String | **Required**. The EMR internal ID of the vital
**name** | String | **Required**. The unique name of the vital
**dataType** | String | **Required**. The type of data the user should enter. (one of "list","text","numeric")
**options** | Array | *Optional*. If the dataType is `list`, the list of options to display.
**units** | Array | *Optional* Units that the user can select if this vital might have multiple ways of recording it (ie: kg, lb)

Both the units and options arrays should include a dictionary with keys "id" and "name" for each item.

## The vitals object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events (e.g. `inventory.imported`). Should be assigned `vitals` value
**vitalTypeId** | String | The EMR internal ID of the vital
**name** | String | The unique name of the vital
**hospitalizationId** | String | The external ID of the hospitalization.
**vitalGuid** | String | A generated unique identifier for the vital, created by SmartFlow.
**time** | Date | Time vital was recorded. Time format: YYYY-MM-DDThh:mm:ss.sssTZD (e.g. 1997-07-16T19:20:30.000+00:00)
**vitalGuid** | String | A generated unique identifier for the vital, created by SmartFlow.
**status** | String | This field describes what have happened to the note. Can be one of the following: 1. added, 2. changed, 3. removed
**value** | String | The value entered by the user for this vital.
**source** | String | The source of the vital entry, should be one of following types: 0 - Flowsheet vital, 1 - Anesthetic vital
**doctorName** | String | The name of the doctor on duty. This value will be provided only in case if the name of the doctor is specified on a correspondent flowsheet
**doctor** | Medic | The medic object that corresponds to the doctor on duty. This value will be provided only in case if associated medic has been imported from EMR
**unit** | Object | *Optional*. Dictionary specifying the unit `id` and `name` for the vital entered.


## Create or update single vital

> Example Request:

```http
POST /vitaltype HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-SmartFlow"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
```
```json
{
    "dataType": "numeric",
    "min": null,
    "max": 120,
    "objectType": "vitaltype",
    "id": "vtype_5",
    "name": "Weight",
    "units": [
        {
            "id": "uid1",
            "name": "kg"
        },
        {
            "id": "uid2",
            "name": "lbs"
        }
    ]
}

```

Creates or updates single vital sent in the request. 

* Url: /vitaltype
* Method: POST
* Synchronous
* Accepts [`vitaltype`](#the-vitaltype-object) object
* Returns HTTP status 200 in case the new item has been created or an existing item has been updated
* In case of error returns the [`Error`](#the-error-object) object

## Create or update multiple vitals

> Example Request:

```http
POST /vitaltypes HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-SmartFlow"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
```
```json
{
	"id": "idd",
	"objectType": "vitaltypes",
	"vitaltypes": [
		{
			"dataType": "text",
			"objectType": "vitaltype",
			"id": "vtype_3",
			"name": "CRT (Text)"
		},
		{
			"dataType": "list",
			"options": [
				{
					"id": "vtype_4_opt1",
					"name": "RR Option 1"
				},
				{
					"id": "vtype_4_opt2",
					"name": "RR Option 2"
				}
			],
			"objectType": "vitaltype",
			"id": "vtype_4",
			"name": "Resp Rate (List)",
			"units": []
		}
	]
}

```

Asynchronously creates or updates the vitals sent with the request.

* Url: /vitaltypes
* Method: POST 
* Asynchronous
* Accepts [`vitaltypes`](#the-vitaltypes-object) object.
* Returns HTTP status 200 in case the input data has been accepted for import
* In case of error returns the [`Error`](#the-error-object) object

After an import operation finishes SmartFlow will send the `vitaltypes.imported` [event](#receiving-the-status-of-import-operation) to the registered webhook. We will pass back the same `vitaltypes` object to EMR, and fill in the status of the import operation for every vital provided.

<aside class="warning">
This is the asynchronous method. Please expect to receive and handle the `vitaltypes.imported` event that SmartFlow will send to you after the import is complete. 
</aside>

<aside class="notice">
Because of asynchronous nature of this API method, we recommend to pass the unique operation identifier with the `id` field of the `vitaltypes` object. We will send this object back to you with the `vitaltypes.imported` event, and you will be able to distinguish the operation. 
</aside>

## Receiving the entered vitals for a patient

> Example of `vitals.records_entered` event JSON:

```json
{
	"clinicApiKey": "clinic-api-key",
	"eventType": "vitals.records_entered",
	"object": {
		"objectType": "vitals",
		"vitals": [
			{
				"objectType": "vital",
				"vitalTypeId": "vtype_3_5",
				"name": "Weight-V",
				"hospitalizationId": "ExtId",
				"vitalGuid": "GuidString",
				"time": "2018-10-26T23:00:00.000+03:00",
				"status": "added",
				"value": "7.1",
				"source": 0,
				"doctorName": "Doctor",
				"doctor": null,
				"unit": {
					"id": "viUnit3-1",
					"name": "kg"
				},
				"asyncOperationStatus": null,
				"asyncOperationMessage": null
			}
		],
		"id": "idOfVitalRecord"
	}
}

```

SmartFlow will send the `vitals.records_entered` event to the url provided by EMR each time a treatment is completed on a hospitalization, where that treatment is mapped to a Vital by the SmartFlow user. SmartFlow sends the `vitals` object with this event. The EMR should use the `vitalTypeId` and `value`, taking note of the `status`, `unit`, `time` and `hospitalizationId` to correctly action on this data.

* Url: webhook provided by EMR
* Method: POST
* Synchronous
* Transfers [`vitals`](#the-vitals-object) object included in the `event` object
* Expected response with 200 Http code in case of success.
* In case of the error, EMR should return 400 Http code and optionally the [`Error`](#the-error-object) object



## Retreive existing vitals

If you need to check what vitals are in SmartFlow already, you can get a list with this call. Returns a list of all vitals.

* Url: /vitaltypes
* Method: GET
* Synchronous 
* Returns HTTP status 200 and a collection of all [`vitaltype`](#the-vitaltype-object) objects linked with EMR
* In case of error returns the [`Error`](#the-error-object) object

## Retreive single vital 

If you need to check one specific vital is in SmartFlow already, you can do that with this call. Returns the specified vital. Specify the `id` of the vital in the EMR, the same `id` that was supplied when object was created.

* Url: /vitaltype/{id}
* Method: GET
* Synchronous 
* Returns HTTP status 200 and an [`vitaltype`](#the-vitaltype-object) object linked with EMR
* In case of error returns the [`Error`](#the-error-object) object

## Delete single vital

This method deletes an vital by id.

* Url: /vitaltype/{id}
* Method: DELETE
* Synchronous
* Returns HTTP status 204

## Delete multiple vitals
This method deletes multiple vitals by id. Pass IDs as URL query parameters

* Url: /api/v3/vitaltypes?vitalTypeId={id}&vitalTypeId={id}&…
* Method: DELETE
* Returns HTTP status 204
* Note that items which cannot be found will be ignored




## Receiving the status of import operation

> Example of `vitaltypes.imported` event JSON:

```json
{
    "clinicApiKey": "clinic-api-key",
    "eventType": "vitaltypes.imported",
    "object": {
	    "objectType": "vitaltypes",
		"id": "some-emr-internal-id",
		"vitaltypes": [
		    {
		        "dataType": "list",
		        "options": [
		            {
		                "id": "vtype_4_opt1",
		                "name": "RR Option 1"
		            },
		            {
		                "id": "vtype_4_opt2",
		                "name": "RR Option 2"
		            }
		        ],
		        "objectType": "vitaltype",
		        "id": "vtype_4",
		        "name": "Resp Rate (List)",
		        "units": [],
		        "asyncOperationStatus": null,
		        "asyncOperationMessage": null
		    }
		]
	}
}
```

SmartFlow will send the `vitaltypes.imported` event to the url provided by EMR at the end of [asynchronous import](#create-or-update-multiple-vitals) operation. SmartFlow sends the `vitaltypes` object with this event. Every `vitaltype` object will contain `asyncOperationStatus` and optionally `asyncOperationMessage` in case of errors.

* Url: webhook provided by EMR
* Method: POST
* Synchronous
* Transfers [`vitaltypes`](#the-vitaltypes-object) object included in the `event` object
* Expected response with 200 Http code in case of success.
* In case of the error, EMR should return 400 Http code and optionally the [`Error`](#the-error-object) object
