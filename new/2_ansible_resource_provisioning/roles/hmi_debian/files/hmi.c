#include <stdio.h>
#include <stdlib.h>
#include <modbus/modbus.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>

#define SERVER_ID 1
#define SERVER_IP "10.0.2.16"
#define PORT 502
#define NUM_MESSAGES 120 // 10 hours = 120 * 5 minutes
#define NUM_REGISTERS 10

int main() {
    modbus_t *ctx;
    modbus_mapping_t *mb_mapping;
    int rc = 0;
    uint8_t req[MODBUS_TCP_MAX_ADU_LENGTH];
    int message_index = 0;
    int server_socket;

    // Create a new Modbus TCP context
    ctx = modbus_new_tcp(SERVER_IP, PORT);
    if (ctx == NULL) {
        fprintf(stderr, "Unable to allocate libmodbus context\n");
        return -1;
    }

    // // Set the Modbus server ID
    // modbus_set_slave(ctx, SERVER_ID);

    // Create a modbus_mapping structure
    mb_mapping = modbus_mapping_new(0, 0, NUM_REGISTERS, 0); // 10 holding registers, 10 input registers
    if (mb_mapping == NULL) {
        fprintf(stderr, "Failed to allocate the mapping: %s\n", modbus_strerror(errno));
        modbus_free(ctx);
        return -1;
    }

    // Bind the socket and listen
    server_socket = modbus_tcp_listen(ctx, 1);
    if (server_socket == -1) {
        fprintf(stderr, "Unable to listen: %s\n", modbus_strerror(errno));
        modbus_mapping_free(mb_mapping);
        modbus_free(ctx);
        return -1;
    }

    printf("HMI Server listening on %s:%d\n", SERVER_IP, PORT);

    while (1) {
        // Reset the message index after 10 hours (120 cycles)
        if (message_index >= NUM_MESSAGES) {
            message_index = 0;
        }

        modbus_tcp_accept(ctx, &server_socket);

        // // Simulate different message data in holding registers
        // for (int i = 0; i < 10; i++) {
        //     mb_mapping->tab_registers[i] = message_index + i;
        // }

        // Wait for a client request
        rc = modbus_receive(ctx, req);
        if (rc > 0) {
            modbus_reply(ctx, req, rc, mb_mapping);
        } else {
            fprintf(stderr, "Connection closed: %s\n", modbus_strerror(errno));
            break;
        }

        // message_index++;
       // sleep(300); // Wait 5 minutes
    }

    // Cleanup
    close(server_socket);
    modbus_mapping_free(mb_mapping);
    modbus_free(ctx);

    return 0;
}

