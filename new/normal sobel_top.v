module normal_sobel_top #(
    parameter IMAGE_WIDTH = 768
)(
    input        clk,
    input        rst,
    input        pixel_valid,
    input  [7:0] pixel_in,

    output [7:0] edge_pixel,
    output       window_valid
);

    // ---------------------------------------
    // 3x3 window signals
    // ---------------------------------------

    wire [7:0] p1, p2, p3;
    wire [7:0] p4, p5, p6;
    wire [7:0] p7, p8, p9;


    // ---------------------------------------
    // Sobel gradient
    // ---------------------------------------

    wire signed [11:0] gx;
    wire signed [11:0] gy;


    // ---------------------------------------
    // Gradient magnitude
    // ---------------------------------------

    wire [23:0] magnitude;


    // ---------------------------------------
    // LINE BUFFER
    // ---------------------------------------

    line_buffer_3x3 #(
        .IMAGE_WIDTH(IMAGE_WIDTH)
    ) u_line_buffer (

        .clk(clk),
        .rst(rst),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_in),

        .p1(p1),
        .p2(p2),
        .p3(p3),

        .p4(p4),
        .p5(p5),
        .p6(p6),

        .p7(p7),
        .p8(p8),
        .p9(p9),

        .window_valid(window_valid)
    );


    // ---------------------------------------
    // SOBEL GRADIENT
    // ---------------------------------------

    sobel_gradient u_gradient (

        .p1(p1),
        .p2(p2),
        .p3(p3),

        .p4(p4),
        .p5(p5),
        .p6(p6),

        .p7(p7),
        .p8(p8),
        .p9(p9),

        .gx(gx),
        .gy(gy)
    );


    // ---------------------------------------
    // GRADIENT MAGNITUDE
    // ---------------------------------------

    gradient_magnitude u_magnitude (

        .gx(gx),
        .gy(gy),

        .magnitude(magnitude)
    );


    // ---------------------------------------
    // THRESHOLD
    // ---------------------------------------

    threshold u_threshold (

        .magnitude(magnitude),
        .edge_pixel(edge_pixel)
    );

endmodule