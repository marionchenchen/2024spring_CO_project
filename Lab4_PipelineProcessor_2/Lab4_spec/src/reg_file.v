`timescale 1ns / 1ps
// 111550168

/* checkout FIGURE 4.7 */
module reg_file (
    input         clk,          // clock
    input         rstn,         // negative reset
    input  [ 4:0] read_reg_1,   // Read Register 1 (address)
    input  [ 4:0] read_reg_2,   // Read Register 2 (address)
    input         reg_write,    // RegWrite: write data when posedge clk
    input  [ 4:0] write_reg,    // Write Register (address)
    input  [31:0] write_data,   // Write Data
    output [31:0] read_data_1,  // Read Data 1
    output [31:0] read_data_2   // Read Data 2
);

    reg [31:0] registers[0:31];  // do not change its name

    assign read_data_1 = (read_reg_1==0)? 32'b0:registers[read_reg_1];
    assign read_data_2 = (read_reg_2==0)? 32'b0:registers[read_reg_2];

    
    always @(posedge clk)
        if (rstn) begin  // make sure to check reset!
            if (reg_write && write_reg != 0) begin
                registers[write_reg]<=write_data; /*uncertain*/
            end
        end

    always @(negedge rstn) begin
        registers[0]<= 0; registers[1]<=0; registers[2]<= 0; registers[3]<= 0;
        registers[4]<= 0; registers[5]<= 0; registers[6]<= 0; registers[7]<= 0;
        registers[8]<= 0; registers[9]<= 0; registers[10]<= 0; registers[11]<= 0;
        registers[12]<= 0; registers[13]<= 0; registers[14]<= 0; registers[15]<= 0;
        registers[16]<= 0; registers[17]<= 0; registers[18]<= 0; registers[19]<= 0;
        registers[20]<= 0; registers[21]<= 0; registers[22]<= 0; registers[23]<= 0;
        registers[24]<= 0; registers[25]<= 0; registers[26]<= 0; registers[27]<= 0;
        registers[28]<= 0; registers[29]<= 0; registers[30]<= 0; registers[31]<= 0;
    end

endmodule
