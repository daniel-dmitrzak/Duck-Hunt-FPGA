`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2017 06:55:28 PM
// Design Name: 
// Module Name: gun_ctl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gun_ctl(

    );
    
    xadc_wiz_0 gun_adc(
        .daddr_in(),
        .dclk_in(),
        .den_in(),
        .di_in(),
        .dwe_in(),
        .reset_in(),
        .vauxp4(),
        .vauxn4(),
        .busy_out(),
        .channel_out(),
        .do_out(),
        .drdy_out(),
        .eoc_out(),
        .eos_out(),
        .alarm_out(),
        .vp_in(),
        .vn_in()
    );
    
endmodule
