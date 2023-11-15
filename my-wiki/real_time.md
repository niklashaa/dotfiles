# Real time app
1) Change Data Capture (CDC)
2) Message to client

## CDC
mysql-events, logDB
Needs hosting (Cloud Run?)

The following sounds like using RedisDB or Firebase RT Database sound like a good idea?
[CDC is becoming increasingly popular for use cases that require keeping multiple heterogeneous datastores in sync (like MySQL and ElasticSearch)](https://netflixtechblog.com/dblog-a-generic-change-data-capture-framework-69351fb9099b)

## Client message
- Websockets/WebTransport, SSE, Firebase Cloud Messaging (FCM)
- Nuxt ServerMiddleware could be used for hosting

Questions:
- How can services like Ably help? [Service comparison](https://ably.com/compare/ably-vs-google-pub-sub)

