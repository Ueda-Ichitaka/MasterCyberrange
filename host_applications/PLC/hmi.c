// hmi.c
#include <stdio.h>
#include <stdlib.h>
#include <modbus/modbus.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>

#define SERVER_IP "10.0.2.17"
#define PORT 1502
#define NUM_MESSAGES 120 // 10 hours = 120 * 5 minutes

int main() {
    modbus_t *ctx;
    uint16_t tab_reg[10];
    int rc;
    int message_index = 0;

    // Create a new Modbus TCP context
    ctx = modbus_new_tcp("10.0.2.16", PORT);
    if (ctx == NULL) {
        fprintf(stderr, "Unable to allocate libmodbus context\n");
        return -1;
    }

    // Connect to the server (PLC)
    if (modbus_connect(ctx) == -1) {
        fprintf(stderr, "Connection failed: %s\n", modbus_strerror(errno));
        modbus_free(ctx);
        return -1;
    }

    printf("HMI Client connected to %s:%d\n", SERVER_IP, PORT);

    while (1) {
        // Reset the message index after 10 hours (120 cycles)
        if (message_index >= NUM_MESSAGES) {
            message_index = 0;
        }

        // Read 10 holding registers from the server
        rc = modbus_read_registers(ctx, 0, 10, tab_reg);
        if (rc == -1) {
            fprintf(stderr, "Failed to read registers: %s\n", modbus_strerror(errno));
            break;
        }

        // Display received data
        printf("HMI received: ");
        for (int i = 0; i < 10; i++) {
            printf("%d ", tab_reg[i]);
        }
        printf("\n");

        message_index++;
        sleep(300); // Wait 5 minutes
    }

    // Cleanup
    modbus_close(ctx);
    modbus_free(ctx);

    return 0;
}
