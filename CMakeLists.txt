CMAKE_MINIMUM_REQUIRED(VERSION 2.6) #cmake 版本限定
PROJECT(cuda_tutorial)  #工程名称

### FIND THE OS
set(CMAKE_BUILD_TYPE Release) # 等同于 cmake -DCMAKE_BUILD_TYPE=release


# C++ additional flags

# list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
# list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")

set(OpenCV_DIR /usr/local/opencv31/share/OpenCV)
find_package(OpenCV)
find_package(CUDA 8.0 QUIET)


set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} 
        -gencode arch=compute_60,code=sm_60 
        -w  #no warning
        -Xcompiler -fPIC )

set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -std=c++11 )
# add_definitions(-std=c++11 )


#set(CMAKE_VERBOSE_MAKEFILE 1)

#INCLUDE


message("crazylog--------CUDA_INCLUDE_DIRS=${CUDA_INCLUDE_DIRS}")
set(CUDA_COMMON_INC "/usr/local/cuda-8.0/samples/common/inc")

LIST(APPEND INCLUDE_DIR

            ${CMAKE_SOURCE_DIR}/include
            ${CMAKE_SOURCE_DIR}/include/libmatrix

            ${CUDA_INCLUDE_DIRS}
            ${GFLAGS_INCLUDE_DIR}
            ${GLOG_INCLUDE_DIR}
            ${CUDA_COMMON_INC}

            ${OpenCV_INCLUDE_DIRS}

            )
include_directories(${INCLUDE_DIR})
#LIBRARY

message("crazylog--------CUDA_CUDART_LIBRARY=${CUDA_CUDART_LIBRARY}")
message("crazylog--------CUDA_CUBLAS_LIBRARIES=${CUDA_CUBLAS_LIBRARIES}")
message("crazylog--------CUDA_CUBLAS_LIBRARIES=${CUDA_CUBLAS_LIBRARIES}")
link_directories(${})
LIST(APPEND LIBRARIES
        ${CUDA_CUBLAS_LIBRARIES}
        ${CUDNN_LIBRARY}
        ${CUDA_CUDART_LIBRARY}


        ${OpenCV_LIBS}
        ${GLOG_LIBRARY}
        ${GFLAGS_LIBRARY}

        )





file(GLOB_RECURSE Cuda_SRCS "${PROJECT_SOURCE_DIR}/src/*.cu")
CUDA_COMPILE(cuda_objs ${Cuda_SRCS})

file(GLOB_RECURSE C_SRCS "${PROJECT_SOURCE_DIR}/src/*.c")
file(GLOB_RECURSE CPP_SRCS "${PROJECT_SOURCE_DIR}/src/*.cpp")

file(GLOB_RECURSE Mains_cu "${PROJECT_SOURCE_DIR}/Main/*.cu")
file(GLOB_RECURSE Mains_cpp "${PROJECT_SOURCE_DIR}/Main/*.cpp")

#cuda mains
set(toExe_SRCS ${CPP_SRCS} ${C_SRCS} ${Cuda_SRCS})

foreach(source ${Mains_cu})
    get_filename_component(SourceName ${source} NAME_WE)
    set(ExeName ${SourceName})
    # target
    set(SRCS_ALL ${source} ${toExe_SRCS})
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

#cpp mains

foreach(source ${Mains_cpp})
    get_filename_component(SourceName ${source} NAME_WE)
    set(ExeName ${SourceName})
    # target
    set(SRCS_ALL ${source} ${toExe_SRCS})

    add_executable(${ExeName} ${SRCS_ALL})

    # link library
    target_link_libraries(${ExeName}

            ${cuda_objs}
            ${LIBRARIES}

            )
    set_target_properties(${ExeName} PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin"
            LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin"
            RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
endforeach(source)