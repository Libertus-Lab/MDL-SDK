#*****************************************************************************
# Copyright (c) 2022-2023, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#*****************************************************************************

function(FIND_OPENIMAGEIO_EXT)

    if(${CMAKE_VERSION} VERSION_LESS "3.19.0")
        find_package(OpenImageIO)
        if(${OpenImageIO_FOUND})
            if(${OpenImageIO_VERSION} VERSION_LESS "2.4")
                set(OpenImageIO_FOUND OFF)
                message(WARNING "Found OpenImageIO version ${OpenImageIO_VERSION} is too old.")
            elseif(${OpenImageIO_VERSION} VERSION_GREATER_EQUAL "3.0")
                set(OpenImageIO_FOUND OFF)
                message(WARNING "Found OpenImageIO version ${OpenImageIO_VERSION} is too new.")
            endif()
        endif()
    else()
        find_package(OpenImageIO 2.4...<3.0)
    endif()

    # See https://github.com/microsoft/vcpkg/issues/29284
    find_package(OpenEXR)

    # Misuse OpenImageIO version to distinguish older vcpkg versions (e.g. 42f74e3db
    # plus patch) from newer vcpkg versions (e.g. 3640e7cb1).
    if(${OpenImageIO_FOUND} AND (${OpenImageIO_VERSION} VERSION_LESS "2.4.5.0"))
        # Needed by OpenImageIO::OpenImageIO target in older vcpkg versions
        find_package(TIFF)
        find_package(liblzma CONFIG)
    endif()

    if(NOT ${OpenImageIO_FOUND} OR NOT ${OpenEXR_FOUND})

        message(STATUS "OpenImageIO_FOUND: ${OpenImageIO_FOUND}")
        message(STATUS "OpenImageIO_DIR: ${OpenImageIO_DIR}")
        message(STATUS "OpenImageIO_INCLUDE_DIR: ${OpenImageIO_INCLUDE_DIR}")
        message(STATUS "OpenImageIO_LIB_DIR: ${OpenImageIO_LIB_DIR}")
        message(STATUS "OpenEXR_FOUND: ${OpenEXR_FOUND}")
        message(WARNING "The dependency \"OpenImageIO\" could not be resolved. Please specify "
            "'CMAKE_TOOLCHAIN_FILE'.")
        set(MDL_OPENIMAGEIO_FOUND OFF CACHE INTERNAL "")

    else()

        # store paths that are later used in the add_openimageio.cmake
        set(MDL_DEPENDENCY_OPENIMAGEIO_INCLUDE ${OpenImageIO_INCLUDE_DIR} CACHE INTERNAL
            "OpenImageIO header directory")
        set(MDL_DEPENDENCY_OPENIMAGEIO_LIB ${OpenImageIO_LIB_DIR} CACHE INTERNAL
            "OpenImageIO library directory")
        set(MDL_DEPENDENCY_OPENIMAGEIO_VERSION ${OpenImageIO_VERSION} CACHE INTERNAL
            "OpenImageIO version")
        set(MDL_OPENIMAGEIO_FOUND ON CACHE INTERNAL "")

        if(MDL_LOG_DEPENDENCIES)
            message(STATUS "[INFO] MDL_DEPENDENCY_OPENIMAGEIO_INCLUDE:   ${MDL_DEPENDENCY_OPENIMAGEIO_INCLUDE}")
            message(STATUS "[INFO] MDL_DEPENDENCY_OPENIMAGEIO_LIB:       ${MDL_DEPENDENCY_OPENIMAGEIO_LIB}")
            message(STATUS "[INFO] MDL_DEPENDENCY_OPENIMAGEIO_VERSION:   ${MDL_DEPENDENCY_OPENIMAGEIO_VERSION}")
        endif()

    endif()

endfunction()
