module normal_sobel_top (

    input [7:0] p1, p2, p3,
    input [7:0] p4, p5, p6,
    input [7:0] p7, p8, p9,

    output [7:0] edge_pixel

);

    wire signed [11:0] gx;
    wire signed [11:0] gy;

    wire [23:0] magnitude;


    // Sobel gradient calculation
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


    // Gradient magnitude
    gradient_magnitude u_magnitude (

        .gx(gx),
        .gy(gy),

        .magnitude(magnitude)

    );


    // Threshold
    threshold u_threshold (

        .magnitude(magnitude),
        .edge_pixel(edge_pixel)

    );

endmodule