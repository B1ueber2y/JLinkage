cmake_minimum_required(VERSION 3.17)
project(JLinkage VERSION 1.0.0)

# Set variables
set(LIBRARY_NAME   ${PROJECT_NAME})
set(LIBRARY_FOLDER ${PROJECT_NAME})
include(${PROJECT_SOURCE_DIR}/cmake/SetEnv.cmake)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 9.1)
    message(FATAL_ERROR "GCC version needs to be at least 9.1")
endif()

add_subdirectory(${LIBRARY_FOLDER})

# # Compilation options
# if(MSVC)
# 	target_compile_options(${LIBRARY_NAME} PRIVATE /bigobj /fp:fast)
# else()
# 	target_compile_options(${LIBRARY_NAME} PRIVATE
# 		-march=native -ffast-math -fno-unsafe-math-optimizations
# 		-funroll-loops -fprefetch-loop-arrays -funswitch-loops
# 	 	-Wall -fPIC -Wno-ignored-optimization-argument)
# endif()
