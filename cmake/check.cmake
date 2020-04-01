macro (find_check)
    if(NOT LIBCHECK_FOUND)
        pkg_check_modules(LIBCHECK REQUIRED check)
        if(LIBCHECK_FOUND)
            if(VERBOSE_CMAKE)
                message("LIBCHECK_FOUND: ${LIBCHECK_FOUND}")
                message("LIBCHECK_LIBRARIES: ${LIBCHECK_LIBRARIES}")
                message("LIBCHECK_LIBRARY_DIRS: ${LIBCHECK_LIBRARY_DIRS}")
                message("LIBCHECK_LDFLAGS: ${LIBCHECK_LDFLAGS}")
                message("LIBCHECK_LDFLAGS_OTHER: ${LIBCHECK_LDFLAGS_OTHER}")
                message("LIBCHECK_INCLUDE_DIRS: ${LIBCHECK_INCLUDE_DIRS}")
                message("LIBCHECK_CFLAGS: ${LIBCHECK_CFLAGS}")
                message("LIBCHECK_CFLAGS_OTHER: ${LIBCHECK_CFLAGS_OTHER}")
                message("LIBCHECK_VERSION: ${LIBCHECK_VERSION}")
                message("LIBCHECK_INCLUDEDIR: ${LIBCHECK_INCLUDEDIR}")
                message("LIBCHECK_LIBDIR: ${LIBCHECK_LIBDIR}")
            endif(VERBOSE_CMAKE)
            include_directories(${LIBCHECK_INCLUDE_DIRS})
        else(LIBCHECK_FOUND)
            message (WARNING "check not found...")
        endif(LIBCHECK_FOUND)
    endif(NOT LIBCHECK_FOUND)

endmacro()