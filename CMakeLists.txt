cmake_minimum_required(VERSION 3.20)

project(SLViewer)

set(CMAKE_AUTOMOC TRUE)
set(CMAKE_AUTORCC TRUE)
set(CMAKE_AUTOUIC TRUE)
set(EXPORT_COMPILE_COMMANDS TRUE)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_BUILD_TYPE Debug)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

#ros2
#find_package(ament_cmake REQUIRED)
#find_package(rclcpp REQUIRED)
#find_package(rviz2 REQUIRED)

find_package(Qt5 REQUIRED Core Gui Qml Quick Widgets QuickControls2 WebEngine Charts)
find_package(SLCamera REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(OpenCV 4.5.5 REQUIRED)
find_package(Boost 1.74.0 REQUIRED)
find_package(VTK 9.2 REQUIRED)
find_package(PCL 1.12.1 REQUIRED)

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

link_directories(${CMAKE_CURRENT_SOURCE_DIR}/ui/pulugins/calibrationHandEye/thirdParty/aubo/lib/lib64/aubocontroller)

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
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Widgets
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::WebEngine
    Qt5::Charts
    auborobotcontroller
    #${rclcpp_LIBRARIES}
    #${rviz2_LIBRARIES}
)

vtk_module_autoinit(
  TARGETS ${PROJECT_NAME}
  MODULES ${VTK_LIBRARIES}
)
