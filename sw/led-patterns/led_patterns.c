#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> // for mmap
#include <fcntl.h> // for file open flags
#include <unistd.h> // for getting the page size
#include <signal.h>
#include <string.h>

static volatile int keepRunning = 1;

void sendValue(char *Address, unsigned long Value) {
    const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);


    const uint32_t ADDRESS = strtoul(Address, NULL, 0);

    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1)
    {
        fprintf(stderr, "failed to open /dev/mem.\n");
    }

    // mmap needs to map memory at page boundaries; that is, the address we are
    // mapping needs to be page-aligned. The ~(PAGE_SIZE - 1) bitmask returns
    // the closest page-aligned address that contains ADDRESS in the page.
    // For a page size of 4096 bytes, (PAGE_SIZE - 1) = 0xFFF; extending this
    // to 32-bits and flipping the bits results in a mask of 0xFFFF_F000.
    // AND'ing with this bitmask forces the last 3 nibbles of ADDRESS to be 0,
    // which ensures that the returned address is a multiple of the page size
    // (4096 = 0x1000, so indeed, any address that is a multiple of 4096 will
    // have the last 3 nibbles equal to 0).
    uint32_t page_aligned_addr = ADDRESS & ~(PAGE_SIZE - 1);
    //printf("memory addresses:\n");
    //printf("-------------------------------------------------------------------\n");
    //printf("page aligned address = 0x%x\n", page_aligned_addr);

    // Map a page of physical memory into virtual memory. See the mmap man page
    // for more info: https://www.man7.org/linux/man-pages/man2/mmap.2.html.
    uint32_t *page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
    if (page_virtual_addr == MAP_FAILED)
    {
        fprintf(stderr, "failed to map memory.\n");
    }
    //printf("page_virtual_addr = %p\n", page_virtual_addr);

    // The address we want to access might not be page-aligned. Since we mapped
    // a page-aligned address, we need our target address' offset from the
    // page boundary. Using this offset, we can compute the virtual address
    // corresponding to our physical target address (ADDRESS).
    uint32_t offset_in_page = ADDRESS & (PAGE_SIZE - 1);
    //printf("offset in page = 0x%x\n", offset_in_page);

    // Compute the virtual address corresponding to ADDRESS. Because
    // page_virtual_addr and target_virtual_addr are both uint32_t pointers,
    // pointer addition multiplies the pointer address by the number of bytes
    // needed to store a uint32_t (4 bytes); e.g., 0x10 + 4 = 0x20, not 0x14.
    // Consequently, we need to divide offset_in_page by 4 bytes to make the
    // pointer addition return our desired address (0x14 in the example).
    // We use volatile because the value at target_virtual_addr could change
    // outside of our program; the address refers to memory-mapped I/O
    // that could be changed by hardware. volatile tells the compiler to
    // not optimize accesses to this memory address.
    volatile uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page/sizeof(uint32_t*);
    //printf("target_virtual_addr = %p\n", target_virtual_addr);
    //printf("-------------------------------------------------------------------\n");

    const uint32_t VALUE = Value;
    *target_virtual_addr = VALUE;
}

void intHandler(int dummy) {
    keepRunning = 0;

    sendValue("0xFF200000", 0);

}


