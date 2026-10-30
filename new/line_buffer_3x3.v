module line_buffer_3x3 #(
    parameter IMAGE_WIDTH  = 256,
    parameter IMAGE_HEIGHT = 256
)(
    input        clk,
    input        rst,
    input        pixel_valid,
    input  [7:0] pixel_in,

    output reg [7:0] p1, p2, p3,
    output reg [7:0] p4, p5, p6,
    output reg [7:0] p7, p8, p9,

    output reg       window_valid
);

    // Two previous image rows
    reg [7:0] line_buffer1 [0:IMAGE_WIDTH-1];
    reg [7:0] line_buffer2 [0:IMAGE_WIDTH-1];

    integer col;
    integer row;
    integer i;

    reg [7:0] row1_pixel;
    reg [7:0] row2_pixel;

    always @(posedge clk) begin

        if (rst) begin

            col <= 0;
            row <= 0;

            p1 <= 0;
            p2 <= 0;
            p3 <= 0;

            p4 <= 0;
            p5 <= 0;
            p6 <= 0;

            p7 <= 0;
            p8 <= 0;
            p9 <= 0;

            window_valid <= 0;

            row1_pixel = 0;
            row2_pixel = 0;

            for (i = 0; i < IMAGE_WIDTH; i = i + 1) begin
                line_buffer1[i] <= 0;
                line_buffer2[i] <= 0;
            end

        end

        else if (pixel_valid) begin

            // Get pixels from the two previous rows
            row1_pixel = line_buffer1[col];
            row2_pixel = line_buffer2[col];

            // Update line buffers
            line_buffer2[col] <= line_buffer1[col];
            line_buffer1[col] <= pixel_in;


            // ------------------------------------------------
            // Build 3x3 window
            // ------------------------------------------------

            p1 <= p2;
            p2 <= p3;
            p3 <= row2_pixel;

            p4 <= p5;
            p5 <= p6;
            p6 <= row1_pixel;

            p7 <= p8;
            p8 <= p9;
            p9 <= pixel_in;


            // ------------------------------------------------
            // Valid window
            //
            // A complete 3x3 window exists after:
            // two previous rows + two previous columns
            // ------------------------------------------------

            if ((row >= 2) && (col >= 2))
                window_valid <= 1'b1;
            else
                window_valid <= 1'b0;


            // ------------------------------------------------
            // End of row
            // ------------------------------------------------

            if (col == IMAGE_WIDTH - 1) begin

                col <= 0;

                if (row == IMAGE_HEIGHT - 1)
                    row <= 0;
                else
                    row <= row + 1;


                // IMPORTANT:
                // Clear horizontal shift registers at
                // the beginning of a new row.
                //
                // This prevents pixels from the previous
                // row from entering the next row's window.

                p1 <= 0;
                p2 <= 0;
                p3 <= 0;

                p4 <= 0;
                p5 <= 0;
                p6 <= 0;

                p7 <= 0;
                p8 <= 0;
                p9 <= 0;

            end

            else begin

                col <= col + 1;

            end

        end

        else begin

            window_valid <= 1'b0;

        end

    end

endmodule