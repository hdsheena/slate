# Events

SmartFlow will send events to EMR on different occasions:

1. [Inventory import finished](#receiving-the-status-of-import-operation)
2. [When single medical record has been entered or removed](#retreive-single-medical-record)
3. [When mutliple medical records have been entered or removed](#retreive-multiple-medical-records)
4. [When patient has been created in SmartFlow](#get-notified-about-new-hospitalizations)
5. [When patient has been discharged from the whiteboard](#discharge-hospitalization-event)
6. [When mutliple notes have been entered or removed](#retreive-multiple-notes)
7. [When anesthetic sheet has been finalized](#finalize-anesthetic-event)
8. [When the form has been filled in for a patient](#retreive-forms-with-events)

In the future there can be other events added to this, e.g. sending flowsheet report or medical records report on patient discharge, etc…

Events will be sent only for those hospitalizations that have been created from EMR. The only exception is the `hospitalizations.created` event that is sent even for the patients created manually with SmartFlow user interface. Events on hospitalizations created directly from SmartFlow won't be sent to EMR webhook. 

Sending events require webhook to be registered in SmartFlow. You may register a webhook that will receive all the events associated with your EMR, or you may [register a custom webhook](#register-custom-webhook) for each clinic account. Requirements to webhook:

* HTTP POST method
* Accepts json object of the [`Event`](the-event-object) type
* Returns HTTP code 200 in case of success
* Returns HTTP code 400 in case of error and optionally sends the [`Error`](#the-event-object) object
* Some events (that post 1 item) require synchronous processing
* Some events require asynchronous processing, with further notifications of the results

## The event object

> Example of the event object:

```json
{
    "clinicApiKey": "clinic-api-key",
    "eventType": "treatments.records_entered",
    "object": {
	    
	}
}
```

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**clinicApiKey** | String | Clinic api key to associate clinic on EMR`s side
**eventType** | String | The [`type`](#types-of-events) of the event
**object** | Object | Object of one of the following type: `treatment`, `treatments`, `inventoryitems`, `hospitalization`, etc... This list can expand as soon as new objects will be sent with the API.


## Types of events

SmartFlow will send several events on different occasions. Below is short description of the events.

Event | Description
---------- | -------
**anesthetics.finalized** | Sent from SmartFlow when clinic stuff finalizes anesthetic sheet(s)
**forms.created** | Sent from SmartFlow when the form(s) is created and filled in for the patient (e.g. client self check-in form)
**forms.updated** | Sent from SmartFlow when the form's content is updated or form changes its status to `finalized` or `deleted`
**hospitalizations.created** | Sent after a patient(s) has been created in SmartFlow
**hospitalization.discharged** | Sent after a patient has been discharged from the SmartFlow whiteboard
**hospitalizations.discharged** | Sent after multiple patients have been discharged from the SmartFlow whiteboard
**inventoryitems.imported** | Sent after importing of emr inventory items finished
**notes.entered** | Sent from SmartFlow when multiple notes have been entered/removed
**medics.imported** | Sent after importing of emr medics finished
**treatment.record_entered** | Sent from SmartFlow when one medical record has been entered/removed
**treatments.records_entered** | Sent from SmartFlow when multiple medical records have been entered/removed


## Register custom webhook

> Example Request:

```http
POST /account/webhook?url=your_custom_url HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
```

You may use this API to register a custom HTTPS webhook that will receive events only for the specified clinic account. You may use this webhook for a group of clinics also. 

* Url: /account/webhook?url=your_custom_url
* Method: POST
* Synchronous
* Url parameters: `url` string. The body of HTTP request should remain empty
* Returns HTTP status 200 in case the new webhook has been registered
* In case of error returns the [`Error`](#the-error-object) object