TEMPLATE = app
TARGET = CoffeeWarmer

QT += quick qml sql charts bluetooth
CONFIG += c++14

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../CoffeeWarmerCore/release/ -lCoffeeWarmerCore
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../CoffeeWarmerCore/debug/ -lCoffeeWarmerCore
else:unix: LIBS += -L$$OUT_PWD/../CoffeeWarmerCore/ -lCoffeeWarmerCore

INCLUDEPATH += $$PWD/../CoffeeWarmerCore
DEPENDPATH += $$PWD/../CoffeeWarmerCore

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

