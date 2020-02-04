# Podspec files (like this one) are Ruby code

Pod::Spec.new do |s|
  s.name             = 'AzureIoTuAmqp-Clone'
  s.version          = ENV['amqp_ver']
  s.summary          = 'AzureIoTuAmqp library for CocoaPods.'

  s.description      = <<-DESC
This is a CocoaPods release of the Azure C uAMQP library.
                       DESC

  s.homepage         = 'https://github.com/Azure/azure-iot-sdk-c/blob/master/doc/sdk_cocoapods.md'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Microsoft' => '' }
  s.source           = { :git => 'https://github.com/Azure/azure-uamqp-c.git'}#, :tag => ENV['amqp_ver'] }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target  = '10.10'

  # This bash command is performed after the git repo is cloned. It generates a module.modulemap
  # from the pruned inc/azure_c_shared_utility to properly export the header files.
  s.prepare_command = <<-CMD

    # Assemble the module.modulemap file
    pushd inc > /dev/null
    echo "module AzureIoTuAmqp-Clone [system][extern_c] {" > module.modulemap
    quote_thing='\"'
    for filename in azure_uamqp_c/*.h; do
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
    'src/*.c'

  s.exclude_files =
    'src/socket_listener_win32.c'

  # The header_mappings_dir is a location where the header files directory structure
  # is preserved.  If not provided the headers files are flattened.
  s.header_mappings_dir = 'inc/'

  s.public_header_files = 'inc/**/*.h'

  s.xcconfig = {
    # This is needed by all pods that depend on Protobuf:
    "GCC_PREPROCESSOR_DEFINITIONS" => "$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1",
    # This is needed by all pods that depend on gRPC-RxLibrary:
    "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES",

    'USE_HEADERMAP' => 'NO',
    'USER_HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/AzureIoTUtility-Clone/inc/" "${PODS_ROOT}/AzureIoTuAmqp-Clone/inc/"',
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/AzureIoTUtility-Clone/inc/" "${PODS_ROOT}/AzureIoTuAmqp-Clone/inc/"',
    'ALWAYS_SEARCH_USER_PATHS' => 'NO'
  }

  s.dependency 'AzureMacroUtils', ENV['macro_util_ver']
  s.dependency 'AzureuMockC', ENV['umock_ver']
  s.dependency 'AzureIoTUtility-Clone', ENV['util_ver']
end
