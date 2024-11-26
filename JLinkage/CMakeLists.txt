# Set SOURCES variable
set(SOURCES
    src/JLinkage.cpp
    src/RandomSampler.cpp
    src/Utilities.cpp
    src/VPCluster.cpp
    src/VPSample.cpp
    src/updator.cpp
)

# Set HEADERS_PUBLIC variable
set(HEADERS_PUBLIC
    include/JLinkage.h
    include/RandomSampler.h
    include/updator.h
    include/VPCluster.h
    include/VPSample.h
)

# Set HEADERS_PRIVATE variable
file(GLOB BM_HEADERS "include/bm/*")
file(GLOB KDTREE_HEADERS "include/kdtree++/*")

set(HEADERS_PRIVATE
    include/PrimitiveFunctions.h
    include/Utilities.h
    include/VPPrimitive.h
    ${BM_HEADERS}
    ${KDTREE_HEADERS}
)

# library configuration
include(${PROJECT_SOURCE_DIR}/cmake/LibraryConfig.cmake)

# for libraries
target_include_directories(${LIBRARY_NAME} PRIVATE ${PROJECT_SOURCE_DIR}/JLinkage/include)
target_link_libraries(${LIBRARY_NAME})

# Build examples
add_executable(main ./main.cpp)
target_link_libraries(main ${PROJECT_NAME})

