`timescale 1ns / 1ps

module Controller
#(
    parameter DATA_WIDTH = 8,
              ADDR_WIDTH = 8
)
(

    input  logic clk,
    input  logic reset,

    input  logic [DATA_WIDTH-1:0] r_data,
    input  logic [DATA_WIDTH-1:0] mem_data_out,

    input  logic rx_ready,
    input  logic tx_done,
    input  logic access_valid,

    output logic rd_uart,
    output logic wr_uart,
    output logic mem_write_en,

    output logic [DATA_WIDTH-1:0] w_data,
    output logic [ADDR_WIDTH-1:0] mem_addr,
    output logic [DATA_WIDTH-1:0] mem_data_in

);

localparam logic [DATA_WIDTH-1:0] WRITE_CMD  = 8'h01;
localparam logic [DATA_WIDTH-1:0] READ_CMD   = 8'h02;
localparam logic [DATA_WIDTH-1:0] ERROR_CODE = 8'hFF;
    
    // fsm state type
    typedef enum logic [3:0] {
        IDLE,
        GET_ADDR,
        GET_DATA,
        CHECK_MPU,
        READ_MEM,
        SEND_DATA,
        WRITE_MEM,
        ERROR,
        WAIT_TX
    } state_type;
    
    // signal declaration
    state_type state_reg, state_next;

    logic [DATA_WIDTH-1:0] cmd_reg, cmd_next;
    logic [ADDR_WIDTH-1:0] addr_reg, addr_next;
    logic [DATA_WIDTH-1:0] data_reg, data_next;
    
    // FSMD state and data registers
    always_ff @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            state_reg <= IDLE;
            cmd_reg   <= 0;
            addr_reg  <= 0;
            data_reg  <= 0;
        end
        
        else
        begin
            state_reg <= state_next;
            cmd_reg   <= cmd_next;
            addr_reg  <= addr_next;
            data_reg  <= data_next;
        end
    end
        
    // FSMD control path next-state logic
    always_comb
    begin

        state_next   = state_reg;
        cmd_next     = cmd_reg;
        addr_next    = addr_reg;
        data_next    = data_reg;

        rd_uart      = 0;
        wr_uart      = 0;
        mem_write_en = 0;

        w_data       = 0;
       
        case(state_reg)

            IDLE: 
            begin
                if(rx_ready)
                begin
                    cmd_next  = r_data;
                    rd_uart   = 1;
                    addr_next = 0;

                    if(r_data == WRITE_CMD || r_data == READ_CMD)
                        state_next = GET_ADDR;

                    else
                        state_next = ERROR;
                end
            end

            GET_ADDR:
            begin
                if(rx_ready)
                begin
                    addr_next = r_data;
                    rd_uart   = 1;

                    if(cmd_reg == WRITE_CMD)
                        state_next = GET_DATA;

                    else if(cmd_reg == READ_CMD)
                        state_next = CHECK_MPU;

                    else
                        state_next = ERROR;
                end
            end

            GET_DATA:
            begin
                if(rx_ready)
                begin       
                    data_next = r_data;
                    rd_uart   = 1;

                    state_next = CHECK_MPU;  
                end
            end
                
            CHECK_MPU:
            begin
                if(access_valid)
                begin
                    if(cmd_reg == WRITE_CMD)
                        state_next = WRITE_MEM;

                    else
                        state_next = READ_MEM;
                end

                else
                    state_next = ERROR;
            end

            READ_MEM:
            begin
                state_next = SEND_DATA;
            end

            SEND_DATA:
            begin
                w_data   = mem_data_out;
                wr_uart  = 1;

                state_next = WAIT_TX;
            end
                    
            WRITE_MEM:
            begin  
                mem_write_en = 1;

                state_next = IDLE;
            end

            ERROR:
            begin
                w_data  = ERROR_CODE;
                wr_uart = 1;

                state_next = WAIT_TX;
            end

            WAIT_TX:
            begin
                if(tx_done)
                    state_next = IDLE;
            end

            default:
                state_next = IDLE;
        
        endcase
            
    end

    assign mem_addr    = addr_reg;
    assign mem_data_in = data_reg;

endmodule





