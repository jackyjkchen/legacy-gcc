obj-m += ia32_aout.o
KERNEL_DIR = /lib/modules/$(shell uname -r)

all:
	make -C $(KERNEL_DIR)/build M=$(PWD) modules

install: all
	mkdir -p $(KERNEL_DIR)/extra/
	install -m 644 ia32_aout.ko $(KERNEL_DIR)/extra/
	/sbin/depmod -a

clean:
	make -C $(KERNEL_DIR)/build M=$(PWD) clean
