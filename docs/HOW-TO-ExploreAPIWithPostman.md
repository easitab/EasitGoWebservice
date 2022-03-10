# Exploring the API with Postman

![bild](https://user-images.githubusercontent.com/50325442/157610039-84642edb-3fc3-4396-beb0-0b55e0adad86.png)

## Authorization

The first thing you need to do is add a autorization method to the request. Easit GO uses Basic Auth with a api key (a password is not needed).

![bild](https://user-images.githubusercontent.com/50325442/157611794-96e302fc-2c81-40a1-bbc9-da4aec2b25d9.png)

## Setting up a request to ping GO

For a simple "Ping request" you only need to send a request to the endpoint http://urlToEasitGO/integration-api/ping with the method GET.

![bild](https://user-images.githubusercontent.com/50325442/157610802-c6e77066-292d-4ad8-a1f8-bf2c765ece43.png)


## Setting up a request for getting items from GO

### Body

For getting items back from GO we need to send a request to the endpoint http://urlToEasitGO/integration-api/items with the method GET.
We add the body for the request and only specify the minimum required. Choose *Body* under the URL field, choose *raw* and instead of *Text* choose JSON.

![bild](https://user-images.githubusercontent.com/50325442/157614475-908bed14-5d4a-4282-9391-a2a0daa3834a.png)

Change the value *identifierForYourView* to the identifier for your webservice view.

```json
{
    "itemViewIdentifier": "identifierForYourWebserviceView",
    "page": 1
}
```
![bild](https://user-images.githubusercontent.com/50325442/157613843-54dbc80d-4545-4558-893c-9f714d896455.png)

Click *Send* and you should get the first page of items back.

### Response

![bild](https://user-images.githubusercontent.com/50325442/157615123-fc4b92a4-a442-4846-8952-1fd898023a6e.png)


## Setting up a request for importing items to GO

### Body

For creating or updating items in GO we need to send a request to the endpoint http://urlToEasitGO/integration-api/items with the method POST.
We add the body for the request and only specify the minimum required. Choose *Body* under the URL field, choose *raw* and instead of *Text* choose JSON.

![bild](https://user-images.githubusercontent.com/50325442/157614475-908bed14-5d4a-4282-9391-a2a0daa3834a.png)

Change the value *importHandlerIdentifier* to the identifier for your import handler.

```json
{
    "importHandlerIdentifier": "identifierForYourImportHandler",
    "itemToImport": [
        {
            "property": [
                {
                    "content": "string",
                    "name": "property1"
                },
                {
                    "content": "string",
                    "name": "property2"
                }
            ]
        }
    ]
}
```

![bild](https://user-images.githubusercontent.com/50325442/157617288-6ff40c50-d5bb-4fbb-917c-8fdfa8664c0b.png)

Click *Send* and you should get a response back. 

### Response

If no return value is specified in the import handler you will get a response looking like this.

![bild](https://user-images.githubusercontent.com/50325442/157618630-35fdac37-a11b-41e4-ac7d-f71d0f34f8d1.png)

In this example we have a return value so the response looks like this.

![bild](https://user-images.githubusercontent.com/50325442/157618799-5ca66069-1d3b-4368-9c25-15fc24233cde.png)
