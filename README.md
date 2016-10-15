# WALIS App

Last revision: `09.10.2016` by [ @marc-fiedler ]

|||
|---|---|
|Language|Objective-C|
|Authors|Marc Fiedler|
|License|MIT|
|runs on|XCode 8.0 / iOS 8.4+|
|Robot Repository|https://github.com/IBM-Hackathon/walis|
|API Endpoint|https://snakenet.org/api/walis|

## Basic idea
The Walis App for iOS has been designed to make it easy to interact with robots directly from a remote location. The robot Walis can send silent and active push notifications to one specific or a range of iOS devices. Silent notifications are ment to create a history of events that happend and active push notifications are ment for alerts or warnings.

![Screenshot](screenshots/screen2.jpg)


## Technical information
This API endpoint is a relay for IBM Bluemix communication and enables the robot to directly communicate with a phone. The API on the server is only an abstraction layer between the robot and IBM Bluemix.

## API

The API interface obeys the Ophion API rules. That means the package will automatically create an endpoint that is reachable by Package name (e.g. "beckroege"). The endpoint will accept the following requests:

* Request device list (devices.handler)
* Request all posts (post.handler)
* Register new device (register.handler)
* Ping request (ping.handler)
* Push a Notification to device(s) (push.handler)

> Important note:

> Usually the communication between client and server have an exta layer of security but for this demo this layer has been disabled.

For a complete set of calls please visit the Wiki of this repository  

### Example Request

```json
{
    "Request": "Ping",   
    "Api": {
        "Version": "4.0"
    }
}
```

The API will reply with HTTP response codes. On Success the API will answer with 200 and a Status array that contains a Message string. On Error the API will return the appropriate HTTP response code and an additional Status array containing a Message string.

### Example Reply Success
```json
{
  "Api": {
    "Version": "4.0"
  },
  "Time": 1475068534,
  "Status": {
    "Package": "WALIS App",
    "Type": 1,
    "Message": "Pong"
  },
  "Warning": {
    "Message": "The api major version [3] you are using is depricated. Current is: 4.0"
  }
}
```

### Example Reply Error

```json
{
  "Api": {
    "Version": "4.0"
  },
  "Time": 1475069689,
  "Status": {
    "Code": 406,
    "Message": "Invalid Ophion-Interface"
  }
}
```
> NOTE: the status code here will be the same as the HTTP Response code

## Push request
```json
{
    "Request": "Push",
    "Title": "Walis Robot report",
    "Body": "Hey, you should your mum a call, she forgot her blue pills today.",
    "Badge": 1,
    "Sound": "default",
    "Device": 0,
    
    "Api": {
        "Version": "4.0"
    }
}
```
> NOTE: the device ID 0 means that it will be broadcasted to all registered devices.

If everything went well, the reply will look like this:

```json
{
  "Api": {
    "Version": "4.0"
  },
  "Time": 1476367787,
  "Status": {
    "Package": "WALIS App",
    "Type": 1,
    "Message": "Messages delivered",
    "MessageCount": 1
  }
}
```

## Contact
Feel free to drop me a message at mf (at) blackout-tech (dot) org
