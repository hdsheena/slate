# Notes

The are two objects used by SmartFlow to notify EMR when notes entered into the flowsheet or anesthetic:

* `note`

* `notes`

Both objects are sent with the asynchronous `notes.entered` event when one or several tech notes has been entered/removed.

## The notes object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events (e.g. `notes.entered`). Should be assigned `notes` value
**id** | String | Identificator of the object. Will be transferred to EMR with the `notes.entered` event.
**notes** | Array | The array of `note` objects. See description of the `note` object [below](#the-note-object)


## The note object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | Describes the type of the object transferred with the SmartFlow events (e.g. `notes.entered`). Should be assigned `note` value
**noteGuid** | String | **Required**. A unique internal identifier of the note item
**hospitalizationId** | String | Hospitalization external id (which was provided with hospitalization creation)
**time** | Date | Note creation time (UTC time that corresponds to an hour on a flowsheet). Time format: YYYY-MM-DDThh:mm:ss.sssTZD (e.g. 1997-07-16T19:20:30.000+00:00)
**text** | String | The string value that was entered during note creation
**status** | String | This field describes what have happened to the note. Can be one of the following: 1. `added`, 2. `changed`, 3. `removed`
**type** | Integer | The type of note. Should be `0` - Flowsheet note, `1` - Anesthetic note or `2` - Dental Chart note
**anestheticGuid** | String | A unique internal identifier of the anesthetic sheet, required if `type = 1`, otherwise is equal to `null`

## Retreive multiple notes

> Example of `notes.entered` event JSON:

```json
{
    "clinicApiKey": "clinic-api-key",
    "eventType": "notes.entered",
    "object": {
	    "objectType": "notes",
		"id": "sfs-operation-id",
		"notes":[
	        {
	            "objectType": "note",
	            "noteGuid": "sfs-note-guid1",
	            "hospitalizationId": "external-hosp-id1",
	            "time":"2013-03-28T14:23:56.000+00:00",
	            "status": "changed",
	            "text": "Lorem ipsum...",
                "type": 0,
                "anestheticGuid": null
	        },
	        {
	            "objectType": "note",
	            "noteGuid": "sfs-note-guid2",
	            "hospitalizationId": "external-hosp-id1",
	            "time":"2013-03-28T14:23:56.000+00:00",
	            "status": "added",
	            "text": "Donec eu mattis diam...",
                "type": 1,
                "anestheticGuid": "sfs-anesthetic-guid"
	        }		
		]
	}
}
```

* Url: webhook provided by EMR
* Method: POST
* Asynchronous 
* Transfers [`notes`](#the-notes-object) object included in the `event` object
* Expected response with 200 Http code in case of success.
* In case of the error, EMR should return 400 Http code and optionally the [`Error`](#the-error-object) object
