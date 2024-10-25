/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_secB_15_array_multiplier (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  
  wire [3:0] m = ui_in[7:4];
  wire [3:0] q = ui_in[3:0];
  wire [7:0] p;

  always @(*) begin
      p = 0; // Initialize product to 0
      for (integer i = 0; i < 4; i = i + 1) begin
          if (q[i]) begin
              p = p + (m << i); // Shift and add
          end
      end
  end

  assign uo_out = p;
  
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule

module array_mult_structural (
    input [3:0} m,
    input [3:0} q,
    output reg [7:0} p
);
