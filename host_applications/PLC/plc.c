#include <stdio.h>
#include <stdlib.h>
#include <modbus/modbus.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>

#define SERVER_IP "10.0.2.16"
#define PORT 502
#define NUM_MESSAGES 120 // 10 hours = 120 * 5 minutes
#define NUM_REGISTERS 10

int main() {
    modbus_t *ctx;
    uint16_t tab_reg[NUM_REGISTERS];
    int rc = 0;
    int message_index = 1;
    int server_socket;

    // Create a new Modbus TCP context
    ctx = modbus_new_tcp(SERVER_IP, PORT);
    if (ctx == NULL) {
        fprintf(stderr, "Unable to allocate libmodbus context\n");
        return -1;
    }

    // Connect to the server (HMI)
    server_socket = modbus_connect(ctx);
    if (server_socket == -1) {
        fprintf(stderr, "Connection failed: %s\n", modbus_strerror(errno));
        modbus_free(ctx);
        return -1;
    }

    printf("PLC Client connected to %s:%d\n", SERVER_IP, PORT);



    while (1) {
        // Write values to Modbus server
        for (int i = 0; i < 10; i++) {
            tab_reg[i] = i * 10 * message_index;  // Example values
        }    

        rc = modbus_write_registers(ctx, 0, NUM_REGISTERS, tab_reg);
        if (rc == -1) {
            fprintf(stderr, "Write failed: %s\n", modbus_strerror(errno));
            modbus_close(ctx);
            modbus_free(ctx);
            return -1;
        }
        printf("Client wrote %d registers to server\n", rc);

        sleep(20);

        // Read back values from Modbus server
        rc = modbus_read_registers(ctx, 0, NUM_REGISTERS, tab_reg);
        if (rc == -1) {
            fprintf(stderr, "Read failed: %s\n", modbus_strerror(errno));
        } else {
            printf("Client read %d registers from server:\n", rc);
            for (int i = 0; i < rc; i++) {
                printf("Register %d: %d\n", i, tab_reg[i]);
            }
        }

        sleep(300); // Wait 5 minutes

        message_index++;
        if (message_index >= NUM_MESSAGES)
        {
            message_index = 1;
        }

    }

    // Cleanup
    modbus_close(ctx);
    modbus_free(ctx);
    close(server_socket);
    return 0;
}
