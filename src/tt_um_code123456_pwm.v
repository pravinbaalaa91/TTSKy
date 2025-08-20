module tt_um_code123456_pwm (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // Clock signal
    input  wire       rst_n     // Active-low reset
);

    // Active-low reset → convert to active-high
    //wire reset = ~rst_n;

    // Duty cycle from ui_in[6:0]
    wire [6:0] dc = ui_in[6:0];
    reg pwm_out;
    reg pwm_out1;

    // Internal PWM module
    pwm pwm_inst (
        .clk(clk),
        .rst_n(~rst_n),
        .dc(dc),
        .pwm_out(pwm_out),
        .pwm_out1(pwm_out1)
    );

    // Map outputs
    assign uo_out[0] = pwm_out;
    assign uo_out[1] = pwm_out1;
    assign uo_out[7:2] = 0;

    // Not using bidirectional IOs
    assign uio_oe[7:0] = 0;
    assign uio_out[7:0] = 0;
    wire _unused = &{ui_in[7], uio_in[7:0], ena};
endmodule
