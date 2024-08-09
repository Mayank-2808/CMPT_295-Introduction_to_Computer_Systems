#include <stdint.h>
#include <stdio.h>

void report_character(uint32_t character, int num_bytes) {
    printf("Character: %u, Byte Count: %d\n", character, num_bytes);
}

void decode_utf8(const char* input) {
    
    while (*input) {
        uint32_t character = 0;
        int num_bytes = 0;
        unsigned char byte = *input;

        if ((byte & 0x80) == 0) {  // 1-byte character
            character = byte;
            num_bytes = 1;
        } else if ((byte & 0xE0) == 0xC0) {  // 2-byte character
            character = (byte & 0x1F) << 6;
            input++;
            character |= *input & 0x3F;
            num_bytes = 2;
        } else if ((byte & 0xF0) == 0xE0) {  // 3-byte character
            character = (byte & 0x0F) << 12;
            input++;
            character |= (*input & 0x3F) << 6;
            input++;
            character |= *input & 0x3F;
            num_bytes = 3;
        } else if ((byte & 0xF8) == 0xF0) {  // 4-byte character
            character = (byte & 0x07) << 18;
            input++;
            character |= (*input & 0x3F) << 12;
            input++;
            character |= (*input & 0x3F) << 6;
            input++;
            character |= *input & 0x3F;
            num_bytes = 4;
        }
        
        report_character(character, num_bytes);
        input++;
    }

}
