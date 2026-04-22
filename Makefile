export THEOS_DEVICE_IP = 127.0.0.1
TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuyHoangElite

QuyHoangElite_FILES = Tweak.xm
QuyHoangElite_CFLAGS = -fobjc-arc
QuyHoangElite_FRAMEWORKS = UIKit WebKit

include $(THEOS_MAKE_PATH)/tweak.mk
