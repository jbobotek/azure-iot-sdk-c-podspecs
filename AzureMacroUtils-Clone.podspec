# Podspec files (like this one) are Ruby code

Pod::Spec.new do |s|
  s.name             = 'AzureMacroUtils'
  s.version          = ENV['macro_util_ver']
  s.summary          = 'AzureIoT Macro Utils library for CocoaPods.'

  s.description      = <<-DESC
This is a CocoaPods release of the Azure uMock C library,
which is part of the Microsoft Azure IoT C SDK.
                       DESC

  s.homepage         = 'https://github.com/Azure/azure-iot-sdk-c/blob/master/doc/sdk_cocoapods.md'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Microsoft' => '' }
  s.source           = { :git => 'https://github.com/Azure/azure-macro-utils-c.git'}

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target  = '10.10'

  # This bash command is performed after the git repo is cloned. It puts
  # some outlier header files where CocoaPods finds them convenient,
  # removes some files that should be ignored, and generates a module.modulemap
  # from the pruned inc/azure_c_shared_utility to properly export the header files.
  s.prepare_command = <<-CMD

    # Assemble the module.modulemap file
    pushd inc > /dev/null
    echo "module AzureMacroUtils [system][extern_c] {" > module.modulemap
    quote_thing='\"'
    for filename in azure_macro_utils/*.h; do
        echo "    header $quote_thing$filename$quote_thing" >> module.modulemap
    done
    echo "    export *" >> module.modulemap
    echo "}" >> module.modulemap
    popd > /dev/null
    # Done assembling module.modulemap file

  CMD

  # CocoaPods only installs explicitly specified files. preserve_paths tells it
  # to retain the module.modulemap during installation
  s.preserve_paths = 'inc/module.modulemap'
  s.module_map = 'inc/module.modulemap'

  s.source_files =
    'inc/**/*.h',
    #'src/*.c'

  s.public_header_files = 'inc/**/*.h'

  # The header_mappings_dir is a location where the header files directory structure
  # is preserved.  If not provided the headers files are flattened.
  s.header_mappings_dir = 'inc/'

  # SWIFT_INCLUDE_PATHS tells Swift where to look for module.modulemap
  s.xcconfig = {
    'USE_HEADERMAP' => 'NO',
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/AzureMacroUtils/inc/"',
    'ALWAYS_SEARCH_USER_PATHS' => 'NO'
  }

end
