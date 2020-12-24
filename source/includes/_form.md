# Forms

The are three objects used by SmartFlow to notify EMR when forms are filled in:

* `forms`

* `form`

* `formfield`

All objects are sent with the asynchronous `forms.created` or `forms.udpated` events when one or several forms has been entered or changed.

## The forms object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | *Optional*. Describes the type of the object transferred with the SmartFlow events (e.g. `forms.created`). Should be assigned `forms` value
**id** | String | Identificator of the object. Will be transferred to EMR with the `forms.created` event.
**forms** | Array | The array of `form` objects. See description of the `form` object [below](#the-form-object)


## The form object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | Describes the type of the object transferred with the SmartFlow events (e.g. `forms.created`). Should be assigned `form` value
**formGuid** | String | **Required**. A unique internal identifier of the form
**hospitalizationId** | String | Hospitalization external id (which was provided with hospitalization creation)
**name** | String | A unique identifier of the form type. This value is specified on the `Settings/Forms` web page in the `Internal Name` attribute of the form (e.g. 'checkinform' on a picture below) 
**deleted** | Boolean | True - if the form has been deleted by the user; otherwise - false
**finalized** | Boolean | True - if the form has been finalized by the user; otherwise - false. If the patient is created from the form, then this field will return true
**reportPath** | String | The path to the form pdf report file that has been generated during form finalization
**title** | String | The title of the form (e.g. "Admission form")
**fields** | Array | The array of `formfield` objects. See description of the `formfield` object [below](#the-formfield-object)

<img src="images/formsetting.png"> 

## The formfield object

### Attributes

Parameter | Type | Description
---------- | ------- | -------
**objectType** | String | Describes the type of the object transferred with the SmartFlow events (e.g. `forms.created`). Should be assigned `formfield` value
**name** | String | A unique identifier of the form field. This value is specified on the `Settings/Forms` web page in the `Internal Name` attribute of the property (e.g. 'pet_name' on a picture below) 
**title** | String | Field label (the one that users sees while filling in the form field)
**contentType** | String | This field describes the type of content of the `value` field (e.g. `text/plain`, `image/jpg`)
**value** | String | The string value of the form field 
**values** | Array | The array of string values selected from drop-down list with multiple selection option (If the array is not empty that `value` field above should be ignored.)

<img src="images/propertysetting.png"> 

## Get patient`s forms 

> Example Request:

```http
GET /hospitalization/emr-hospitalization-id/forms HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows getting all forms for the patient specified by `hospitalizationId`. This method returns the list of forms objects with **empty** `fields`. To get the form fields for each form please use the [get form values API](#get-form-values).

* Url: /hospitalization/{hospitalizationId}/forms
* Method: GET
* Synchronous
* Returns HTTP status 200 and a collection of [`form`](#the-form-object) objects with empty `fields`
* In case of error returns the [`Error`](#the-error-object) object

## Get form values

> Example Request:

```http
GET /hospitalization/emr-hospitalization-Id/form/form-guid HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows getting all fields for the form determined by `formGuid` and `hospitalizationId`.

* Url: /hospitalization/{hospitalizationId}/form/{formGuid}
* Method: GET
* Synchronous
* Returns HTTP status 200 and the [`form`](#the-form-object) object with all the fields 
* In case of error returns the [`Error`](#the-error-object) object


## Retreive forms with events

> Example of `forms.created` event JSON:

```json
{
  "clinicApiKey": "clinic-api-key",
  "eventType": "forms.created",
  "object": {
    "objectType": "forms",
    "id": "sfs-operation-id"
    "forms": [
      {
        "objectType": "form",
	    "formGuid": "sfs-form-guid",
    	"hospitalizationId": "external-hospitalization-id",
        "name": "checkinform",
        "title": "Client Self Check-in",
        "fields": [
          {
            "objectType": "formfield",
            "name": "avatar",
            "title": "Avatar",
            "value": "https://attached-image-webfile-path",
            "contentType": "image/jpg"
          },
          {
            "objectType": "formfield",
            "name": "email",
            "title": "Your email",
            "value": "me@example.com",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "first_name",
            "title": "Your name",
            "value": "John",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "last_name",
            "title": "Last name",
            "value": "Doe",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "address",
            "title": "Address",
            "value": "105, 11th Ave",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "city",
            "title": "City",
            "value": "New York",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "state",
            "title": "State",
            "value": "NY",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "zip",
            "title": "Zip",
            "value": "10001",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "phone_home",
            "title": "Home phone",
            "value": "(111) 111-1111",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "phone_work",
            "title": "Work phone",
            "value": "(222) 222-2222",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "phone_cell",
            "title": "Owner's cell phone",
            "value": "(333) 333-3333",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "phone_co_owner",
            "title": "Co-Owner's cell phone",
            "value": "(444) 444-4444",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "phone_number_to_reach",
            "title": "Best number to reach you today",
            "value": "Home phone",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "pet_name",
            "title": "Your Pet's Name",
            "value": "Fluffy",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "weight",
            "title": "Weight (kg)",
            "value": "3.5",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "birth_date",
            "title": "Birth date",
            "value": "2016-07-16T19:20:30.000+00:00",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "breed",
            "title": "Breed",
            "value": "English Cocker Spaniel",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "sex",
            "title": "Sex",
            "value": "Male",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "family_veterinarian",
            "title": "Family veterinarian",
            "value": "Dr. Ivan Zak",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "clinic",
            "title": "Clinic",
            "value": "Best Pet Vet",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "visit_reason",
            "title": "What is the reason for your visit today?",
            "value": "Vaccination",
            "contentType": "text/plain"
          },
          {
            "objectType": "formfield",
            "name": "signature",
            "title": "Consent Form",
            "value": "https://attached-image-webfile-path",
            "contentType": "image/jpg"
          }
        ]
      }
    ]
  }
}
```
The `forms.created` and `form.updated` events are sent from SmartFlow when one or several forms were created or updated. SmartFlow will send [forms](#the-forms-object) object with all information entered into the forms.

* Url: webhook provided by EMR
* Method: POST
* Asynchronous 
* Transfers [forms](#the-forms-object) object included in the `event` object
* Expected response with 200 Http code in case of success.
* In case of the error, EMR should return 400 Http code and optionally the [`Error`](#the-error-object) object

## Download the form report

> Example Request:

```http
GET /hospitalization/emr-hospitalization-id/formreport/form-guid HTTP/1.1
User-Agent: MyClient/1.0.0
Content-Type: application/json
emrApiKey: "emr-api-key-received-from-sfs"
clinicApiKey: "clinic-api-key-taken-from-account-web-page"
timezoneName: Europe/Helsinki
```

This method allows to download the form pdf report generated upon form finalization. 

All the dates in the downloaded report will be represented in the time zone that you **must** explicitly specify in the `timezoneName` header of the HTTP request (e.g. `timezoneName: Europe/Helsinki`). Please visit this [web-page](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for the complete list of the time zone names. 

Specify the `hospitalizationId` of the hospitalization object in the EMR. Use the same `hospitalizationId` that was supplied when hospitalization had been created. Also specify the `formGuid` value that uniquely identifies the form. This value can be obtained from `forms.created` [event](#retreive-forms-with-events) or by fetching all the forms for the patient with [this](#get-patient-s-forms) API.

* Url: /hospitalization/{hospitalizationId}/formreport/{formGuid}
* Method: GET
* Synchronous
* Returns the pdf report with the output stream. The Content-Type header will contain the `application/pdf` value
* In case of error returns the [`Error`](#the-error-object) object