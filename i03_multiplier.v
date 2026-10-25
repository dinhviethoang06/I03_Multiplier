
module i03_multiplier (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [15:0] product,
    output reg busy,
    output reg done
);

    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [3:0] count;

    wire [15:0] sum_next;

    assign sum_next = multiplier[0]
                    ? accumulator + multiplicand
                    : accumulator;

    always @(posedge clk) begin
        if (rst) begin
            multiplicand <= 16'd0;
            multiplier   <= 8'd0;
            accumulator  <= 16'd0;
            product      <= 16'd0;
            count        <= 4'd0;
            busy         <= 1'b0;
            done         <= 1'b0;
        end else begin
            done <= 1'b0;

            if (start && !busy) begin
                multiplicand <= {8'b0, A};
                multiplier   <= B;
                accumulator  <= 16'd0;
                product      <= 16'd0;
                count        <= 4'd0;
                busy         <= 1'b1;
            end else if (busy) begin
                accumulator  <= sum_next;
                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;

                if (count == 4'd7) begin
                    product <= sum_next;
                    busy    <= 1'b0;
                    done    <= 1'b1;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule

