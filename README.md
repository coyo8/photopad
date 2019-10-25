# photopad
An iOS app showing flickr photos with keyword search

![overview](https://github.com/coyo8/photopad/blob/master/photopad.gif)

### Running:
First of all; you will need to clone the repo

```bash
$ git clone https://github.com/coyo8/photopad.git
```

After that, just click on the `Photopad.xcodeproj` and it will open the project and then press `CMD+R` to run the project in the simulator or a device if it is connected.

### Architecture:

The Photopad App uses MVVM with coordinator pattern architecture.

I have separated the projects into components and have created a clear boundaries of responsibilities between objects

**Coordinators**: They handle the routing or navigation logic. Also our app is small and so they act as a builder also i.e. creating all the dependencies objects and passing them

**ViewModel**: This encapsulates the data structure and communication between ViewController and model layer.

**Interactor**: In this project, interactor is owned by ViewController and not other way around and I kept it this way for the simplicity unless it would have taken lot of time and also would require third party dependencies like RX.

What Interactor does is, it take cares of the business logic and accordingly communicates with view controller with delegates pattern.

### Caching:
I am doing extensive caching in this project for images. Here I have used NSCache as system can prune it by itself. Also, I have kept lowest memory footprint as possible.

### Network:
For network efficiency, all the images are downloaded in the background thread and there is heavy use of generic to simplify the network layer.

### Thread Safety:
I have also used queue synchronisation to avoid any concurrent or race condition issue with viewModel container.

### AppStart:
I am not doing any extra activity on main thread App start which makes the launch faster.


### Unit Testing:
I have tested the service layer and viewModel for home controller page


## What can be improved:

* Landing page animation. Currently by default I show oceans images, which is not ideal. Instead, I would have moved the search bar in middle and when user taps, it will go on top
* UI Improvements: 
    * Activity Indicator should be better, currently it gets hidden. I should be using some kind of translucent view.
    * In the detail page, I am just showing the same quality image which I can change to higher quality.
    * Better search bar. Currently the search bar get hidden when we scroll down, it can be kept on top.
    * Showing activity indicator on whole doesn’t make sense, I could have loaded each image separately

* Don’t fetch all the 20 images at one go, I can batch that with visible + some offsets.
* Better protocols to define the clear boundaries of the different objects.
* More unit tests or at least cover all the business logic and also add UI test for critical flow
* Accessibility, I haven’t done anything on this part. This bring more user into ecosystem
* I haven’t handled the state restoration 
* Also, I am not handling cases related to Application life cycle like what should it do in background and what would be expected behaviour on different cycles transitions.
* Environment separation for debug, staging and production.
* Finally, I would have looked into adding more functionality like heart button, saving the photo to camera roll etc.
