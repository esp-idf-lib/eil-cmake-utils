# Prevent double inclusion
if(COMMAND eil_check_idf_features)
    return()
endif()


#[=[@doc

#]=]

macro(eil_check_idf_features)
    message(DEBUG "eil_check_idf_features")
    message(DEBUG "Running IDF feature checks for version ${IDF_VERSION}")
    if(NOT DEFINED IDF_VERSION)
        message(FATAL_ERROR "IDF_VERSION is not defined. Are you running this inside an ESP-IDF environment?")
    endif()

    # Definition of features. implement eil_check_idf_* below
    set(features has_esp_drivers)
    foreach(feat ${features})
        set(macro_name "eil_check_idf_${feat}")
        if(COMMAND ${macro_name})
            cmake_language(CALL ${macro_name})
        else()
            message(FATAL, "BUG: Undefined call to ${macro_name}")
        endif()
    endforeach()
endmacro()

#[=[@doc

Checks if the esp-idf version supports `esp_driver_*` components. Exports
a boolean variable,`IDF_HAS_ESP_DRIVERS`.

Before version 5.3, the conponent for peripherials was a monolithic `driver`.
Since version 5.3, each driver, such as `gpio` has its own component, i.e.,
`esp_driver_gpio`.

When a source includes `driver/gpio.h":

```cmake
eil_check_idf_has_esp_drivers()

if(${IDF_HAS_ESP_DRIVERS)
    set(REQUIRED_COMPONENTS esp_driver_gpio freertos log esp_timer)
else()
    set(REQUIRED_COMPONENTS driver freertos log esp_timer)
endif()
```

When `IDF_HAS_ESP_DRIVERS` is true, add `esp_driver_*` to REQUIRES or
PRIV_REQUIRES when calling idf_component_register().

When false, add `driver` to REQUIRES or PRIV_REQUIRES.

See Migration from 5.2 to 5.3 for more details.
https://docs.espressif.com/projects/esp-idf/en/release-v6.0/esp32/migration-guides/release-5.x/5.3/peripherals.html

REQUIRES should be set to all components whose header files are
`#included` from the public header files of this component.

PRIV_REQUIRES should be set to all components whose header files are
`#included` from any source files in this component, unless already listed
in REQUIRES.

#]=]
macro(eil_check_idf_has_esp_drivers)
    # Check for esp_driver_* support (ESP-IDF ≥ 5.3)
    set(IDF_HAS_ESP_DRIVERS FALSE)
    if((IDF_VERSION_MAJOR GREATER_EQUAL 6) OR
       (IDF_VERSION_MAJOR EQUAL 5 AND IDF_VERSION_MINOR GREATER_EQUAL 3))
        set(IDF_HAS_ESP_DRIVERS TRUE)
    endif()

    # CACHE store this entry in the cache file rather than keeping it as a
    #       local, temporary variable.
    set(IDF_HAS_ESP_DRIVERS ${IDF_HAS_ESP_DRIVERS} CACHE INTERNAL "esp-idf supports esp_driver_ components")
    message(DEBUG " - IDF_HAS_ESP_DRIVERS: ${IDF_HAS_ESP_DRIVERS}")
endmacro()
