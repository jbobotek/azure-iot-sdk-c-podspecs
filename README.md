## Publishing CocoaPods

#### Overview

A `<library>.podspec` is a smallish Ruby file that points to a public repo and specifies how that repo
should be used by XCode in order to treat it as an XCode library. CocoaPods.org publishes podspec files by
converting the Ruby to json format and pushing it into the master of a big indexed repo.

These .podspecs are hereby released with the expectation that developers will use them to port or release modified versions of the Azure IoT C SDK, separate from the official releases by Microsoft.

CocoaPods versions are assumed to adhere to semantic versioning conventions.

#### Linting and Publication

1. Update environment variables sdk_ver, umock_ver, macro_util_ver, util_ver, mqtt_ver, and amqp_ver with the release versions (i.e. export util_ver=1.1.13)
2. Lint and Push each repo as needed in this order: AzureMacroUtils, AzureuMockC, AzureIoTUtility, AzureIoTuMqtt, AzureIoTuAmqp, and finally AzureIoTHubClient in the following pattern:
(Note: Because the CocoaPods trunk repo updates so slowly, a manual release of each repo is no slower than running a script.)
    - Call: pod spec lint <Azure podspec here> --allow-warnings --verbose --use-libraries
    - After it passes, Call: pod trunk push <Azure podspec here> --allow-warnings --verbose --use-libraries
    - Wait 30+ seconds
    - Call: pod repo update

Note: It is perfectly acceptable to use existing, and not release dependency repos such as AzureMacroUtils and AzureuMockC in your pod release process, but also note that any modified dependencies require a new release of dependent downstream repos.
