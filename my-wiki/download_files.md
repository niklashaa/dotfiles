# How to download files from firebase storage

## Official documentation
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
