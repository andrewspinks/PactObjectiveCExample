# Example Pact ObjectiveC project using Git Submodules
[![Build Status](https://travis-ci.org/andrewspinks/PactObjectiveCExample.svg?branch=master)](https://travis-ci.org/andrewspinks/PactObjectiveCExample)

See the Pact Swift library for more details. [PactConsumerSwift library][pact-consumer-swift]

## Installation with Git Submodules

### Install the [pact-mock_service](https://github.com/bethesque/pact-mock_service)
  `gem install pact-mock_service -v 0.2.4`

```sh
mkdir Vendor # you can keep your submodules in their own directory
git submodule add git@github.com:DiUS/pact-consumer-swift.git Vendor/pact-consumer-swift
git submodule update --init --recursive
```

#### Add `PactConsumerSwift.xcodeproj` and dependencies to your test target

Right-click on the group containing your application's tests and
select `Add Files To YourApp...`.

Next, select `PactConsumerSwift.xcodeproj`, from `Vendor/pact-consumer-swift`

Do the same process for the following dependencies:
* `Alamofire.xcodeproj`, from `Vendor/pact-consumer-swift/Carthage/Checkout/Alamofire/`
* `Quick.xcodeproj`, from `Vendor/pact-consumer-swift/Carthage/Checkout/Quick/`
* `Nimble.xcodeproj`, from `Vendor/pact-consumer-swift/Carthage/Checkout/Nimble/`

Once you've added the dependent projects, you should see it in Xcode's project navigator, grouped with your tests.

![](http://i.imgur.com/s6uBK1j.png)

#### Link `PactConsumerSwift.framework`

 Link the `PactConsumerSwift.framework` during your test target's
`Link Binary with Libraries` build phase.

![](http://i.imgur.com/Qrif7eo.png)

#### Setup your Test Target to run the pact server before the tests are run
  Modify the Test Target's scheme to add scripts to start and stop the pact server when tests are run.
  * From the menu `Product` -> `Scheme` -> `Edit Scheme`
    - Edit your test Scheme
  * Under Test, Pre-actions add a Run Script Action
    ```bash
    PATH=/path/to/pact-mock-service/binary:$PATH
    "$SRCROOT"/Vendor/pact-consumer-swift/scripts/start_server.sh
    ```
    - Make sure you select your project under `Provide the build settings from`, otherwise SRCROOT will not be set which the scripts depend on

  ![](http://i.imgur.com/asn8G1P.png)
  * Under Test, Post-actions add a Run Script Action
    ```bash
    PATH=/path/to/pact-mock-service/binary:$PATH
    "$SRCROOT"/Vendor/pact-consumer-swift/scripts/stop_server.sh
    ```
    - Make sure you select your project under `Provide the build settings from`, otherwise SRCROOT will not be set which the scripts depend on

## Writing tests
See PactTests.m for examples of writing Pact tests in Objective C. For Swift see [Pact Swift Example](https://github.com/andrewspinks/PactSwiftExample)

[pact-consumer-swift]: https://github.com/DiUS/pact-consumer-swift