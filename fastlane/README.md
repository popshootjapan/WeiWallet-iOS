fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios deploy
```
fastlane ios deploy
```
Deploy a new version to the App Store
### ios inhouse
```
fastlane ios inhouse
```
Submit InHouse for fabric, after unit testing
### ios test
```
fastlane ios test
```
Runs all the tests
### ios match_development
```
fastlane ios match_development
```

### ios match_adhoc
```
fastlane ios match_adhoc
```

### ios match_appstore
```
fastlane ios match_appstore
```

### ios refresh_dsyms
```
fastlane ios refresh_dsyms
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
