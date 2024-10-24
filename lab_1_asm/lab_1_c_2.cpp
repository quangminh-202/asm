#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define POLYNOMIAL 0xEDB88320
#define INIT_CRC 0xFFFFFFFF
#define FINAL_CRC 0xFFFFFFFF

uint32_t crc32(const char *data) {
    uint32_t crc = INIT_CRC;
    int i;
    uint32_t check;
    
cycle_start:
    if (*data == 0) goto cycle_end;
    
    crc ^= (uint8_t)(*data);
    i = 0;
    
bit_loop:
    check = crc & 1;
    crc = crc >> 1;
    
    if (check == 0) goto bit_end;
    crc ^= POLYNOMIAL;
    
bit_end:
	i++;
    if (i < 8) goto bit_loop;
    data++;
    goto cycle_start;
    
cycle_end:
    return crc ^ FINAL_CRC;
}

int main() {
    char input[256];
    printf("input: ");
    fgets(input, 256, stdin);
    input[strcspn(input, "\n")] = '\0';
    
    printf("CRC32: %08X\n", crc32(input));
    return 0;
}

