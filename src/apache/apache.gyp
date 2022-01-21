{
    'targets': [
      {
        'target_name': 'mod_appdynamics',
        'type': 'shared_library',
        'dependencies': [],

        'include_dirs': [
          '../../include/core',
          '../../include/util',
          '../../include/apache',
          '$(APACHE24_INCLUDE_DIR)',
          '$(APACHE24_INCLUDE_DIR)/../os/unix',
          '$(ANSDK_DIR)/apr/1.7.0/include/apr-1',
          '$(ANSDK_DIR)/apr-util/1.6.1/include/apr-1',
        ],

        'sources': [
          'ApacheTracing.cpp',
          'ApacheConfig.cpp',
          'ExcludedModules.cpp',
          'ApacheHooks.cpp',
          'HookContainer.cpp',
          'mod_appdynamics.cpp',
        ],

        'conditions': [
          [
            'OS=="linux"', {
              'libraries': [
                '$(APPD_SDK_LIB_DIR)/lib/libappdynamics_native_sdk.so',
              ],

              'library_dirs': [
              ],

              'cflags': [
                '$(COMPILER_FLAGS)',
                '-fvisibility=hidden -fvisibility-inlines-hidden -fPIC',
                '-pipe -Wall -Wp,-O2 -D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector',
                '--param=ssp-buffer-size=4 -mtune=generic -fno-strict-aliasing',
                '-Wno-unused-local-typedefs',
                '-std=c++0x $(ARCH_FLAG)',
            ],

              'ldflags': [
                '$(LINKER_FLAGS)',
                '-Wl,--no-as-needed',
                '-Wl,--exclude-libs=ALL',
              ],
            }
          ],
        ],
      },
      {
        'target_name': 'mod_appdynamics22',
        'type': 'shared_library',
        'dependencies': [
        ],
        'libraries': [
          '$(APPD_SDK_LIB_DIR)/lib/libappdynamics_native_sdk.so',
        ],
        'defines': [
        ],

        'library_dirs': [
        ],

        'cflags': [
          '$(COMPILER_FLAGS)',
          '-fvisibility=hidden -fvisibility-inlines-hidden -fPIC',
          '-pipe -Wall -Wp,-O2 -D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector',
          '--param=ssp-buffer-size=4 -mtune=generic -fno-strict-aliasing',
          '-Wno-unused-local-typedefs',
          '-std=c++0x',
        ],
        'linkflags': [
        ],
        'ldflags': [
          '$(LINKER_FLAGS)',
          '-Wl,--no-as-needed',
          '-Wl,--exclude-libs=ALL',
        ],
        'include_dirs': [
          '../../include/core',
          '../../include/util',
          '../../include/apache',
          '$(APACHE22_INCLUDE_DIR)',
          '$(APACHE22_INCLUDE_DIR)/../os/unix',
          '$(ANSDK_DIR)/apr/1.7.0/include/apr-1',
          '$(ANSDK_DIR)/apr-util/1.6.1/include/apr-1',
        ],
        'sources': [
          'ApacheTracing.cpp',
          'ApacheConfig.cpp',
          'ExcludedModules.cpp',
          'ApacheHooks.cpp',
          'HookContainer.cpp',
          'mod_appdynamics.cpp',
        ],
        'conditions': [
          ['OS=="linux"', {
            'defines': [
            ],
            'include_dirs': [
            ],
          }],
        ],
      }],
}
