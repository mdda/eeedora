KERNEL_VERSION	:= $(shell uname -r)
KERNEL_DIR	:= /lib/modules/$(KERNEL_VERSION)/build

INSTALL_MOD_DIR	:= drivers/acpi

PWD		:= $(shell pwd)

obj-m		:= asus_acpi_eee.o

all: asus_acpi_eee

asus_acpi_eee:
	@echo "Building ASUS ACPI driver for the Eee..."
	@(cd $(KERNEL_DIR) && make -C $(KERNEL_DIR) SUBDIRS=$(PWD) modules)

#install:
#	@echo "Installing ASUS ACPI driver..."
#	@(cd $(KERNEL_DIR) && make -C $(KERNEL_DIR) SUBDIRS=$(PWD) INSTALL_MOD_DIR=$(INSTALL_MOD_DIR) modules_install)
#	depmod -ae

clean:
	-rm -f *.o *.ko .*.cmd .*.flags *.mod.c Module.symvers
	-rm -rf .tmp_versions

