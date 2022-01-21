{
  'targets': [{
    'target_name': 'unit_test',
    'type': 'executable',

    'include_dirs': [
          '../../include/core/',
          '../../include/util/',
          '$(ANSDK_DIR)/googletest/googletest/include',
          '$(ANSDK_DIR)/googletest/googlemock/include',
          '$(ANSDK_DIR)/opentelemetry/include/',

          '$(ANSDK_DIR)/apache-log4cxx/0.11.0/include',
          '$(ANSDK_DIR)/apr/1.7.0/include',
          '$(ANSDK_DIR)/apr-util/1.6.1/include',
          '$(ANSDK_DIR)/boost/1.75.0/include',
        ],

    'sources': [
      'unit_test.cpp',
      'ScopedSpan_test.cpp',
      'ServerSpan_test.cpp',
      'SdkWrapper_test.cpp',
      'SdkUtils_test.cpp',
      'WSAgent_test.cpp',
      'AgentCore_test.cpp',
      #'RequestProcessingEngine_test.cpp',
      #'SpanNamer_test.cpp',
      'integration_test.cpp',
    ],

    'conditions': [
      ['OS=="linux"', {
        'cflags': [
          '-Wall -pthread -std=c++11',
        ],

        'libraries': [
          # TODO: Following is the sdk library path of the agent. Replace with the actual library to be tested.
          '$(APPD_SDK_LIB_DIR)/lib/libappdynamics_native_sdk.so',
          '$(ANSDK_DIR)/googletest/lib/libgmock.a',
          '$(ANSDK_DIR)/googletest/lib/libgmock_main.a',
          '$(ANSDK_DIR)/googletest/lib/libgtest.a',
          '$(ANSDK_DIR)/googletest/lib/libgtest_main.a',
          '$(ANSDK_DIR)/boost/1.75.0/lib/libboost_filesystem.a',
          '$(ANSDK_DIR)/boost/1.75.0/lib/libboost_system.a',
          '$(ANSDK_DIR)/apache-log4cxx/0.11.0/lib/liblog4cxx.a',
          '$(ANSDK_DIR)/apr/1.7.0/lib/libapr-1.a',
          '$(ANSDK_DIR)/apr-util/1.6.1/lib/libaprutil-1.a',
          '$(ANSDK_DIR)/expat/2.3.0/lib/libexpat.a',
          '$(ANSDK_DIR)/opentelemetry/lib/libopentelemetry_common.so',
          '$(ANSDK_DIR)/opentelemetry/lib/libopentelemetry_resources.so',
          '$(ANSDK_DIR)/opentelemetry/lib/libopentelemetry_trace.so',
          '$(ANSDK_DIR)/opentelemetry/lib/libopentelemetry_exporter_ostream_span.so',
          '$(ANSDK_DIR)/opentelemetry/lib/libopentelemetry_exporter_otprotocol.so',
       ],

        'ldflags': [
          '-lpthread',
          #'-lgtest_main',
        ],
      }],
    ]
  }]
}
