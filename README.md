# Flickr image search API using MVVM
This repository demonstrate the Flickr image search API with search endpoint and demonstrate MVVM architecture with Swift.  

This demo app contains two columned UI to disply search images. When opening the app, users can see the random image list. All images are fetched from Flickr's API with `search` endpoint. Also, it allows users to search the images as per his/her need and show past search history as well for quick search.
- Loading and error states are handled using observable closure.
- Images are cached for better performance.
- ViewModel & View bounded using swift closure.
- UI refreshed with the data update.
- Added pagination _(infinite scrolling)_ to the image lists.


## Technical Specification

>  - [x] Xcode 12 and later 
>  - [x] iOS 13.0 and later
>  - [x] Swift 5
>  - [x] iPhone only app
>  - [x] Swift & Storyboard
>  - [x] Unit Test cases

### Architecture
MVVM *(Model View ViewModel)*

### Cocoa Pods Used
Didn't used any dependency.


### API provider
Generate your API key at: 
`https://www.flickr.com/services/api/misc.api_keys.html` 

Flicker search API information can be found at: 
`https://www.flickr.com/services/api/explore/flickr.photos.search`


---------- 

## Communication

-   If you  **want to contribute**, submit a pull request.
-   For any qustion or suggetions, you can create issue for it. Enjoy The Coding !!!
