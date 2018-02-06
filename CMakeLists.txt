CMAKE_MINIMUM_REQUIRED(VERSION 2.6) #cmake 版本限定
PROJECT(cuda_tutorial)  #工程名称

### FIND THE OS
set(CMAKE_BUILD_TYPE Release) # 等同于 cmake -DCMAKE_BUILD_TYPE=release


### FLAGS
# Turn on C++11
add_definitions(-std=c++11 )

# C++ additional flags
set(OP_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp -Wpedantic -Wall -Wextra -Wfatal-errors")

set(CUDA_ARCH Pascal CACHE STRING "Select target NVIDIA GPU achitecture.")


list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")


# find_package(GFlags)
# find_package(Glog)


set(OpenCV_DIR /usr/local/opencv31/share/OpenCV)
find_package(OpenCV)


include(cmake/Cuda.cmake)


#set(CMAKE_BUILD_TYPE Release) # 等同于 cmake -DCMAKE_BUILD_TYPE=release
#set(CMAKE_VERBOSE_MAKEFILE 1)

#INCLUDE

LIST(APPEND INCLUDE_DIR

            ${CMAKE_SOURCE_DIR}/include


            ${CUDA_INCLUDE_DIRS}
            ${GFLAGS_INCLUDE_DIR}
            ${GLOG_INCLUDE_DIR}

            ${OpenCV_INCLUDE_DIRS}

            )
include_directories(${INCLUDE_DIR})
#LIBRARY

message("crazylog--------CUDA_CUDART_LIBRARY=${CUDA_CUDART_LIBRARY}")
message("crazylog--------CUDA_CUBLAS_LIBRARIES=${CUDA_CUBLAS_LIBRARIES}")
message("crazylog--------CUDA_curand_LIBRARY=${CUDA_curand_LIBRARY}")
LIST(APPEND LIBRARIES

        ${CUDNN_LIBRARY}
        ${CUDA_CUDART_LIBRARY}
        ${CUDA_curand_LIBRARY}
        ${CUDA_CUBLAS_LIBRARIES}
        ${OpenCV_LIBS}
        ${GLOG_LIBRARY}
        ${GFLAGS_LIBRARY})



set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -std=c++11")
add_definitions(-std=c++11 )




# file(GLOB_RECURSE CudatoExe_SRCS "${PROJECT_SOURCE_DIR}/src/*.cu")
# CUDA_COMPILE(cuda_objs ${CudatoExe_SRCS})


file(GLOB_RECURSE CPPtoExe_SRCS "${PROJECT_SOURCE_DIR}/src/*.c")
file(GLOB_RECURSE ForExe_SRCS "${PROJECT_SOURCE_DIR}/Main/*.cu")


set(toExe_SRCS ${CPPtoExe_SRCS} ${CudatoExe_SRCS})

foreach(source ${ForExe_SRCS})
    get_filename_component(SourceName ${source} NAME_WE)
    set(ExeName ${SourceName})
    # target
    set(SRCS_ALL ${source} ${toExe_SRCS})

#     add_executable(${ExeName} ${SRCS_ALL})
    cuda_add_executable(${ExeName} ${SRCS_ALL})

    # link library
    target_link_libraries(${ExeName}
            ${LIBRARIES}

            )
    set_target_properties(${ExeName} PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin"
            LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin"
            RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
endforeach(source)

