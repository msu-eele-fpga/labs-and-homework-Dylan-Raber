#include <linux/module.h>	/* Needed by all modules */
#include <linux/kernel.h>	/* Needed for KERN_INFO */
#include <linux/init.h>     /* Needed for the macros*/

static int __init init_function(void); 
static void __exit cleanup_function(void); 

int init_function(void) {
    printk(KERN_INFO "Hello, world\n");
    return 1;
}
void cleanup_function(void) {
    printk(KERN_INFO "Goodbye, cruel world\n");
}

module_init(init_function)
module_exit(cleanup_function)

MODULE_AUTHOR("Dylan Raber <dylan.raber02@gmail.com");
MODULE_LICENSE ("GPL");