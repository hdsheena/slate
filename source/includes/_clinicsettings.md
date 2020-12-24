# Clinic Settings

This API allows to get the settings of a particular clinic. You may want to use this API to check these settings before downloading reports for discharged patients. 


## The clinicSettings object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events. Should be assigned `clinicSettings` value
**documentsManagement** | documentsManagement | The object containing the details of the clinic's documentsManagement settings


<aside class="warning">
You may want to use this API right before downloading patient documents. Do not store `clinicSettings` in your database because they may change quite frequently.
</aside>

## The documentsManagement object

The `documentsManagement` object gives you access to the clinic's settings on the Documents Management settings page.

<img src="images/docsmanagement.png"> 

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events. Should be assigned `documentsManagementSettings` value
**exportToEmr** | Boolean | True if the setting to "Export documents to EMR" is set as "Yes" in the SmartFlow UI. See [Documents Management in Smart Flow](#discharging-patients) for more information.
**merge** | Boolean | True if the setting to "Merge reports into one PDF" is set as "Yes" in the SmartFlow UI. See [Documents Management in Smart Flow](#discharging-patients) for more information.
**retain** | Object | Lists each document possibly generated for any hospitalization in SmartFlow, and whether the "FILES TO RETAIN AFTER DISCHARGE" setting is set to Yes (true) or No (false) for each.

Based on these details, you can determine what to do next.

* **exportToEmr:** 
    * **false:** If the `exportToEmr` parameter is `false`, you do not need to attempt to download any files for the patient. 
        * `reportPath` fields in [hospitalization](#the-hospitalization-object), [anesthetic](#the-anesthetic-object), [form](#the-form-object) objects will be NULL;
        * attempts to access documents with any API will return 465 with the message *"The manager turned off the document on the Settings / Documents management page"*;

    * **true:** If the `exportToEmr` parameter is `true`, then the user may specify which documents to export to EMR in `Files To Retain After Discharge` section. 

* **retain** In any case where a document is not retained after discharge, the appropriate API will return 465 error with the message *"The manager turned off the document on the Settings / Documents management page"* (as well as `reportPath` field in the appropriate object will be NULL, if applicable).

* **merge** If the user sets `MERGE REPORTS INTO ONE PDF` setting to YES, then `hospitalization.reportPath` as well as [download the flowsheet report API](#download-the-flowsheet-report) will return the *merged* pdf file, that will include all the documents specified in `Files To Retain After Discharge` section. If this option has been selected by the user, you should download only one pdf file that will include all documents chosen by the user rather than implementing all Smart Flow APIs mentioned above to access each document separately. When this is true, any file download APIs except [the flowsheet report API](#download-the-flowsheet-report) API will return 465 error with the message *"The manager turned off the document on the Settings / Documents management page"* (as well as `reportPath` field in the appropriate object will be NULL, if applicable)

Here are the reports that will be created for every hospitalization, with references to their API documentation:

 * [Flowsheet report](#download-the-flowsheet-report)
 * [Medical records report](#download-the-medical-records-report)
 * [Billing report](#download-the-billing-report)
 * [Notes report](#download-the-notes-report)

For the following real-time reports, it's best practice to download the reports when the `Finalized` event is sent, which includes the `reportPath` (and `recordsReportPath` for anesthetic) if the `documentsManagement` settings indicate you can download those reports.

* If the anesthetic sheet was created, completed, and finalized, for the patient, then the associated [Anesthetic Sheet and Anesthetic Records reports](#retreive-anesthetic-sheet-and-anesthetic-records-reports) can be downloaded
* [Form report](/#download-the-form-report) for each form created for the patient. To download all forms upon patient discharge you will need to [get all patients forms](#get-patient-s-forms) first, and then download the document from the `Form.reportPath`
* If a dental chart was created, completed and finalized for the patient, then the associated [Dental Chart Report and Media](#retreive-dental-chart-and-associated-media) can be downloaded

## Retreive clinicSettings

> Example Request:

```http
GET /clinicsettings HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
```
```json
{
	"objectType":"clinicsettings",
	"documentsManagement":
	{
		"objectType":"documentsmanagementsettings",
		"exportToEmr":true,
		"merge":true,
		"retain":
		{
			"medical_records":true,
			"billing":true,
			"notes":true,
			"flowsheet":true,
			"anesthetic":true,
			"anesthetic_records":true,
			"checkinform":true,
			"surgicalconsentform":true,
			"Allergy Form":true,
			"dentalcharts":true
		}
	}
}
```

* Url: /clinicsettings
* Method: GET
* Synchronous 
* Returns HTTP status 200 and any applicable [`clinicsettings`](#the-clinicsettings-object) objects
* In case of error returns the [`Error`](#the-error-object) object


