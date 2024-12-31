module phase_shift_calculator(
    input signed [7:0] ang_pitch,
    input signed [7:0] ang_azimuth,
    input [7:0] General_BID,
    output reg signed [7:0] PSB0, PSB1, PSB2, PSB3, PSB4, PSB5, PSB6, PSB7
);

    // Internal signal declarations
    wire [4:0] m_a;
    wire [4:0] m_p;
    reg signed [7:0] PSB_azimuth;
    reg signed [7:0] PSB_pitch [7:0];
    reg [4:0] m_p_element [7:0];
    integer i;

    // Calculate m_a and m_p
    assign m_a = (General_BID[5:4] << 3) + General_BID[2:0]; 
    assign m_p = General_BID[7:6] << 3;                      

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            m_p_element[i] = m_p + i;
        end
    end

    // Adjust ang_azimuth and ang_pitch to unsigned values for addressing
    wire [7:0] ang_azimuth_unsigned = ang_azimuth + 8'd128;
    wire [7:0] ang_pitch_unsigned   = ang_pitch + 8'd128;

    // Lookup PSB_azimuth using the single lookup table
    wire [12:0] addr_azimuth = {m_a, ang_azimuth_unsigned};
    reg signed [7:0] PSB_lookup_table [0:8191];

    initial begin
        $readmemh("./mem/psb_lookup_table.hex", PSB_lookup_table);
    end

    always @(*) begin
        PSB_azimuth = PSB_lookup_table[addr_azimuth];
    end

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            PSB_pitch[i] = PSB_lookup_table[{m_p_element[i], ang_pitch_unsigned}];
        end
    end

    always @(*) begin
        PSB0 = (PSB_azimuth + PSB_pitch[0]);
        PSB1 = (PSB_azimuth + PSB_pitch[1]);
        PSB2 = (PSB_azimuth + PSB_pitch[2]);
        PSB3 = (PSB_azimuth + PSB_pitch[3]);
        PSB4 = (PSB_azimuth + PSB_pitch[4]);
        PSB5 = (PSB_azimuth + PSB_pitch[5]);
        PSB6 = (PSB_azimuth + PSB_pitch[6]);
        PSB7 = (PSB_azimuth + PSB_pitch[7]);
    end

endmodule
