cmake_minimum_required(VERSION 3.0)

project(SLViewer)

set(CMAKE_AUTOMOC TRUE)
set(CMAKE_AUTORCC TRUE)
set(CMAKE_AUTOUIC TRUE)
set(EXPORT_COMPILE_COMMANDS TRUE)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_BUILD_TYPE Release)

find_package(SLCamera REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(OpenCV REQUIRED)
find_package(Boost REQUIRED)
find_package(Qt6 REQUIRED Core Gui Qml Quick Widgets Core5Compat QuickControls2 WebEngineQuick)
find_package(VTK REQUIRED)

file(GLOB_RECURSE QML ${CMAKE_CURRENT_SOURCE_DIR}/ui/*.qml)
file(GLOB_RECURSE HEADER ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h ${CMAKE_CURRENT_SOURCE_DIR}/ui/*.h)
file(GLOB_RECURSE SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc ${CMAKE_CURRENT_SOURCE_DIR}/ui/*.cc)
file(GLOB_RECURSE QRC ${CMAKE_CURRENT_SOURCE_DIR}/ui/*.qrc)

source_group("QML" FILES ${QML})
source_group("HEADER" FILES ${HEADER})
source_group("SOURCES" FILES ${SOURCES})
source_group("QRC" FILES ${QRC})

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/ui/pulugins
    ${EIGEN3_INCLUDE_DIRS}
    ${Boost_INCLUDE_DIRS}
    ${SLCamera_INCLUDE_DIRS}
)

add_executable(
    ${PROJECT_NAME}
    ${HEADER}
    ${SOURCES}
    ${QML}
    ${QRC}
    ${CMAKE_CURRENT_SOURCE_DIR}/ui/icon.rc
)

target_link_libraries(
    ${PROJECT_NAME}
    ${VTK_LIBRARIES}
    ${OpenCV_LIBRARIES}
    ${Boost_LIBRARIES}
    ${SLCamera_LIBRARIES}
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Widgets
    Qt6::Quick
    Qt6::Core5Compat
    Qt6::QuickControls2
    Qt6::WebEngineQuick
)

vtk_module_autoinit(
  TARGETS ${PROJECT_NAME}
  MODULES ${VTK_LIBRARIES}
)
