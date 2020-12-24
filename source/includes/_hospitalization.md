# Hospitalizations

Hospitalization is an abstraction used in SmartFlow to represent the patient record. As soon as patient is admitted in the hospital the Hospitalization object is created. In turn, the hospitalization object nests patient and client information. This information can be transferred and retrieved from SmartFlow using the patient object and the client object.   

There are the `hospitalizations` and `hospitalization` objects used to create hosptitalizations in SmartFlow and receiving events from the SmartFlow services.

## The hospitalizations object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events. Should be assigned `hospitalizations` value
**id** | String | *Optional*. Identificator of the object. Will be transferred to EMR with the SmartFlow events 
**hospitalizations** | Array | The array of [`hospitalization`](#the-hospitalization-object) objects. 


This object will be sent with the `hospitalizations.discharged` event in case when multiple patients were [discharged](#discharge-hospitalization-event) from the SmartFlow whiteboard.

## The hospitalization object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events. Should be assigned `hospitalization` value
**hospitalizationId** | String | **Required**. EMR internal ID of the hospitalization
**departmentIds** | Array | *Optional*. Array of integers. A collection of `departmentIds` of the [`departments`](#the-department-object) patient should be created at. If not specified then hospitalization will be created in the default department
**hospitalizationGuid** | String | *Optional*. A unique internal identifier of the hospitalization. This field will be transferred with the SmartFlow events.
**dateCreated** | Date | **Required**. Specifies the date and time of the patient arrival in the hospital. Time format: YYYY-MM-DDThh:mm:ss.sssTZD (e.g. 1997-07-16T19:20:30.000+00:00)
**treatmentTemplateName** | String | *Optional* The name of the treatment template to be used for created hospitalization. If not specified then the "Default" template will be used.
**temperatureUnits** | String | *Optional*. Units for the temperature. Can be `F` or `C`. If not specified then clinic’s default temperature units will be used
**weightUnits** | String | *Optional*. Units for the weight. Can be `kg` or `lbs`. If not specified then clinic’s default weight units will be used
**weight** | Double | *Optional*. Weight of the patient
**estimatedDaysOfStay** | Integer | *Optional*. This value will be used to create requested number of days of hospitalization. If this value is not specified then by default 2 days will be created
**fileNumber** | String | *Optional*. The value of emr file number, that will be shown on a flowsheet. If not specified SmartFlow will populate it with `hospitalizationId`
**caution** | Boolean | *Optional*. Whether to show `caution stripe` on a flowsheet or not
**deposit** | String | *Optional*. Client deposit
**doctorName** | String | *Optional*. The name of the doctor on duty
**medicId** | String | *Optional*. Alternatively to specifying the `doctorName` field, you can provide the id of the [`medic`](#the-medic-object) object that corresponds to the doctor on duty, and has been registered with the [`appropriate API`](#create-or-update-single-medic) call
**diseases** | Array | *Optional*. Array of strings. A collection of diseases
**cageNumber** | String | *Optional*. The cage number. This value will be shown on the whiteboard near patient name.
**color** | String | *Optional*. The RGB hex color code (eg. #439FE0). This value is used to color patient`s info panel on the whiteboard and flowsheets.
**reportPath** | String | *Optional*. The path to the flowsheet report or the `merged` report file that has been generated during patient discharge. Please read about [Documents Management in Smart Flow](#discharging-patients) for more information
**status** | String | *Optional*. The status of the hospitalization. This field will be transferred with the SmartFlow events. Can be `active`, `deleted` or `discharged`.
**patient** | Patient | *Required when creating new hospitalization. Optional if used to update existing hospitalization*. The [`patient`](#the-patient-object) object
**resuscitate** | String | *Optional* Can be `dnr`, `bls` or `als`. Default value is `bls`.

## The patient object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events. Should be assigned `patient` value
**patientId** | String | **Optional**. EMR internal ID of the patient
**name** | String | **Required**. The name of the patient
**birthday** | Date | *Optional*. Patient`s birthday. Time format: YYYY-MM-DDThh:mm:ss.sssTZD (e.g. 1997-07-16T19:20:30.000+00:00)
**sex** | String | **Required (use "U" for Unknown instead of sending blank)**. Patient's sex type. There is a set of standard predefined strings that specify the sex type of a patient: `M`, `F`, `MN`, `FS`, `U`
**species** | String | *Optional*. Patient's species
**color** | String | *Optional*. Patient's color
**breed** | String | *Optional*. Patient's breed
**criticalNotes** | String | *Optional*. The value of the critical notes that will be shown on a flowsheet.
**customField** | String | *Optional*. The value of the custom field that will be shown on a flowsheet.
**imagePath** | String | *Optional*. The path to the patient`s image file.
**owner** | Client | *Required when creating new hospitalization. Optional if used to update existing hospitalization*. The [`client`](#the-client-object) object

## The client object


### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events. Should be assigned `client` value
**ownerId** | String | **Optional**. EMR internal ID of the client
**nameLast** | String | **Optional**. Pet owner's last name
**nameFirst** | String | *Optional*. Pet owner's first name
**homePhone** | String | *Optional*. Pet owner's home phone
**workPhone** | String | *Optional*. Pet owner's work phone

## Create a patient

> Example Typical Request:

```http
POST /hospitalization HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```
```json
{
	"objectType": "hospitalization",
	"hospitalizationId": "emr-hospitalization-id",
	"dateCreated": "2014-11-03T17:54:55.221+00:00",
	"temperatureUnits": "C",
	"weightUnits": "kg",
	"weight": 5.8,
	"estimatedDaysOfStay": 1,
	"fileNumber": "# 123",
	"caution": false,
	"color": "#439FE0",
	"doctorName": "Dr. Ivan",
	"medicId": "dr-ivan-emr-id",
	"diseases": [
		"high temperature",
		"vomiting"
	],
	"patient": {
		"objectType": "patient",
		"patientId": "emr-patient-id",
		"name": "Jordi Alba",
		"species": "Canin",
		"owner": {
			"objectType": "client",
			"ownerId": "emr-client-id",
			"nameLast": "Dow",
			"nameFirst": "Jack",
			"workPhone": "555-55-55"
		},
		"color": "Brown",
		"sex": "M",
		"criticalNotes": "Cefazolin allergy",
		"customField": "some notes"
	}
}
```
> Example Minimal Request (only including required fields):

```http
POST /hospitalization HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```
```json
	{"hospitalizationId": "emr-hospitalization-id",
"dateCreated": "2014-11-03T17:54:55.221+00:00",
"patient": {
"objectType": "patient",
"sex": "U",
"owner":{
"objectType": "client"
}
}
}
```
* Url: /hospitalization
* Method: POST
* Synchronous
* Accepts [`hospitalization`](#the-hospitalization-object) object
* Returns HTTP status 201 in case the new hospitalization has been created
* In case of error returns the [`Error`](#the-error-object) object

The Smart Slow Sheet API does not allow to create several hospitalizations with the same `hospitalizationId`. However, it may happen that the user needs to re-submit the hospitalization that has been previously created (and then deleted or discharged from SmartFlow user interface). In this case, the second call of this API will return the error with the message `Hospitalization already exists`.  If this happens, we advise to show the user the error message and prompt them if they would like to re-submit the patient. If user selects the option to re-submit the patient, then EMR should:

1. Make a call to [`delete hospitalization`](#delete-hospitalization) API first;
2. Call [create a patient](#create-a-patient) API again to re-submit the patient information.

## Get active hospitalizations

> Example Request:

```http
GET /hospitalizations HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows to get all hospitalizations that have `active` value of the `status` field.  

* Url: /hospitalizations
* Method: GET
* Synchronous
* Returns HTTP status 200 and a collection of [`hospitalization`](#the-hospitalization-object) objects
* In case of error returns the [`Error`](#the-error-object) object

## Get hospitalization

> Example Request:

```http
GET /hospitalization/emr-hospitalization-id HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows to get information about hospitalization by id. Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created. 

* Url: /hospitalization/{hospitalizationId}
* Method: GET
* Synchronous
* Returns HTTP status 200 and the [`hospitalization`](#the-hospitalization-object) object
* If hospitalization cannot be found in SmartFlow, the [`Error`](#the-error-object) object will be returned with HTTP 404 status code


## Attach to existing hospitalization

> Example Request:

```http
POST /hospitalization/sfs-hospitalization-guid/attach/emr-hospitalization-id HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

When a patient is created manually by the user with SmartFlow user interface, the [hospitalization](#the-hospitalization-object) will be sent to EMR with `hospitalizations.created` event. The `hospitalizationId` field of the object will be empty, however, `hospitalizationGuid` field (a unique internal identifier of the hospitalization) will be provided.  You may want to attach your EMR internal ID to this hospitalization to be able to receive any other type of events, as well as download patient reports and use any other API that requires `hospitalizationId`. The HTTP request below provides such possibility. It takes `hospitalizationGuid` value as one part of Url, while your internal `hospializationId` is included in another part of Url.

* Url: /hospitalization/{hospitalizationGuid}/attach/{hospitalizationId}
* Method: POST
* Body: empty
* Synchronous
* Returns HTTP status 200 in case the `hospitalizationId` has been successfully attached to the hospitalization located by `hospitalizationGuid`
* In case of error returns the [`Error`](#the-error-object) object

Upon attachment to the existing hospitalization, Smart Flow will collect all treatments recorded so far for this hospitalization and send them with the `treatments.records_entered` [event](#retreive-multiple-medical-records).

## Delete hospitalization

> Example Request:

```http
DELETE /hospitalization/emr-hospitalization-id HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method deletes hospitalization by id. Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created. 
This method also "unmaps" the `hospitalizationId` from the internal hospitalization record - this allows to submit the patient to SmartFlow again afterward.

* Url: /hospitalization/{hospitalizationId}
* Method: DELETE
* Synchronous
* If hospitalization cannot be found in SmartFlow, the [`Error`](#the-error-object) object will be returned with HTTP 404 status code

## Discharge hospitalization

> Example Request:

```http
POST /hospitalization/discharge/emr-hospitalization-id HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method initiates the patient discharge operation. Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created. This API requires the valid `timezoneName` header specified in the request.

* Url: /hospitalization/discharge/{hospitalizationId}
* Method: POST
* Body: empty
* Asynchronous. In the case of success, the response will include the [hospitalization](#the-hospitalization-object) object with the `status` field equal to `discharged`. At this point, all patient reports are not generated yet - SmartFlow only initiated the document generation process. After the files are generated, and operation is complete, SmartFlow will send the `hospitalization.discharged` event to the EMR.
* In case of error returns the [`Error`](#the-error-object) object

<aside class="notice">
To discharge a patient, it should have the patient name and file number fields specified in SmartFlow user interface. In case, if any of these fields are empty, of if there is a non-finalized anesthetic sheet, then the API will return 400 HTTP code with an appropriate error message that could be shown to the user.
</aside>

## Discharge hospitalization event

> Example of `hospitalizations.discharged` event JSON:

```json
{
    "clinicApiKey": "clinic-api-key",
    "eventType": "hospitalizations.discharged",
    "object": {
	    "objectType": "hospitalizations",
		"id": "sfs-operation-id",
		"hospitalizations": [
			{
				"objectType": "hospitalization",
				"hospitalizationId": "emr-hospitalization-id",
				"hospitalizationGuid": "sfs-hospitalization-guid",
				"dateCreated": "2014-11-05T10:20:19.000+00:00",
				"fileNumber": "#File number",
				"reportPath": "https://pdf-report-webfile-path"
			}
		]
	}
}
```

As soon as one or several patients have been discharged from the SmartFlow whiteboard, SmartFlow will notify EMR by sending one of the following events:

1. The `hospitalization.discharged` event in case if single patient was discharged. In this case the [hospitalization](#the-hospitalization-object) object will be transferred with the event.

2. The `hospitalizations.discharged` event in case if multiple patients were discharged. In this case the [hospitalizations](#the-hospitalizations-object) object will be transferred with the event.

Every `hospitalization` object transferred with these events will contain the path to the flowsheet report pdf file in the `reportPath` field. If for some reason the value of this field is empty then you may explicitly [download the flowsheet report](#download-the-flowsheet-report).

## Get notified about new hospitalizations

> Example of `hospitalizations.created` event JSON:

```json
{
    "clinicApiKey": "clinic-api-key",
    "eventType": "hospitalizations.created",
    "object": {
	    "objectType": "hospitalizations",
		"id": "sfs-operation-id",
		"hospitalizations": [
			{
				"objectType": "hospitalization",
				"hospitalizationGuid": "sfs-hospitalization-guid",
				"dateCreated": "2014-11-05T10:20:19.000+00:00",
				"weight": 5.8,
				"estimatedDaysOfStay": 1,
				"fileNumber": "# 123",
				"caution": false,
				"color": "#439FE0",
				"doctorName": "Dr. Ivan",
				"medicId": "dr-ivan-emr-id",
				"diseases": [
					"high temperature",
					"vomiting"
				],
				"patient": {
					"objectType": "patient",
					"name": "Jordi Alba",
					"species": "Canin",
					"owner": {
						"objectType": "client",
						"nameLast": "Dow",
						"nameFirst": "Jack",
						"workPhone": "555-55-55"
					},
					"color": "Brown",
					"sex": "M",
					"criticalNotes": "Cefazolin allergy",
					"customField": "some notes"
				}
			}
		]
	}
}
```

When hospitalization is created in SmartFlow (both through the user interface and [create patient](#create-a-patient) API) the `hospitalizations.created` event will be sent to EMR. The [hospitalization](#the-hospitalization-object) object will be included in the payload. 

The `hospitalizationId` field would be empty in case if the patient were created manually from SmartFlow user interface. You may want to attach your EMR internal ID to this hospitalization to be able to receive any other type of events, as well as download patient reports and use any other API that requires `hospitalizationId`.

You may find more details about attaching hospitalizations API [here](#attach-to-existing-hospitalization).

## Download the Flowsheet report

> Example Request:

```http
GET /hospitalization/emr-hospitalization-id/flowsheetreport HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows to download the flowsheet report from SmartFlow.

All the dates in the downloaded report will be represented in the time zone that you **must** explicitly specify in the `timezoneName` header of the HTTP request (e.g. `timezoneName: Europe/Helsinki`). Please visit this [web-page](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for the complete list of the time zone names. 

Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created.

* Url: /hospitalization/{hospitalizationId}/flowsheetreport
* Method: GET
* Synchronous
* Returns the pdf report with the output stream. The Content-Type header will contain the `application/pdf` value
* In case of error returns the [`Error`](#the-error-object) object

<aside class="notice">
If the user sets `MERGE REPORTS INTO ONE PDF` setting to YES on a `Settings / Documents Management` page then this API will return the merged pdf file that will include all the documents specified in `Files To Retain After Discharge` section.
</aside>
For more information about merging reports functionality please take a look at [Documents Management in Smart Flow](#discharging-patients) section.

## Download the Medical Records report

> Example Request:

```http
GET /hospitalization/emr-hospitalization-id/medicalrecordsreport HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows to download the medical record report from SmartFlow. Use this method when receiving `hospitalizations.discharged` event, as at this point the report should contain all medical records of the specified hospitalization. 

All the dates in the downloaded report will be represented in the time zone that you **must** explicitly specify in the `timezoneName` header of the HTTP request (e.g. `timezoneName: Europe/Helsinki`). Please visit this [web-page](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for the complete list of the time zone names. 

Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created.

* Url: /hospitalization/{hospitalizationId}/medicalrecordsreport
* Method: GET
* Synchronous
* Returns the pdf report with the output stream. The Content-Type header will contain the `application/pdf` value
* In case of error returns the [`Error`](#the-error-object) object

## Download the Billing report

> Example Request:

```http
GET /hospitalization/emr-hospitalization-id/billingreport HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: America/Chicago
```

This method allows to download the billing report from SmartFlow. Use this method when receiving `hospitalizations.discharged` event, as at this point the report should contain the complete inventory usage information of the specified hospitalization. 

All the dates in the downloaded report will be represented in the time zone that you **must** explicitly specify in the `timezoneName` header of the HTTP request (e.g. `timezoneName: America/Chicago`). Please visit this [web-page](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for the complete list of the time zone names. 

Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created.

* Url: /hospitalization/{hospitalizationId}/billingreport
* Method: GET
* Synchronous
* Returns the pdf report with the output stream. The Content-Type header will contain the `application/pdf` value
* In case of error returns the [`Error`](#the-error-object) object


## Download the Notes report

> Example Request:

```http
GET /hospitalization/emr-hospitalization-id/notesreport HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows to download the notes report from SmartFlow. Use this method when receiving `hospitalizations.discharged` event, as at this point the report should contain all the tech notes of the specified hospitalization. 

All the dates in the downloaded report will be represented in the time zone that you **must** explicitly specify in the `timezoneName` header of the HTTP request (e.g. `timezoneName: Europe/Helsinki`). Please visit this [web-page](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for the complete list of the time zone names. 

Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created.

* Url: /hospitalization/{hospitalizationId}/notesreport
* Method: GET
* Synchronous
* Returns the pdf report with the output stream. The Content-Type header will contain the `application/pdf` value
* In case of error returns the [`Error`](#the-error-object) object
