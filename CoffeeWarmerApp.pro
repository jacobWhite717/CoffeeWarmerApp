TEMPLATE = subdirs

SUBDIRS += \
    CoffeeWarmerCore \
    CoffeeWarmerGUI

CoffeeWarmerGUI.depends = CoffeeWarmerCore
