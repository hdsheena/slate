

# Dental Charts

Dental Chart is an abstraction used in SmartFlow to represent the Dental Chart data. The main purpose of this abstraction is to provide the possibility to download dental chart report when it is finalized or after the patient discharge event. 

## The dentalcharts object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object returned with the SmartFlow API. Equals to `dentalcharts`
**id** | String | **Required**. Identificator of the object. 
**dentalcharts** | Array | The array of `dentalchart` objects. See description of the `dentalchart` object [below](#the-dentalchart-object)


## The dentalchart object

> Example of dentalchart object:

```json
{
  
    "objectType": "dentalchart",
    "hospitalizationId": "emr-hospitalization-id",
    "dentalChartGuid": "sfs-dental-guid",
    "dateFinalized": "2019-11-04T17:23:07.707+00:00",
    "reportPath": "https://pdf-dental-chart-report-webfile-path",
    "media": [ 
    	{
    		"dentalChartMediaGuid": "sfs-dental-guid",
			"section": "before",
			"dateCreated": "2020-03-13T16:21:19.193+00:00",
			"filePath": "https://pdf-dental-chart-photo-1-webfile-path",
			"contentType": "image/jpg"
		}
    ],
}
```

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | Describes the type of the object transferred with the SmartFlow API. Equals to `dentalchart`
**hospitalizationId** | String | EMR internal ID of the hospitalization
**dentalChartGuid** | String | A unique internal identifier of the  chart. This field will be transferred with the SmartFlow events.
**dateFinalized** | Date | Dental chart finalization time. Time format: YYYY-MM-DDThh:mm:ss.sssTZD (e.g. 1997-07-16T19:20:30.000+00:00)
**reportPath** | String | The path to the dental chart report file that has been generated during finalization of the dental chart.
**media** | Array | *Optional*. The array of [`dental-media`](#the-dental-media-object) objects that correspond to the photos taken by the user on the dental chart.


## The dental media object

> Example of dental media object:

```json
{
	"dentalChartMediaGuid": "sfs-dental-guid",
	"section": "before",
	"dateCreated": "2020-03-13T16:21:19.193+00:00",
	"filePath": "https://pdf-dental-chart-photo-1-webfile-path",
	"contentType": "image/jpg"
}
```


### Attributes

Parameter | Type | Description
---------- | ------- | -------
**dentalChartMediaGuid** | String | Describes the type of the object transferred with the SmartFlow API. Equals to `dentalchart`
**section** | String | "before" or "after", denoting the section where the user took the photo. This indicates whether the photo was taken before or after the dental procedures were performed.
**dateFinalized** | Date | Time photo was taken. Time format: YYYY-MM-DDThh:mm:ss.sssTZD (e.g. 1997-07-16T19:20:30.000+00:00)
**filePath** | String | The path to the dental media file (photo) that has been taken by the user.
**contentType** | string | The content type of media file (e.g. `image/jpg`, `video/mp4`, etc...). For Dental, this is currently limited to `image/jpg`

## Finalize Dentalchart event

> Example of `dentalcharts.finalized` event JSON:

```json
{
    "clinicApiKey": "clinic-api-key",
    "eventType": "dentalcharts.finalized",
    "object": {
	    "objectType": "dentalcharts",
		"id": "sfs-operation-id",
		"dentalcharts": [
			{
		        "objectType": "dentalchart",
		        "hospitalizationId": "emr-hospitalization-id",
		        "dentalChartGuid": "sfs-dental-guid",
		        "dateFinalized": "2019-11-04T17:23:07.707+00:00",
		        "reportPath": "https://pdf-dental-chart-report-webfile-path",
		        "media": [ 
		        	{
		        		"dentalChartMediaGuid": "sfs-dental-guid",
						"section": "before",
						"dateCreated": "2020-03-13T16:21:19.193+00:00",
						"filePath": "https://pdf-dental-chart-photo-1-webfile-path",
						"contentType": "image/jpg"
					}
		        ],
			}
		]
	}
}
```

As soon as a dental chart has been finalized in the SmartFlow app on an iPad, SmartFlow will notify the EMR by sending a `dentalcharts.finalized` event. The [dentalcharts](#the-dentalcharts-object) object will be transferred with the event.

* Url: webhook provided by EMR
* Method: POST
* Asynchronous 
* Transfers [`dentalcharts`](#the-dentalcharts-object) object included in the `event` object
* Expected response with 200 Http code in case of success.
* In case of the error, EMR should return 400 Http code and optionally the [`Error`](#the-error-object) object

## Retreive dental chart and associated media

> Example Request:

```http
GET /hospitalization/{hospitalizationId}/dentalcharts HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
```

This method allows to download all dental chart reports and associated media related to some hospitalization from SmartFlow.

Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created.

* Url: /hospitalization/{hospitalizationId}/dentalcharts
* Method: GET
* Synchronous 
* Returns the [`dentalcharts`](#the-dentalcharts-object) object.
* Expected response with 200 Http code in case of success.
* In case of the error, the [`Error`](#the-error-object) object will be returned


