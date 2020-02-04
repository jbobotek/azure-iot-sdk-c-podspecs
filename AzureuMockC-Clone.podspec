# Podspec files (like this one) are Ruby code

Pod::Spec.new do |s|
  s.name             = 'AzureuMockC'
  s.version          = ENV['umock_ver']
  s.summary          = 'AzureIoT uMock-C library for CocoaPods.'

  s.description      = <<-DESC
This is a CocoaPods release of the Azure uMock C library,
which is part of the Microsoft Azure IoT C SDK.
                       DESC

  s.homepage         = 'https://github.com/Azure/azure-iot-sdk-c/blob/master/doc/sdk_cocoapods.md'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Microsoft' => '' }
  s.source           = { :git => 'https://github.com/Azure/umock-c.git'}

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target  = '10.10'

  # This bash command is performed after the git repo is cloned. It puts
  # some outlier header files where CocoaPods finds them convenient,
  # removes some files that should be ignored, and generates a module.modulemap
  # from the pruned inc/azure_c_shared_utility to properly export the header files.
  s.prepare_command = <<-CMD

    rm -f src/*.c
    cp inc/**/umock_c_prod.h .
    rm -f inc/**/*.h
    mv umock_c_prod.h inc/umock_c/

    # Assemble the module.modulemap file
    pushd inc > /dev/null
    echo "module AzureuMockC [system][extern_c] {" > module.modulemap
    quote_thing='\"'
    for filename in umock_c/umock_c_prod.h; do
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

  # iOS does not ship with curl, so we'll use httpapi_compact.c as the default
  # If curl becomes important at some point, remove the adapters/httpapi_compact
  # entry from the s.source_files entry below and add:
  #     s.ios.source_files = 'adapters/httpapi_compact.c'
  #         and
  #     s.osx.source_files = 'adapters/httpapi_curl.c'
  s.source_files =
    'inc/**/umock_c_prod.h',

  s.public_header_files = 'inc/**/umock_c_prod.h'
#  s.preserve_paths = 'inc/umock_c/'

  # The header_mappings_dir is a location where the header files directory structure
  # is preserved.  If not provided the headers files are flattened.
  s.header_mappings_dir = 'inc/'

  # SWIFT_INCLUDE_PATHS tells Swift where to look for module.modulemap
  s.xcconfig = {
    'USE_HEADERMAP' => 'NO',
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/AzureuMockC/inc/"',
    'ALWAYS_SEARCH_USER_PATHS' => 'NO'
  }

  s.dependency 'AzureMacroUtils', ENV['macro_util_ver']
end
