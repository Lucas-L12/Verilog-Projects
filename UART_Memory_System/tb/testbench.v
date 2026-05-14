`timescale 1ns / 1ps

module Top_Level_tb;

 

    parameter DBIT       = 8;
    parameter SB_TICK    = 16;
    parameter DVSR       = 27;
    parameter DVSR_BIT   = 8;
    parameter W          = 8;
    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 8;



    logic clk;
    logic reset;
    logic Rx;
    logic Tx;

    // Scoreboard
   
    logic [7:0] expected_mem [0:255];


    // UART monitor variables
    logic [7:0] rx_byte;

    // Statistics

    integer tests_passed;
    integer tests_failed;

    Top_Level #(
        .DBIT(DBIT),
        .SB_TICK(SB_TICK),
        .DVSR(DVSR),
        .DVSR_BIT(DVSR_BIT),
        .W(W),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .clk(clk),
        .reset(reset),
        .Rx(Rx),
        .Tx(Tx)
    );


    always #5 clk = ~clk;
 
    // BIT_TIME = 16 ticks * 27 clocks/tick * 10 ns/clock
    localparam BIT_TIME = 16 * 27 * 10;

   
    // UART byte transmitter task (TB drives Rx → DUT)

    task uart_send_byte(input [7:0] data);
        integer i;
        begin
            Rx = 0;
            #(BIT_TIME);
            for (i = 0; i < 8; i = i + 1) begin
                Rx = data[i];
                #(BIT_TIME);
            end
            Rx = 1;
            #(BIT_TIME);
        end
    endtask

    // =====================================================
    // UART receiver monitor task (TB samples Tx ← DUT)
    //
    // The DUT can start transmitting BEFORE uart_send_byte
    // returns (it processes the received byte within the
    // stop-bit window). This task must therefore be forked
    // in parallel with the LAST uart_send_byte of each
    // transaction so that @(negedge Tx) catches the actual
    // start bit rather than a mid-frame data transition.
    // =====================================================

    task uart_receive_byte(output [7:0] data);
        integer i;
        begin
            @(negedge Tx);
            #(BIT_TIME / 2);
            #(BIT_TIME);
            for (i = 0; i < 8; i = i + 1) begin
                data[i] = Tx;
                #(BIT_TIME);
            end
        end
    endtask

    
    // UART WRITE transaction task
  
    task uart_write(input [7:0] addr, input [7:0] data);
        begin
            $display("----------------------------------------");
            $display("UART WRITE transaction");
            $display("ADDR = %h  DATA = %h", addr, data);
            $display("TIME = %t", $time);

            uart_send_byte(8'h01);
            uart_send_byte(addr);
            uart_send_byte(data);

            expected_mem[addr] = data;

            repeat(50) @(posedge clk);

            if (DUT.I_RAM.ram[addr] !== expected_mem[addr]) begin
                tests_failed++;
                $error("WRITE FAILED at address %h", addr);
                $display("Expected = %h", expected_mem[addr]);
                $display("Got      = %h", DUT.I_RAM.ram[addr]);
            end else begin
                tests_passed++;
                $display("WRITE PASSED");
            end
        end
    endtask

    
    // UART READ transaction task
  
    // FIX: fork uart_receive_byte alongside uart_send_byte(addr)
    // so the monitor is active when the DUT starts transmitting.


    task uart_read(input [7:0] addr);
        begin
            $display("----------------------------------------");
            $display("UART READ transaction");
            $display("ADDR = %h", addr);
            $display("TIME = %t", $time);

            uart_send_byte(8'h02);

            fork
                uart_receive_byte(rx_byte);
                uart_send_byte(addr);
            join

            if (rx_byte !== expected_mem[addr]) begin
                tests_failed++;
                $error("READ FAILED at address %h", addr);
                $display("Expected = %h", expected_mem[addr]);
                $display("Got      = %h", rx_byte);
            end else begin
                tests_passed++;
                $display("READ PASSED");
            end
        end
    endtask

   
    // Invalid command test

    // FIX: fork so monitor catches start bit of DUT's 0xFF
   

    task invalid_command_test;
        begin
            $display("----------------------------------------");
            $display("INVALID COMMAND TEST");
            $display("TIME = %t", $time);

            fork
                uart_receive_byte(rx_byte);
                uart_send_byte(8'h55);
            join

            if (rx_byte !== 8'hFF) begin
                tests_failed++;
                $error("ERROR CODE NOT GENERATED, got %h", rx_byte);
            end else begin
                tests_passed++;
                $display("INVALID COMMAND TEST PASSED");
            end
        end
    endtask


    // Invalid address test

    // FIX: fork so monitor catches start bit of DUT's 0xFF

    task invalid_address_test;
        begin
            $display("----------------------------------------");
            $display("INVALID ADDRESS TEST");
            $display("TIME = %t", $time);

            uart_send_byte(8'h01);
            uart_send_byte(8'hF0);

            fork
                uart_receive_byte(rx_byte);
                uart_send_byte(8'hAA);
            join

            if (rx_byte !== 8'hFF) begin
                tests_failed++;
                $error("MPU ERROR NOT GENERATED, got %h", rx_byte);
            end else begin
                tests_passed++;
                $display("INVALID ADDRESS TEST PASSED");
            end
        end
    endtask


    // Random write/read test


    task random_test;
        integer i;
        logic [7:0] rand_addr;
        logic [7:0] rand_data;
        begin
            $display("----------------------------------------");
            $display("STARTING RANDOM TEST");

            for (i = 0; i < 10; i = i + 1) begin
                rand_addr = $urandom_range(0, 8'h7F);
                rand_data = $urandom;
                uart_write(rand_addr, rand_data);
                uart_read(rand_addr);
            end

            $display("RANDOM TEST FINISHED");
        end
    endtask

    // Timeout protection

    initial begin
        #20ms;
        $fatal(1, "SIMULATION TIMEOUT");
    end


    // Main stimulus

    initial begin
        clk          = 0;
        reset        = 1;
        Rx           = 1;
        tests_passed = 0;
        tests_failed = 0;

        for (int i = 0; i < 256; i++)
            expected_mem[i] = 0;

        #100;
        reset = 0;

        // ─── Directed tests ───────────────────────────
        uart_write(8'h10, 8'hAA);
        uart_read(8'h10);

        uart_write(8'h20, 8'h55);
        uart_read(8'h20);

        // ─── Error tests ──────────────────────────────
        invalid_command_test();
        invalid_address_test();

        // ─── Random tests ─────────────────────────────
        random_test();

        // ─── Final report ─────────────────────────────
        $display("========================================");
        $display("SIMULATION FINISHED");
        $display("TESTS PASSED = %0d", tests_passed);
        $display("TESTS FAILED = %0d", tests_failed);
        $display("========================================");

        #1000;
        $stop;
    end

endmodule
