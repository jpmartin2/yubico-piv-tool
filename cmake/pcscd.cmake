set(BACKEND_ARG_CHECK "check")
set(BACKEND_ARG_PCSC "pcsc")
set(BACKEND_ARG_MAC "macscard")
set(BACKEND_ARG_WIN "winscard")

macro (find_pcscd)
    if(VERBOSE_CMAKE)
        message("BACKEND: ${BACKEND}")
    endif(VERBOSE_CMAKE)

    if(${BACKEND} STREQUAL ${BACKEND_ARG_CHECK} OR ${BACKEND} STREQUAL ${BACKEND_ARG_PCSC})
            pkg_check_modules(PCSC REQUIRED libpcsclite)
            if(PCSC_FOUND)
                if(VERBOSE_CMAKE)
                    message("PCSC_FOUND: ${PCSC_FOUND}")
                    #message("PCSC_LIBRARIES: ${PCSC_LIBRARIES}")
                    message("PCSC_LIBRARY_DIRS: ${PCSC_LIBRARY_DIRS}")
                    message("PCSC_LDFLAGS: ${PCSC_LDFLAGS}")
                    message("PCSC_LDFLAGS_OTHER: ${PCSC_LDFLAGS_OTHER}")
                    message("PCSC_INCLUDE_DIRS: ${PCSC_INCLUDE_DIRS}")
                    #message("PCSC_CFLAGS: ${PCSC_CFLAGS}")
                    message("PCSC_CFLAGS_OTHER: ${PCSC_CFLAGS_OTHER}")
                    message("PCSC_VERSION: ${PCSC_VERSION}")
                    message("PCSC_INCLUDEDIR: ${PCSC_INCLUDEDIR}")
                    message("PCSC_LIBDIR: ${PCSC_LIBDIR}")
                endif(VERBOSE_CMAKE)
            else(PCSC_FOUND)
                message (FATAL_ERROR "pcscd not found. Aborting...")
            endif(PCSC_FOUND)

            set(BACKEND ${BACKEND_ARG_PCSC})
    endif()

    if(${BACKEND} STREQUAL ${BACKEND_ARG_CHECK})
        find_file(PCSC_WINSCARD_H_FOUND PCSC/winscard.h)
        find_file(WINSCARD_H_FOUND winscard.h)
        if(PCSC_WINSCARD_H_FOUND)
            set(BACKEND ${BACKEND_ARG_MAC})
            set(HAVE_PCSC_WINSCARD_H ON)
            message("Using ${BACKEND_ARG_MAC}")
        elseif(WINSCARD_H_FOUND)
            set(BACKEND ${BACKEND_ARG_WIN})
            message("Using ${BACKEND_ARG_WIN}")
        endif()
    endif(${BACKEND} STREQUAL ${BACKEND_ARG_CHECK})
    message("BACKEND: ${BACKEND}")

    if(${BACKEND} STREQUAL ${BACKEND_ARG_WIN})
        message("Checking for winscard with Windows linkage")
        find_file(WINSCARD_H_FOUND winscard.h)
        set(PCSC_WIN_LIBS "-lwinscard")
    endif(${BACKEND} STREQUAL ${BACKEND_ARG_WIN})

    if(${BACKEND} STREQUAL ${BACKEND_ARG_MAC})
        message("Checking for PCSC with Mac linkage")
        find_file(PCSC_WINSCARD_H_FOUND PCSC/winscard.h)
        set(PCSC_MACOSX_LIBS "-Wl,-framework -Wl,PCSC")
    endif(${BACKEND} STREQUAL ${BACKEND_ARG_MAC})

    if(${PCSC_LIB} NOT STREQUAL "")
        message("Checking for PCSC with custom lib")
        find_file(PCSC_WINSCARD_H_FOUND PCSC/winscard.h)
        if(${PCSC_DIR} NOT STREQUAL "")
            set(PCSC_CUSTOM_LIBS "-Wl,-L${PCSC_DIR} -Wl,-l${PCSC_LIB} -Wl,-rpath,${PCSC_DIR}")
        else(${PCSC_DIR} NOT STREQUAL "")
            set(PCSC_CUSTOM_LIBS "-Wl,-l${PCSC_LIB}")
        endif(${PCSC_DIR} NOT STREQUAL "")
        set(CMAKE_C_FLAGS ${PCSC_CFLAGS} ${CMAKE_C_FLAGS})
        set(PCSC_LIBRARIES ${PCSC_LIBRARIES} ${PCSC_CUSTOM_LIBS})
        unset(PCSC_MACOSX_LIBS)
        unset(PCSC_WIN_LIBS)
        unset(PCSC_LIBS)
    endif(${PCSC_LIB} NOT STREQUAL "")

    string(REPLACE ";" " " PCSC_CFLAGS "${PCSC_CFLAGS}")

    if(${BACKEND} STREQUAL ${BACKEND_ARG_PCSC} OR
            ${BACKEND} STREQUAL ${BACKEND_ARG_WIN} OR
            ${BACKEND} STREQUAL ${BACKEND_ARG_MAC} OR
            ${PCSC_LIB} NOT STREQUAL "")
        set(BACKEND_PCSC ON)
    else()
        message (FATAL_ERROR "cannot find PCSC library")
    endif()

    message("PCSC_LIBRARIES: ${PCSC_LIBRARIES}")
    message("PCSC_CFLAGS: ${PCSC_CFLAGS}")
    message("BACKEND_PCSC: ${BACKEND_PCSC}")
    message("HAVE_PCSC_WINSCARD_H: ${HAVE_PCSC_WINSCARD_H}")

    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${PCSC_CFLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${PCSC_CFLAGS}")
    link_directories(${PCSC_LIBRARY_DIRS})
    include_directories(${PCSC_INCLUDE_DIRS})
endmacro()