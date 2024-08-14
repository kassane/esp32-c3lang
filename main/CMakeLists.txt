set(DEPS pthread driver)

idf_component_register(SRCS "placeholder.c"
    INCLUDE_DIRS "."
    PRIV_REQUIRES "${DEPS}"
)

# Based on zig-esp-idf-sample project

set(EXT "tar.xz")
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(TARGET_ARCH "x86_64")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86")
        set(TARGET_ARCH "x86")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "aarch64")
        set(TARGET_ARCH "aarch64")
    else()
        message(FATAL_ERROR "linux: Unsupported architecture")
    endif()
    set(TARGET_PLATFORM "linux-musl")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(TARGET_ARCH "x86_64")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86")
        set(TARGET_ARCH "x86")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "aarch64")
        set(TARGET_ARCH "aarch64")
    else()
        message(FATAL_ERROR "windows: Unsupported architecture")
    endif()
    set(TARGET_PLATFORM "windows-gnu")
    set(EXT "zip")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(TARGET_ARCH "x86_64")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
        set(TARGET_ARCH "aarch64")
    else()
        message(FATAL_ERROR "macos: Unsupported architecture")
    endif()
    set(TARGET_PLATFORM "macos")
else()
    message(FATAL_ERROR "Unsupported platform")
endif()

if(NOT EXISTS "${CMAKE_BINARY_DIR}/lib/c3")
    file(DOWNLOAD "https://github.com/kassane/esp32-c3lang/releases/download/v0.0.0/c3c-espressif-${TARGET_ARCH}-${TARGET_PLATFORM}.${EXT}"
        "${CMAKE_BINARY_DIR}/c3c.${EXT}")

    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        execute_process(
            COMMAND powershell -Command "Expand-Archive -Path ${CMAKE_BINARY_DIR}/c3c.${EXT} -DestinationPath ${CMAKE_BINARY_DIR}"
        )
    else()
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xf ${CMAKE_BINARY_DIR}/c3c.${EXT}
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )
    endif()
else()
    message(STATUS "C3c already downloaded. Skipping C3 install.")
endif()

if(CONFIG_IDF_TARGET_ARCH_RISCV)
    # generic
    set(C3_TARGET "elf-riscv32")
elseif(CONFIG_IDF_TARGET_ARCH_XTENSA)
    # generic
    set(C3_TARGET "elf-xtensa")
else()
    message(FATAL_ERROR "Unsupported target ${CONFIG_IDF_TARGET}")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(C3_BUILD_TYPE "-g")
else()
    set(C3_BUILD_TYPE "-Oz")
endif()

add_custom_target(c3_build
    COMMAND ${CMAKE_COMMAND} -E env
    "INCLUDE_DIRS=${include_dirs}"
    ${CMAKE_BINARY_DIR}/c3c
    --no-entry
    --use-stdlib=no
    --link-libc=no
    static-lib
    -o libc3
    app.c3
    wrappers/newlib.c3
    wrappers/idf.c3
    --single-module=yes
    --output-dir ${CMAKE_BINARY_DIR}/lib
    ${C3_BUILD_TYPE}
    --target ${C3_TARGET}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    BYPRODUCTS ${CMAKE_BINARY_DIR}/lib/libc3.a
    VERBATIM)

add_prebuilt_library(c3 ${CMAKE_BINARY_DIR}/lib/libc3.a)
add_dependencies(c3 c3_build)
target_link_libraries(${COMPONENT_LIB} PRIVATE ${CMAKE_BINARY_DIR}/lib/libc3.a)
