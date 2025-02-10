project(rnapp)
cmake_minimum_required(VERSION 3.4.1)
set(CMAKE_SKIP_BUILD_RPATH TRUE)
set(NODE_MODULES "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../node_modules")
set(OH_MODULES "${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules")
set(RNOH_APP_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

set(RNOH_CPP_DIR "${OH_MODULES}/@rnoh/react-native-openharmony/src/main/cpp")
set(RNOH_GENERATED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/generated")
set(CMAKE_ASM_FLAGS "-Wno-error=unused-command-line-argument -Qunused-arguments")
set(CMAKE_CXX_FLAGS "-fstack-protector-strong -Wl,-z,relro,-z,now,-z,noexecstack -s -fPIE -pie")
add_compile_definitions(WITH_HITRACE_SYSTRACE)
set(WITH_HITRACE_SYSTRACE 1) # for other CMakeLists.txt files to use

add_subdirectory("${RNOH_CPP_DIR}" ./rn)

# RNOH_BEGIN: add_package_subdirectories
add_subdirectory("${OH_MODULES}/@react-native-oh-tpl/react-native-gesture-handler/src/main/cpp" ./gesture-handler)
add_subdirectory("${OH_MODULES}/@react-native-oh-tpl/react-native-pager-view/src/main/cpp" ./pager_view)
add_subdirectory("${OH_MODULES}/@react-native-oh-tpl/react-native-reanimated/src/main/cpp" ./reanimated)
add_subdirectory("${OH_MODULES}/@react-native-oh-tpl/react-native-safe-area-context/src/main/cpp" ./safe-area)

# RNOH_END: add_package_subdirectories


file(GLOB GENERATED_CPP_FILES "./generated/*.cpp")

add_library(rnoh_app SHARED
    ${GENERATED_CPP_FILES}
    "./PackageProvider.cpp"
    "${RNOH_CPP_DIR}/RNOHAppNapiBridge.cpp"
)

target_link_libraries(rnoh_app PUBLIC rnoh)

# RNOH_BEGIN: link_packages
target_link_libraries(rnoh_app PUBLIC rnoh_gesture_handler)
target_link_libraries(rnoh_app PUBLIC rnoh_pager_view)
target_link_libraries(rnoh_app PUBLIC rnoh_reanimated)
target_link_libraries(rnoh_app PUBLIC rnoh_safe_area)

# RNOH_END: link_packages

