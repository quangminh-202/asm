#include <stdio.h> 
#include <stdint.h> 
#include <string.h>

uint32_t crc32(const char* data) {
    uint32_t crc = 0xFFFFFFFF;
    while (*data) {
    	uint8_t current_char;
        current_char = (uint8_t)(*data);
        crc = crc ^ current_char;
        data++;
        for (int i = 0; i < 8; i++) {
            if (crc & 1)
                crc = (crc >> 1) ^ 0xEDB88320;
            else
                crc >>= 1;
        }
    }
    return crc ^ 0xFFFFFFFF;
}

int main() {
    char input[257];
    input[256] = 0;
    printf("input: ");
    fgets(input, 256, stdin);
    input[strcspn(input, "\n")] = '\0';
    
    printf("CRC32: %08X\n", crc32(input));
    return 0;
}
