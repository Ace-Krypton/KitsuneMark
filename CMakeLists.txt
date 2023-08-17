cmake_minimum_required(VERSION 3.16)

project(KitsuneMark VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(kitsune-mark
    src/main.cpp
)

qt_add_qml_module(kitsune-mark
    URI KitsuneMark
    VERSION 1.0
    QML_FILES qml/MainPage.qml qml/About.qml qml/Main.qml qml/Utils.qml qml/Warning.qml qml/translate.qm
    SOURCES include/benchmark.hpp src/benchmark.cpp
    SOURCES include/builder.hpp src/builder.cpp
    SOURCES include/system.hpp src/system.cpp
    RESOURCES img.qrc img/angel.jpg img/default.jpg img/aria.jpg img/reki.png img/hannya.png img/warning.png img/info.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(kitsune-mark PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.kitsune-mark
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(kitsune-mark
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS kitsune-mark
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