void usage()
 {
    fprintf(stderr, "./led_patterns [-h] [-v] [-p pat1 time1 pat2 time2 ...] [-f filename.txt] \n\n");
    fprintf(stderr, "options:\n");
    fprintf(stderr, "   -h      show this help message and exit\n");
    fprintf(stderr, "   -v      displays LED Pattern and time being displayed\n");
    fprintf(stderr, "   -p      input argument for displaying patterns and their time specifications, looping until Ctrl-C is entered\n");
    fprintf(stderr, "           Example: -p 0x55 500 0x0f 1500 (patterns in hex, time in milliseconds)\n");
    fprintf(stderr, "   -f      input argument for reading text file for patterns\n");
    fprintf(stderr, "           text file will be formatted: <pattern1> <time1> /n <pattern2> <time2> /n etc.\n");
 }

 void sleep_ms(int milliseconds) {
    usleep(milliseconds * 1000);
 }

 void gaming(bool check_p, bool check_f, unsigned long value, int delay)
 {
 }

 int main(int argc, char **argv)
 {
    signal(SIGINT, intHandler);

    

    if (argc == 1) {
        usage();
        intHandler(1);
    }

    char* arg1 = argv[1];
    char* arg2 = argv[2];

    bool check_p = false;
    bool check_f = false;

    for (int l = 0; l < argc; l++) {
        if (strcmp(argv[l],"-p") == 0) {
            check_p = true;
        } else if (strcmp(argv[l], "-f") == 0) {
            check_f = true;
        }
    }

    if (check_p && check_f) {
        printf("Do not use -p and -f at the same time! Exiting...\n");
        intHandler(1);
    }

    if (strcmp(arg1,"-h") == 0 && argc == 2)
    {
        // Argument -h given, so print the usage text and exit;
        // NOTE: The first argument is actually the program name, so argv[0]
        // is the program name, argv[1] is the first *real* argument, etc.
        usage();
        intHandler(1);
    } else if (strcmp(arg1,"-v") == 0) {
        if (strcmp(arg2, "-p") == 0) {
            int i = 3;
            while(argv[i]!=NULL) {
                //printf("\n %s is argc %d \n", argv[i],i);
                i++;
            }
            int r = i % 2;
            if (r == 0) {
                printf("\n Not enough patterns or timings supplied: exiting...\n");
                intHandler(1);
            } else {
                while(keepRunning) {
                    for (int k = 4; k < argc; k = k + 2) {
                        unsigned long value = strtoul(argv[k-1],NULL,0);
                        int delay = atoi(argv[k]);
                        printf("LED pattern = %ld Display time = %d msec\n",value,delay);
                        sendValue("0xFF200000", 1);
                        sendValue("0xFF200008", value);
                        sleep_ms(delay);
                    }
                }
            }
        } else if (strcmp(arg2,"-f") == 0 && argv[3] != NULL) {
            FILE *fptr;
            int bufferLength = 255;
            char buffer[bufferLength];
            fptr = fopen(argv[3], "r");
            if (fptr == NULL) {
                printf("Not able to open file\n");
                intHandler(1);
            }
            
            sendValue("0xFF200000", 1);

            while(fgets(buffer, bufferLength, fptr)) {
                char * value_s = strtok(buffer, " ");
                char * delay_s = strtok(NULL, " ");
                unsigned long value = strtoul(value_s,NULL,0);
                int delay = atoi(delay_s);
                printf("LED pattern = %ld Display time = %d msec\n",value,delay);
                sendValue("0xFF200008", value);
                sleep_ms(delay);
            }
            fclose(fptr);
            intHandler(1);
        }
    } else if (strcmp(arg1,"-p") == 0 && argv[2] != NULL)
    {
        int i = 2;
        while(argv[i]!=NULL) {
            i++;
        }
        int r = i % 2;
        if (r == 1) {
            printf("\n Not enough patterns or timings supplied: exiting...\n");
            intHandler(1);
        } else {
            while(keepRunning) {
                for (int k = 3; k < argc; k = k + 2) {
                        unsigned long value = strtoul(argv[k-1],NULL,0);
                        int delay = atoi(argv[k]);
                        sendValue("0xFF200000", 1);
                        sendValue("0xFF200008", value);
                        sleep_ms(delay);
                }
            }
            
        }
    } else if (strcmp(arg1,"-f") == 0 && argv[2] != NULL) 
    {
        FILE *fptr;
        int bufferLength = 255;
        char buffer[bufferLength];
        fptr = fopen(argv[2], "r");
        if (fptr == NULL) {
            printf("Not able to open file: exiting...\n");
            intHandler(1);
        }

        sendValue("0xFF200000", 1);

        while(fgets(buffer, bufferLength, fptr)) {
            char * value_s = strtok(buffer, " ");
            char * delay_s = strtok(NULL, " ");
            unsigned long value = strtoul(value_s,NULL,0);
            int delay = atoi(delay_s);
            sendValue("0xFF200008", value);
            sleep_ms(delay);
        }
        fclose(fptr);
        intHandler(1);
    } else {
        printf("Something went wrong...\n");
        intHandler(1);
    }
    return 0;
 }