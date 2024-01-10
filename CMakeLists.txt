cmake_minimum_required(VERSION 3.10)
project("Terminal FPS"
    DESCRIPTION "A simple first-person shooter that runs in your terminal."
    VERSION 0.0.0
    HOMEPAGE_URL "https://github.com/glektarssza/terminal-fps"
    LANGUAGES CXX)

if(CMAKE_MODULE_PATH)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules/")
else()
    set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules/")
endif()

set(TERMINAL_FPS_SOURCES "./src/main.cpp")
set(TERMINAL_FPS_INCLUDE_DIRS "./include/")
set(TERMINAL_FPS_DEFINES "PROJECT_NAME=\"${PROJECT_NAME}\"" "PROJECT_VERSION=\"${PROJECT_VERSION}\"")

if($<CONFIG:Debug>)
    list(APPEND TERMINAL_FPS_DEFINES "DEBUG")
endif()

add_executable(terminal-fps ${TERMINAL_FPS_SOURCES})
target_include_directories(terminal-fps PRIVATE ${TERMINAL_FPS_INCLUDE_DIRS})
target_compile_definitions(terminal-fps PRIVATE ${TERMINAL_FPS_DEFINES})
target_compile_features(terminal-fps PRIVATE cxx_std_20)

install(TARGETS terminal-fps)
