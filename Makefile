export PREFIX = /usr
TARGET := iphone:clang:latest:11.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AdBlocker

AdBlocker_FILES = Tweak-Safe.x
AdBlocker_CFLAGS = -fobjc-arc
AdBlocker_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
