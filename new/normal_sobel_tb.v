`timescale 1ns/1ps

module normal_sobel_tb;

    reg [7:0] p1, p2, p3;
    reg [7:0] p4, p5, p6;
    reg [7:0] p7, p8, p9;

    wire [7:0] edge_pixel;


    normal_sobel_top DUT (

        .p1(p1),
        .p2(p2),
        .p3(p3),

        .p4(p4),
        .p5(p5),
        .p6(p6),

        .p7(p7),
        .p8(p8),
        .p9(p9),

        .edge_pixel(edge_pixel)

    );


    initial begin

        // Test 1
        // Vertical intensity change

        p1 = 8'd0;
        p2 = 8'd0;
        p3 = 8'd255;

        p4 = 8'd0;
        p5 = 8'd0;
        p6 = 8'd255;

        p7 = 8'd0;
        p8 = 8'd0;
        p9 = 8'd255;

        #100;

        $display("Edge Pixel = %d", edge_pixel);


        // Test 2

        p1 = 8'd255;
        p2 = 8'd255;
        p3 = 8'd255;

        p4 = 8'd255;
        p5 = 8'd255;
        p6 = 8'd255;

        p7 = 8'd255;
        p8 = 8'd255;
        p9 = 8'd255;

        #100;

        $display("Edge Pixel = %d", edge_pixel);


        $finish;

    end

endmodule