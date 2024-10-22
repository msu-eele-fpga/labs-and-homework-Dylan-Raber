#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> // for mmap
#include <fcntl.h> // for file open flags
#include <unistd.h> // for getting the page size
#include <signal.h>

static volatile int keepRunning = 1;

void intHandler(int dummy) {
    keepRunning = 0;
}


void usage()
 {
    fprintf(stderr, "myprogram [-h] [-v] [p pat1 time1 pat2 time2 ...] [-f filename.txt] \n\n");
    fprintf(stderr, "options:\n");
    fprintf(stderr, "   -h      show this help message and exit\n");
    fprintf(stderr, "   -v      displays LED Pattern and time being displayed\n");
    fprintf(stderr, "   -p      input argument for displaying patterns and their time specifications, looping until Ctrl-C is entered\n");
    fprintf(stderr, "           Example: -p 0x55 500 0x0f 1500 (patterns in hex, time in milliseconds)\n");
    fprintf(stderr, "   -f      input argument for reading text file for patterns\n");
    fprintf(stderr, "           text file will be formatted: <pattern1> <time1> /n <pattern2> <time2> /n etc.\n");
 }

//void trying()
//{
//} 

 int main(int argc, char **argv)
 {
    // This is the size of a page of memory in the system. Typically 4096 bytes.
    const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);

    char* arg1 = argv[1];
    char* arg2 = argv[2];
    char* arg3 = argv[3];

    signal(SIGINT, intHandler);

    if (strcmp(arg1,"-h") == 0 && argc == 2)
    {
        // Argument -h given, so print the usage text and exit;
        // NOTE: The first argument is actually the program name, so argv[0]
        // is the program name, argv[1] is the first *real* argument, etc.
        usage();
        return 1;
    } else if (strcmp(arg1,"-v") == 0 && strcmp(arg2, "-p") == 0)
    {
        //trying();
        int i = 3;
        while(argv[i]!=NULL) {
            printf("\n %s is argc %d ", argv[i],i);
            i++;
        }
        return 1;
    } else if (strcmp(arg1,"-p") == 0 && argv[2] != NULL)
    {
        //trying();
        int i = 2;
        while(argv[i]!=NULL) {
            printf("\n %s is argc %d ", argv[i],i);
            i++;
        }
        return 1;
    } else if (strcmp(arg1,"-f") == 0 && argv[2] != NULL) 
    {
        FILE *ftpr;
        fptr = fopen("filename.txt", "r");
        if (fptr == NULL) {
            printf("Not able to open file");
        }
        char fileString[100];
        fgets(fileString,100,fptr);
        printf("%s", fileString);
        fclose(fptr);
        return 1;
    } else {
        printf("Something went wrong...");
        return 1;
    }

    return 0;
    //while (keepRunning) { 
    //}
 }