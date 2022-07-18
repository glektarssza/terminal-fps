cmake_minimum_required(VERSION 3.10)
project("Terminal FPS" VERSION 0.0.0
    DESCRIPTION "A simple first-person shooter that runs in your terminal."
    HOMEPAGE_URL "https://github.com/glektarssza/terminal-fps"
    LANGUAGES CXX)

if(CMAKE_MODULE_PATH)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules/")
else()
    set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules/")
endif()

set(TERMINAL_FPS_SOURCES "./src/main.cpp")
set(TERMINAL_FPS_INCLUDE_DIRS "./include/")

add_executable(terminal-fps ${TERMINAL_FPS_SOURCES})
target_include_directories(terminal-fps PRIVATE ${TERMINAL_FPS_INCLUDE_DIRS})
target_compile_definitions(terminal-fps PRIVATE "$<$<CONFIG:Debug>:DEBUG>")
target_compile_features(terminal-fps PRIVATE cxx_std_20)
