module threshold (
    input  [23:0] magnitude,
    output reg [7:0] edge_pixel
);

    parameter THRESHOLD =90;

    always @(*) begin

        if (magnitude > THRESHOLD)
            edge_pixel = 8'd255;
        else
            edge_pixel = 8'd0;

    end

endmodule