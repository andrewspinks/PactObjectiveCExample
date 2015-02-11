# Example Pact ObjectiveC project using Git Submodules
[![Build Status](https://travis-ci.org/andrewspinks/PactObjectiveCExample.svg?branch=master)](https://travis-ci.org/andrewspinks/PactObjectiveCExample)

See the Pact Swift library for more details. [PactConsumerSwift library][pact-consumer-swift]

## Installation with Git Submodules

### Install the [pact-mock_service](https://github.com/bethesque/pact-mock_service)
  `gem install pact-mock_service -v 0.3.0`

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
* `BrightFutures.xcodeproj`, from `Vendor/pact-consumer-swift/Carthage/Checkout/BrightFutures/`

Once you've added the dependent projects, you should see it in Xcode's project navigator, grouped with your tests.

![](http://i.imgur.com/s6uBK1j.png)

#### Link `PactConsumerSwift.framework`

 Link the `PactConsumerSwift.framework` during your test target's
`Target Dependencies` build phase.

![](http://i.imgur.com/Qrif7eo.png)

#### Setup your Test Target to run the pact server before the tests are run
  Modify the Test Target's scheme to add scripts to start and stop the pact server when tests are run.
  * From the menu `Product` -> `Scheme` -> `Edit Scheme`
  * Under Test, Pre-actions add a Run Script Action
    Add a Run Script Action with the following
    _NB: the PATH variable should be set to the location of the pact-mock-service binary - you can find the path using `which pact-mock-service`_

    ```bash
    PATH=/path/to/pact-mock-service/binary:$PATH
    "$SRCROOT"/Vendor/pact-consumer-swift/scripts/start_server.sh
    ```
    - Make sure you select your project under `Provide the build settings from`, otherwise SRCROOT will not be set which the scripts depend on

  ![](http://i.imgur.com/dJq7ytX.png)
  * Under Test, Post-actions add a Run Script Action to stop the pact service.

    ```bash
    PATH=/path/to/pact-mock-service/binary:$PATH
    "$SRCROOT"/Vendor/pact-consumer-swift/scripts/stop_server.sh
    ```
    - Make sure you select your project under `Provide the build settings from`, otherwise SRCROOT will not be set which the scripts depend on
  ![](http://i.imgur.com/IP0E9Tf.png)

#### Objective-C Caveat: Your Test Target Must Include At Least One Swift File

The Swift stdlib will not be linked into your test target, and thus
PactConsumerSwift will fail to execute properly, if you test target does not contain
*at least one* Swift file. If it does not, your tests will exit
prematurely with the following error:

```
*** Test session exited(82) without checking in. Executable cannot be
loaded for some other reason, such as a problem with a library it
depends on or a code signature/entitlements mismatch.
```

To fix the problem, add a blank file called `BlankClass.swift` to your test target:

```swift
// BlankClass.swift

import PactConsumerSwift
```

## Writing tests
See PactTests.m for examples of writing Pact tests in Objective C. For Swift see [Pact Swift Example](https://github.com/andrewspinks/PactSwiftExample)

[pact-consumer-swift]: https://github.com/DiUS/pact-consumer-swift