module gradient_magnitude (
    input signed [11:0] gx,
    input signed [11:0] gy,
    output [23:0] magnitude
);

    wire signed [23:0] gx_sq;
    wire signed [23:0] gy_sq;

    assign gx_sq = gx * gx;
    assign gy_sq = gy * gy;

    assign magnitude = gx_sq + gy_sq;

endmodule