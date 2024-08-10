set(DEPS pthread driver)

idf_component_register(SRCS "placeholder.c"
    INCLUDE_DIRS "."
    PRIV_REQUIRES "${DEPS}"
)

# Based on zig-esp-idf-sample project

if(CONFIG_IDF_TARGET_ARCH_RISCV)
    set(C3_TARGET "elf-riscv32") # generic
    # if(CONFIG_IDF_TARGET_ESP32C6 OR CONFIG_IDF_TARGET_ESP32C5 OR CONFIG_IDF_TARGET_ESP32H2)
    #     set(TARGET_CPU_MODEL "generic_rv32+m+a+c")
    # elseif(CONFIG_IDF_TARGET_ESP32P4)
    #     string(REGEX REPLACE "-none" "-eabihf" C3_TARGET ${C3_TARGET})
    #     set(TARGET_CPU_MODEL "generic_rv32+m+a+c+f")
    # else()
    #     set(TARGET_CPU_MODEL "generic_rv32+m+c")
    # endif()
elseif(CONFIG_IDF_TARGET_ARCH_XTENSA)
    set(C3_TARGET "elf-xtensa") # generic
    # if(CONFIG_IDF_TARGET_ESP32)
    #     set(TARGET_CPU_MODEL "esp32")
    # elseif(CONFIG_IDF_TARGET_ESP32S2)
    #     set(TARGET_CPU_MODEL "esp32s2")
    # else(CONFIG_IDF_TARGET_ESP32S3)
    #     set(TARGET_CPU_MODEL "esp32s3")
    # endif()
else()
    message(FATAL_ERROR "Unsupported target ${CONFIG_IDF_TARGET}")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(C3_BUILD_TYPE "-g0")
else()
    set(C3_BUILD_TYPE "-Oz")
endif()

add_custom_target(c3_build
    COMMAND ${CMAKE_COMMAND} -E env
    "INCLUDE_DIRS=${include_dirs}"
    c3c
    --no-entry
    --use-stdlib=no
    --link-libc=no
    static-lib
    -o libc3
    app.c3
    --output-dir ${CMAKE_BINARY_DIR}/lib
    ${C3_BUILD_TYPE}
    --target ${C3_TARGET}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    BYPRODUCTS ${CMAKE_BINARY_DIR}/lib/libc3.a
    VERBATIM)

add_prebuilt_library(c3 ${CMAKE_BINARY_DIR}/lib/libc3.a)
add_dependencies(c3 c3_build)
target_link_libraries(${COMPONENT_LIB} PRIVATE ${CMAKE_BINARY_DIR}/lib/libc3.a)
