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
