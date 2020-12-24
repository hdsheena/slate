# Estimates

Estimates created in the PIMS can be sent to SmartFlow, which allows a user to easily add these items to their treatment sheet. The estimate ID, if applicable, will be included with the [`treatment object`](#the-treatment-object) if the item was added from an estimate.

There are the `estimate` and `inventoryItems` objects used to populate the estimate information in SmartFlow. This functionality is dependent on the [`inventory`](#inventory-items) being set up by the user in the SmartFlow UI.

## The estimates object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object. Should be assigned `estimates` value
**id** | String | *Required*. Unique identifier of the estimate group.
**estimates** | Array | The array of [`estimate`](#the-estimate-object) objects. 

## The estimate object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object. Should be assigned `estimate` value
**externalId** | String | *Required*. Unique identifier of the estimate.
**hospitalizationId** | String | **Required**. EMR internal ID of the hospitalization
**description** | String | **Required**. A description of the estimate that will be useful for the user to view when deciding what estimate items to add to that patient's visit.
**createdByName** | String | **Optional**. User who created the estimate.
**dateCreated** | Date | **Required**. Specifies the date and time of the estimate creation. Time format: YYYY-MM-DDThh:mm:ss.sssTZD (e.g. 1997-07-16T19:20:30.000+00:00)
**dateExpires** | Date | **Required**. Specifies the date and time that the estimate expires. Time format: YYYY-MM-DDThh:mm:ss.sssTZD (e.g. 1997-07-16T19:20:30.000+00:00)
**inventoryItems** | Array | The array of [`inventoryItems`](#the-inventoryItems-object) objects. 


The ID of this object will be sent with [`treatments.records_entered`](#retreive-multiple-medical-records) events for you to associate with charges as needed.

## The inventoryItems object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object . Should be assigned `inventoryItems` value
**id** | String | **Required**. The EMR internal ID of the inventory item
**name** | String | **Required**. The name of the inventory item


## Create an estimate

> Example Typical Request:

```http
POST /hospitalization/emr-hospitalization-id/estimate HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```
```json
{
	"objectType": "estimate",
	"hospitalizationId": "emr-hospitalization-id",
	"dateCreated": "2020-8-03T17:54:55.221+00:00",
	"description": "OVH with nail trim and pre-op bloodwork",
	"createdByName": "Dr Jones",
	"dateExpires": "2020-11-03T17:54:55.221+00:00",
	"externalId": "estimate-1234",
	"inventoryItems": [
		{
	        "id": "some-emr-internal-id",
	        "name": "Chem 17",
		},
		{
	        "id": "some-emr-internal-id2",
	        "name": "Nail Trim"
		}
	]
}

```

* Url: /hospitalization/{hospitalizationId}/estimate
* Method: POST
* Synchronous
* Accepts [`estimate`](#the-estimate-object) object
* Returns HTTP status 201 in case the new estimate has been created
* In case of error returns the [`Error`](#the-error-object) object

## Create multiple estimates

> Example Typical Request:

```http
POST /hospitalization/emr-hospitalization-id/estimates HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```
```json
{	"objectType": "estimates",
	"id":"all-todays-estimates-for-fluffy",
	"estimates": [
		{
		"objectType": "estimate",
		"HospitalizationId": "emr-hospitalization-id",
		"dateCreated": "2020-8-03T17:54:55.221+00:00",
		"Description": "OVH with nail trim and pre-op bloodwork",
		"CreatedBy": "Dr Jones",
		"DateExpires": "2020-11-03T17:54:55.221+00:00",
		"ExternalId": "estimate-1234",
		"InventoryItems": [
			{
		        "id": "some-emr-internal-id",
		        "name": "Chem 17",
			},
			{
		        "id": "some-emr-internal-id2",
		        "name": "Nail Trim"
			}
		]
		},
		{
		"objectType": "estimate",
		"HospitalizationId": "emr-hospitalization-id2",
		"dateCreated": "2020-8-03T17:50:55.221+00:00",
		"Description": "Castration with nail trim",
		"CreatedBy": "Dr Jones",
		"DateExpires": "2020-11-03T17:50:55.221+00:00",
		"ExternalId": "estimate-1235",
		"InventoryItems": [
			{
		        "id": "some-emr-internal-id4",
		        "name": "Castration",
			},
			{
		        "id": "some-emr-internal-id2",
		        "name": "Nail Trim"
			}
		]
		}
	]
}
```

* Url: /hospitalization/{hospitalizationId}/estimates
* Method: POST
* Synchronous
* Accepts [`estimates`](#the-estimate-object) object
* Returns HTTP status 201 in case the new estimates have been created
* In case of error returns the [`Error`](#the-error-object) object

## Get estimates associatd with a hospitalization

> Example Request:

```http
GET /hospitalization/emr-hospitalization-id/estimates HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows to get all estimates associated with a hospitalization.  

* Url: /hospitalization/{hospitalizationId}/estimates
* Method: GET
* Synchronous
* Returns HTTP status 200 and a collection of [`estimate`](#the-estimate-object) objects
* In case of error returns the [`Error`](#the-error-object) object

## Update estimate

> Example Typical Request:

```http
PUT /hospitalization/emr-hospitalization-id/estimate HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```
```json
{
	"objectType": "estimate",
	"hospitalizationId": "emr-hospitalization-id",
	"dateCreated": "2020-8-03T17:54:55.221+00:00",
	"description": "OVH with nail trim and pre-op bloodwork",
	"createdByName": "Dr Jones",
	"dateExpires": "2020-11-03T17:54:55.221+00:00",
	"externalId": "estimate-1234",
	"inventoryItems": [
		{
	        "id": "some-emr-internal-id",
	        "name": "Chem 17",
		},
		{
	        "id": "some-emr-internal-id2",
	        "name": "Nail Trim"
		},
		{
	        "id": "some-emr-internal-id3",
	        "name": "CBC (in-house)"
		}
	]
}

```

* Url: /hospitalization/{hospitalizationId}/estimate
* Method: POST
* Synchronous
* Accepts [`estimate`](#the-estimate-object) object
* Returns HTTP status 201 in case the estimate has updated successfully
* In case of error returns the [`Error`](#the-error-object) object


## Delete estimate

> Example Request:

```http
DELETE /hospitalization/emr-hospitalization-id/estimate/estimate-1234 HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method deletes estimates by id. Specify the `estimateId` of the estimate object in the EMR. Use the same `estimateId` that was supplied when estimate had been created. 

* Url: /hospitalization/{hospitalizationId}/estimate/{estimateId}
* Method: DELETE
* Synchronous
* If estimate cannot be found in SmartFlow, returns the [`Error`](#the-error-object) object

<aside class="notice">
You can also use a URL query string to indicate the estimate ID.
DELETE /hospitalization/emr-hospitalization-id/estimate?estimateId=estimate-1234 HTTP/1.1
</aside>


