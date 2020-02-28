INSTALL_TARGET_PROCESSES = backboardd InCallService TelephonyUtilities

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DoNotAnswerMyMachine

ARCHS = arm64

DoNotAnswerMyMachine_FILES = Tweak.xm
DoNotAnswerMyMachine_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
