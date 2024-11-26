# borrowed from PoseLib

# Target
add_library(${LIBRARY_NAME}
  ${SOURCES}
  ${HEADERS_PUBLIC}
  ${HEADERS_PRIVATE}
  )

# Alias:
#   - JLinkage::JLinkage alias of JLinkage
add_library(${PROJECT_NAME}::${LIBRARY_NAME} ALIAS ${LIBRARY_NAME})

# C++17
target_compile_features(${LIBRARY_NAME} PUBLIC cxx_std_17)

# Add definitions for targets
# Values:
#   - Debug  : -DJLINKAGE_DEBUG=1
#   - Release: -DJLINKAGE_DEBUG=0
#   - others : -DJLINKAGE_DEBUG=0
target_compile_definitions(${LIBRARY_NAME} PUBLIC
  "${PROJECT_NAME_UPPERCASE}_DEBUG=$<CONFIG:Debug>")

# Global includes. Used by all targets
# Note:
#   - allow includes relative to source root directory: #include "type.h".
#   - headers can also be included with: #include <JLinkage/type.h>
#   - add headers location: ${CMAKE_CURRENT_BINARY_DIR}/generated_headers
target_include_directories(
  ${LIBRARY_NAME}
    PUBLIC
      "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
      "$<BUILD_INTERFACE:${GENERATED_HEADERS_DIR}>"
      "$<INSTALL_INTERFACE:.>"
)

# Targets:
#   - <prefix>/lib/libJLinkage.a
#   - header location after install: <prefix>/JLinkage/jlinkage.h
#   - headers can be included by C++ code `#include <JLinkage/jlinkage.h>`
install(
    TARGETS              "${LIBRARY_NAME}"
    EXPORT               "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION  "${CMAKE_INSTALL_LIBDIR}"
    ARCHIVE DESTINATION  "${CMAKE_INSTALL_LIBDIR}"
    RUNTIME DESTINATION  "${CMAKE_INSTALL_BINDIR}"
    INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

# Generate 'JLinkage/jlinkage.h' automatically from public headers
foreach(file ${HEADERS_PUBLIC})
  # get basename of each header file
  get_filename_component(basename ${file} NAME)

  # append '#include <...>' to the 'jlinkage.h' file
  # ToDo: set(...) creates a list separated with ';'. Find a different way.
  set(LIB_INCLUDES_STRING ${LIB_INCLUDES_STRING} "#include <JLinkage/${file}>\n")
endforeach(file)
string(REPLACE ";" "" LIB_INCLUDES_STRING "${LIB_INCLUDES_STRING}")
configure_file(${PROJECT_NAME_LOWERCASE}.h.in
  "${GENERATED_HEADERS_DIR}/JLinkage/jlinkage.h" @ONLY)


# Headers:
#   - JLinkage/*.h -> <prefix>/include/JLinkage/*.h
foreach ( file ${HEADERS_PUBLIC} )
    get_filename_component( dir ${file} DIRECTORY )
    install( FILES ${file} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBRARY_FOLDER}/${dir}" )
endforeach()
install( FILES "${GENERATED_HEADERS_DIR}/JLinkage/jlinkage.h" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBRARY_FOLDER}")

# Headers:
#   - generated_headers/JLinkage/version.h -> <prefix>/include/JLinkage/version.h
install(
    FILES       "${GENERATED_HEADERS_DIR}/${LIBRARY_FOLDER}/version.h"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBRARY_FOLDER}"
)

# Config
#   - <prefix>/lib/cmake/JLinkage/JLinkageConfig.cmake
#   - <prefix>/lib/cmake/JLinkage/JLinkageConfigVersion.cmake
install(
    FILES       "${PROJECT_CONFIG_FILE}"
                "${VERSION_CONFIG_FILE}"
    DESTINATION "${CONFIG_INSTALL_DIR}"
)

# Config
#   - <prefix>/lib/cmake/JLinkage/JLinkageTargets.cmake
install(
  EXPORT      "${TARGETS_EXPORT_NAME}"
  FILE        "${PROJECT_NAME}Targets.cmake"
  DESTINATION "${CONFIG_INSTALL_DIR}"
  NAMESPACE   "${PROJECT_NAME}::"
)
