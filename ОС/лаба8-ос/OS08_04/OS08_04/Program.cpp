#include <stdio.h>

int main() {
    unsigned long phys_addr = 0x2540315F;
    unsigned char* ptr = (unsigned char*)phys_addr;
    printf("Value at physical address 0x%lx: 0x%02x\n", phys_addr, *ptr);
    return 0;
}
