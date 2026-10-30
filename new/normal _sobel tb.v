`timescale 1ns/1ps

module normal_sobel_tb;

    parameter IMAGE_WIDTH  = 256;
    parameter IMAGE_HEIGHT = 256;
    parameter TOTAL_PIXELS = IMAGE_WIDTH * IMAGE_HEIGHT;

    reg clk;
    reg rst;
    reg pixel_valid;
    reg [7:0] pixel_in;

    wire [7:0] edge_pixel;
    wire       window_valid;

    reg [7:0] image_mem [0:TOTAL_PIXELS-1];

    integer i;
    integer output_file;
    integer valid_count;
    integer edge_count;

    // =========================================================
    // DUT
    // =========================================================

    normal_sobel_top #(
        .IMAGE_WIDTH  (IMAGE_WIDTH),
        .IMAGE_HEIGHT (IMAGE_HEIGHT)
    ) DUT (
        .clk          (clk),
        .rst          (rst),
        .pixel_valid  (pixel_valid),
        .pixel_in     (pixel_in),
        .edge_pixel   (edge_pixel),
        .window_valid (window_valid)
    );


    // =========================================================
    // CLOCK
    // =========================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // =========================================================
    // MAIN TESTBENCH
    // =========================================================

    initial begin

        // -----------------------------------------------------
        // Initial values
        // -----------------------------------------------------

        rst         = 1'b1;
        pixel_valid = 1'b0;
        pixel_in    = 8'd0;

        valid_count = 0;
        edge_count  = 0;


        // =====================================================
        // LOAD IMAGE
        // =====================================================

        $display("");
        $display("==============================================");
        $display("             LOADING INPUT IMAGE");
        $display("==============================================");

        $readmemh(
            "C:/Users/ashwa/OneDrive/Documents/Desktop/project/project_1/image 2.txt",
            image_mem
        );


        // =====================================================
        // IMAGE MEMORY CHECK
        // =====================================================

        $display("");
        $display("==============================================");
        $display("             IMAGE MEMORY CHECK");
        $display("==============================================");

        $display(
            "image_mem[0]     = %02h",
            image_mem[0]
        );

        $display(
            "image_mem[1]     = %02h",
            image_mem[1]
        );

        $display(
            "image_mem[2]     = %02h",
            image_mem[2]
        );

        $display(
            "image_mem[100]   = %02h",
            image_mem[100]
        );

        $display(
            "image_mem[65535] = %02h",
            image_mem[65535]
        );

        $display("==============================================");
        $display("");


        // =====================================================
        // OPEN OUTPUT FILE
        // =====================================================

        output_file = $fopen(
            "C:/Users/ashwa/OneDrive/Documents/Desktop/project/project_1/sobel_output.mem",
            "w"
        );

        if (output_file == 0) begin

            $display(
                "ERROR: Could not create sobel_output.mem"
            );

            $finish;

        end
        else begin

            $display(
                "SUCCESS: sobel_output.mem opened successfully"
            );

        end


        // =====================================================
        // RESET
        // =====================================================

        #20;

        rst = 1'b0;


        // =====================================================
        // SEND IMAGE PIXELS
        // =====================================================

        for (i = 0; i < TOTAL_PIXELS; i = i + 1) begin

            // -------------------------------------------------
            // Apply current image pixel
            // -------------------------------------------------

            pixel_in    = image_mem[i];
            pixel_valid = 1'b1;


            // -------------------------------------------------
            // Wait for clock
            // -------------------------------------------------

            @(posedge clk);

            #2;


            // =================================================
            // VALID 3x3 WINDOW
            // =================================================

            if (window_valid) begin

                valid_count = valid_count + 1;


                // =================================================
                // DEBUG FIRST 20 WINDOWS
                // =================================================

                if (valid_count <= 20) begin

                    $display("");
                    $display("----------------------------------------------");
                    $display(
                        "DEBUG WINDOW %0d",
                        valid_count
                    );
                    $display("----------------------------------------------");


                    $display(
                        "Pixel Index = %0d",
                        i
                    );

                    $display(
                        "Row         = %0d",
                        i / IMAGE_WIDTH
                    );

                    $display(
                        "Column      = %0d",
                        i % IMAGE_WIDTH
                    );


                    $display("");
                    $display("3x3 Window:");


                    $display(
                        "%02h  %02h  %02h",
                        DUT.p1,
                        DUT.p2,
                        DUT.p3
                    );


                    $display(
                        "%02h  %02h  %02h",
                        DUT.p4,
                        DUT.p5,
                        DUT.p6
                    );


                    $display(
                        "%02h  %02h  %02h",
                        DUT.p7,
                        DUT.p8,
                        DUT.p9
                    );


                    $display("");


                    $display(
                        "GX        = %0d",
                        DUT.gx
                    );


                    $display(
                        "GY        = %0d",
                        DUT.gy
                    );


                    $display(
                        "Magnitude = %0d",
                        DUT.magnitude
                    );


                    $display(
                        "Edge      = %0d",
                        edge_pixel
                    );


                    // -------------------------------------------------
                    // IMPORTANT: Show exactly what is being written
                    // -------------------------------------------------

                    $display(
                        "WRITE     = %02h",
                        edge_pixel
                    );


                    $display("----------------------------------------------");

                end


                // =================================================
                // WRITE RTL OUTPUT
                // =================================================

                $fwrite(
                    output_file,
                    "%02h\n",
                    edge_pixel
                );


                // =================================================
                // COUNT NON-ZERO EDGES
                // =================================================

                if (edge_pixel != 8'h00) begin

                    edge_count = edge_count + 1;

                end


                // =================================================
                // SPECIAL CHECK AROUND FIRST VALID PIXEL
                // =================================================

                if ((i >= 510) && (i <= 519)) begin

                    $display(
                        "WRITE CHECK: Index=%0d Row=%0d Col=%0d Edge=%02h",
                        i,
                        i / IMAGE_WIDTH,
                        i % IMAGE_WIDTH,
                        edge_pixel
                    );

                end

            end


            // =================================================
            // INVALID 3x3 WINDOW
            // =================================================

            else begin

                $fwrite(
                    output_file,
                    "00\n"
                );

            end

        end


        // =====================================================
        // STOP INPUT
        // =====================================================

        pixel_valid = 1'b0;
        pixel_in    = 8'd0;


        // =====================================================
        // WAIT
        // =====================================================

        #20;


        // =====================================================
        // CLOSE OUTPUT FILE
        // =====================================================

        $fclose(output_file);


        // =====================================================
        // FINAL RESULTS
        // =====================================================

        $display("");

        $display("==============================================");
        $display("       NORMAL SOBEL PROCESSING COMPLETE");
        $display("==============================================");


        $display(
            "Image Width      = %0d",
            IMAGE_WIDTH
        );


        $display(
            "Image Height     = %0d",
            IMAGE_HEIGHT
        );


        $display(
            "Total Pixels     = %0d",
            TOTAL_PIXELS
        );


        $display(
            "Valid Windows    = %0d",
            valid_count
        );


        $display(
            "Non-zero Edges   = %0d",
            edge_count
        );


        $display("");
        $display("Output File:");
        $display(
            "C:/Users/ashwa/OneDrive/Documents/Desktop/project/project_1/sobel_output.mem"
        );


        $display("==============================================");
        $display("");


        $display("==============================================");
        $display("OUTPUT FILE CREATED");
        $display("==============================================");


        $finish;

    end

endmodule