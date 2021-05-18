# LucidDreamer

Source code will not be uploaded as I am plannning on uploading this app to the appstore once I get my hands on an EEG sensor that I can use to cross validate my deep sleep detection algorithm (should be soon hopefully). The app uses the standard MVC design pattern and some screenshots will be posted below of the app. 

Below is the screen recording of the application running on the simulator. Note that due to the limit of the simulator, some of the features that are working on a real device does not work on the simulator (such as WatchSession's tranferFile() method to listen to audio recordings on the watch app, settings sync between IOS and watch app, etc...) Also the below appearances and flow is prelimiary and may be changed. 

![](screenrecording.gif)

The sleep detection algorithm uses ZCM to detect whether user is in light sleep or deep sleep from accelerometer data. This concept is inspired from Actigraphy and also from this paper https://academic.oup.com/annweh/article/64/4/350/5735350

The app also uses heart rate data to auguement its decision. It takes the last 12 minutes of heart rate data and performs a linear interpolation of all of the points. If the slope of the resulting line is greater than the set threshold, the user is determined to be in light sleep. The app uses both this actigraphy concept and the heart rate to make its decision.

Once I get an EEG device, I will be testing the algorithm with the EEG device to ensure that it performs as expected. Once that is done, the app will be available in the app store. 
