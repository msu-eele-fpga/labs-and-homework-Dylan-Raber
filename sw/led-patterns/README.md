# README

## Usage

### Command Formatting and Explanation
For my program, the command form uses the following format:
`./led_patterns [-h] [-v] [-p pat1 time1 pat2 time2 ...] [-f filename.txt]`

Each bracket contains a subcommand and their parameters - their uses are listed below:

-h = Shows a help message in the terminal listing the command format and what the subcommands do. Only use by itself.

-v = Displays the LED Patterns and the time it's being displayed on the terminal (in real time). Only use if -p or -f are also in the command, make sure to list -v before them as well.

-p = allows the user to input arguments manually for displaying patterns and their respective timings, will loop until Ctrl+C is pressed. Do not use in conjunction with -f.

- Example: -p 0xFF 2000 0x00 1000 would display the hex code 0xFF (so 11111111) on the LEDs for 2000 milliseconds (2 seconds) 

-f = allows the user to input a text file that will be read for LED patterns and their timings. Do not use in conjunction with -p. 
    Note: the text file must be in the following format: 

`pattern1 time1`

`pattern2 time2`

`pattern3 time3`

(Pattern1 space timing1, linebreak, pattern2 space timing2, linebreak, etc)

### Usage Examples
Some examples of valid and invalid terminal commands are as follows:

#### Valid

`./led_patterns -h`

`./led_patterns -v -p 0x00 2000 0xFF 3000 0xAA 1000 0x01 500`

`./led_patterns -v -f patterns.txt` (so long as patterns.txt exists in the same directory as led_patterns)

`./led_patterns -p 0x10 100 0x01 100`

`./led_patterns -f crabs.txt` (so long as crabs.txt exists in the same directory as led_patterns)

#### Invalid

`led_patterns -h` -> needs ./ before led_patterns

`./led_patterns -h -p` -> don't use -h with other commands

`./led_patterns -v -p 0x20 1000 0xFF 100 -f patterns.txt` -> don't use -p and -f in conjunction

`./led_patterns -f` -> need to supply arguments for -f (and -p as well)

`./led_patterns -p 0x00 2000 0xFF` -> for -p, every value needs a display time (and vice versa)


## Building
For everything to (hopefully) work: 
1) Your LED Patterns bitstream needs to be loaded onto the FPGA. Easiest way to do this is by creating an rbf file of lab7 (see section 6.1.4 in the book on how) and put the rbf file (titled soc_system.rbf) onto the FAT32 portion of your SD card (the part Windows *can* see).
2) You need to put the compiled version of led_patterns.c (so just led_patterns) onto your EXT4 partition of your SD card (specifically in home/root/). First you gotta load up your VM, then navigate to your led_patterns.c file, then compile using the following command:

`arm-linux-gnueabihf-gcc -o led_patterns -Wall -static led_pattern.c`

After that, open file explorer with admin priveledges (`sudo nautilus` in terminal) and move led_patterns (not led_patterns.c) into that home/root/ folder in the EXT4 partition of the SD Card. 
3) To get the SD card to boot up properly on your FPGA without ruining the led_patterns file: 

Start with the FPGA on with the PUTTY cable in, but with the PUTTY application closed and the SD Card not inserted.

- Start up PUTTY and connect to the FPGA

- Disconnect the power to the FPGA

- Insert the SD Card

- Reconnect the power to the FPGA

After you login (user: root, shouldn't be prompted for a password) you should be good to go!