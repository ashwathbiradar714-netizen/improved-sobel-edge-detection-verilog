module sobel_gradient (
    input  [7:0] p1, p2, p3,
    input  [7:0] p4, p5, p6,
    input  [7:0] p7, p8, p9,

    output signed [11:0] gx,
    output signed [11:0] gy
);

    assign gx =
          -$signed({1'b0,p1})
          + $signed({1'b0,p3})
          - (2 * $signed({1'b0,p4}))
          + (2 * $signed({1'b0,p6}))
          - $signed({1'b0,p7})
          + $signed({1'b0,p9});

    assign gy =
          -$signed({1'b0,p1})
          - (2 * $signed({1'b0,p2}))
          - $signed({1'b0,p3})
          + $signed({1'b0,p7})
          + (2 * $signed({1'b0,p8}))
          + $signed({1'b0,p9});

endmodule