# Google Cloud

## Google cloud blog
https://cloud.google.com/blog/topics/developers-practitioners

## Tutorials and best practices
### Might be a good idea to switch from Cloud functions to Google Cloud Engine
https://cloud.google.com/blog/topics/developers-practitioners/where-should-i-run-my-stuff-choosing-google-cloud-compute-option

https://stackoverflow.com/questions/63528028/advantages-for-using-an-express-app-on-google-cloud-function

### Next time we have connection issues, read this
https://cloud.google.com/blog/topics/developers-practitioners/troubleshooting-cloud-functions-connection-issues-cloud-sql-private-ips

### Deploy with target server

#### In case we need to integrate vpc into GAE
https://stackoverflow.com/questions/61333988/how-to-establish-a-secure-connecton-from-gae-with-public-access-to-a-private-g
https://cloud.google.com/appengine/docs/standard/connecting-vpc

#### Service logs
https://cloud.google.com/appengine/docs/standard/nodejs/building-app/viewing-service-logs

#### How cloud build works
https://cloud.google.com/source-repositories/docs/automate-app-engine-deployments-cloud-build

#### Env variables
https://medium.com/fastcto/finally-a-solution-to-google-app-engines-environment-variables-431dcb2419c0
https://dev.to/mungell/google-cloud-app-engine-environment-variables-5990
https://stackoverflow.com/questions/31122337/does-google-app-engine-support-environment-variables
https://stackoverflow.com/questions/22669528/securely-storing-environment-variables-in-gae-with-app-yaml/54055525#54055525

#### Dockerize App
https://dockerize.io/guides/docker-nuxtjs-guide
https://cloud.google.com/docs/buildpacks/build-application
https://cloud.google.com/docs/buildpacks/use-a-specific-builder


## Download files (from firebase storage)
https://firebase.google.com/docs/storage/web/download-files
https://firebase.google.com/docs/reference/js/storage#getbytes

### Download, then use URL.createObjectURL
Downside: Can't see download progress in browser
https://stackoverflow.com/questions/41938718/how-to-download-files-using-axios

### Change Content-Disposition header of storage objects
Not sure if possible

https://stackoverflow.com/questions/51650950/cant-override-content-disposition-to-inline-in-firebase-storage-with-admin-sd
https://stackoverflow.com/questions/43081018/from-firebase-storage-download-file-to-iframe
https://blog.logrocket.com/programmatic-file-downloads-in-the-browser-9a5186298d5c/

### Use img tag?
https://stackoverflow.com/questions/39356419/rename-or-download-file-from-firebase-storage-in-javascript

### Use download attribute with <a> element
Not working due to CORS
