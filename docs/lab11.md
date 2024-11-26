# Lab 11: Platform Device Driver

**Question**: What is the purpose of the platform bus?

**Answer**: The purpose of the platform bus is to connect all the individual platform drivers to the OS so it can tell what devices exist and what resources they have access to.

**Question**: Why is the device driver's compatible property important?

**Answer**: The driver's compatible property is important because it allows the platform device to bind to the driver so long as the platform device has the same compatible property string.

**Question**: What is the probe function's purpose?

**Answer**: The probe function does a variety of things. It allocates memory in our kernel for a container, it remap's a platform device's memory to the allocated kernel virtual addresses, and it attaches the container to the platform device.

**Question**: How does your driver know what memory addresses are associated with your device?

**Answer**: The driver knows what memory addresses are associated with our device via the state container.

**Question**: What are two ways we can write to our device's registers? In other words, what subsystems do we use to write to our registers?

**Answer**: Two ways we can write to our device's registers are through character devices and device attributes.

**Question**: What is the purpose of our struct led_patterns_dev state container?

**Answer**: The purpose of our led_patterns_dev state container is to contain various info about our device - like the device's address, register locations, values, etc. - that we want our driver to interact with / keep track of. This in-between struct also allows for multiple device instantiation, since you'll need a new struct for every new device (which is why the device isn't just hard-bound to the driver). 