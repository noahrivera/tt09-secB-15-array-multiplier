/*
 * Copyright (c) 2024 Noah Rivera
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

  wire carry_1, carry_2, carry_3, carry_4, carry_5, carry_6, carry_7, carry_8, carry_9, carry_10, carry_11;
  wire sum_1, sum_2, sum_3, sum_4, sum_5, sum_6;
  
  assign p[0] = m[0] & q[0];

  Fadder A1 (m[0] & q[1], m[1] & q[0], 1'b0, p[1], carry_1);
  Fadder A2 (m[2] & q[0], m[1] & q[1], carry_1, sum_1, carry_2);
  Fadder A3 (m[3] & q[0], m[2] & q[1], carry_2, sum_2, carry_3);
  Fadder A4 (m[3] & q[1], 1'b0, carry_3, sum_3, carry_4);

  Fadder A5 (m[0] & q[2], sum_1, 1'b0, p[2], carry_5);
  Fadder A6 (m[1] & q[2], sum_2, carry_5, sum_4, carry_6);
  Fadder A7 (m[2] & q[2], sum_3, carry_6, sum_5, carry_7);
  Fadder A8 (m[3] & q[2], carry_4, carry_7, sum_6, carry_8);

  Fadder A9 (m[0] & q[3], sum_4, 1'b0, p[3], carry_9);
  Fadder A10 (m[1] & q[3], sum_5, carry_9, p[4], carry_10);
  Fadder A11 (m[2] & q[3], sum_6, carry_10, p[5], carry_11);
  Fadder A12 (m[3] & q[3], carry_8, carry_11, p[6], p[7]);

  assign uo_out = p;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule

module array_mult_structural (
    input [3:0] m,
    input [3:0] q,
    output [7:0] p
);

endmodule

module Fadder (
  input m,
  input q,
  input cin,
  output sum,
  output cout
);

  assign sum = m ^ q ^ cin;
  assign cout = (cin & (m^q)) | (m & q);

endmodule
