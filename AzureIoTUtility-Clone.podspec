# Podspec files (like this one) are Ruby code

Pod::Spec.new do |s|
  s.name             = 'AzureIoTUtility-Clone'
  s.version          = ENV['util_ver']
  s.summary          = 'AzureIoT C-Utility library for CocoaPods.'

  s.description      = <<-DESC
This is a CocoaPods release of the Azure C Shared Utility library,
which is part of the Microsoft Azure IoT C SDK.
                       DESC

  s.homepage         = 'https://github.com/Azure/azure-iot-sdk-c/blob/master/doc/sdk_cocoapods.md'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Microsoft' => '' }
  s.source           = { :git => 'https://github.com/Azure/azure-c-shared-utility.git'} #, :branch => 'jbobotek-test-cocoa' }#, :tag => ENV['util_ver'] }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target  = '10.10'

  # This bash command is performed after the git repo is cloned. It puts
  # some outlier header files where CocoaPods finds them convenient,
  # removes some files that should be ignored, and generates a module.modulemap
  # from the pruned inc/azure_c_shared_utility to properly export the header files.
  s.prepare_command = <<-CMD
    # Keeping this script idempotent makes using it in a
    # development situation much easier.
    cp pal/generic/refcount_os.h inc/azure_c_shared_utility
    cp adapters/linux_time.h inc
    cp pal/ios-osx/*.h inc
    rm -f src/etwlogger_driver.c
    rm -f src/etwxlogging.c
    rm -f src/dns_resolver_ares.c
    rm -f src/tlsio_cy*.*
    rm -f src/logging_stacktrace.c
    rm -f src/gballoc.c
    rm -f src/gbnetwork.c
    rm -f adapters/tlsio_wolf*.*
    rm -f adapters/tlsio_bear*.*
    rm -f adapters/tlsio_openssl.c
    rm -f adapters/tlsio_schannel.c
    rm -f adapters/x509_schannel.c
    rm -f adapters/x509_openssl.c
    rm -f adapters/timer.c
    rm -f adapters/string_utils.c
    rm -f src/http_proxy_stub.c

    rm -R inc/azure_c_shared_utility/windowsce || true
    rm -f inc/azure_c_shared_utility/etwlogger.h
    rm -f inc/azure_c_shared_utility/etwlogger_driver.h
    rm -f inc/azure_c_shared_utility/logging_stacktrace.h
    rm -f inc/**/timer.h
    rm -f inc/**/string_utils.h
    rm -f inc/azure_c_shared_utility/stdint_ce6.h
    rm -f inc/azure_c_shared_utility/tlsio_cyclonessl_socket.h
    rm -f inc/azure_c_shared_utility/tlsio_mbedtls.h
    rm -f inc/azure_c_shared_utility/tlsio_openssl.h
    rm -f inc/azure_c_shared_utility/tlsio_schannel.h
    rm -f inc/azure_c_shared_utility/tlsio_wolfssl.h
    rm -f inc/azure_c_shared_utility/tlsio_bearssl.h
    rm -f inc/azure_c_shared_utility/x509_openssl.h
    rm -f inc/azure_c_shared_utility/x509_schannel.h


    # Assemble the module.modulemap file
    pushd inc > /dev/null
    echo "module AzureIoTUtility-Clone [system][extern_c] {" > module.modulemap
    quote_thing='\"'
    for filename in azure_c_shared_utility/*.h; do
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
    'inc/**/*.h',
    'src/*.c',
    'pal/tlsio_options.c',
    'pal/agenttime.c',
    'pal/ios-osx/*.c',
    'adapters/lock_pthreads.c',
    'adapters/threadapi_pthreads.c',
    'adapters/linux_time.c',
    'adapters/tickcounter_linux.c',
    'adapters/uniqueid_linux.c',
    'adapters/httpapi_compact.c',
    'adapters/threadapi_pthreads.c'

  s.public_header_files = 'inc/**/*.h'#'inc/azure_c_shared_utility/*.h'

  # The header_mappings_dir is a location where the header files directory structure
  # is preserved.  If not provided the headers files are flattened.
  s.header_mappings_dir = 'inc/'

  # SWIFT_INCLUDE_PATHS tells Swift where to look for module.modulemap
  s.xcconfig = {
    # This is needed by all pods that depend on Protobuf:
    "GCC_PREPROCESSOR_DEFINITIONS" => "$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1",
    # This is needed by all pods that depend on gRPC-RxLibrary:
    "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES",
    
    'USE_HEADERMAP' => 'NO',
    'USER_HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/AzureIoTUtility-Clone/inc"',
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/AzureIoTUtility-Clone/inc/"',
    'ALWAYS_SEARCH_USER_PATHS' => 'NO'
  }

  s.dependency 'AzureMacroUtils', ENV['macro_util_ver'] 
  s.dependency 'AzureuMockC', ENV['umock_ver']

end
