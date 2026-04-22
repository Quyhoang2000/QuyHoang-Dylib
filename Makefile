# Khai báo kiến trúc duy nhất cho 6s Plus
ARCHS = arm64
# Đặt mục tiêu iOS thấp một chút để tăng khả năng tương thích
TARGET = iphone:clang:latest:12.0
# Tắt debug để file .deb nhẹ hơn
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuyHoangFxy
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit WebKit QuartzCore
# Sử dụng chuẩn C++11 để fix lỗi Code 8 (HTML dài)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -std=c++11

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
