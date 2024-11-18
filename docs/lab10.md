# Lab 10: Device Trees

**Question**: What is the purpose of a device tree?

**Answer**: A device tree is a data structure that tells a (Linux) system what hardware is being used without having to hardcode those details. For our purposes, this'll allow us to specify memory addresses being used, register locations, and more without having to go into the FPGA's Linux system and hard-define all that information.