module DPCM(input reg [7:0] data_in,
				input clk, input reset,
				output reg [7:0] total,
				output [1:0] outStateDPCM
);
	reg [7:0] ant = 8'b00000000;
	reg [7:0] x;	
	
	wire [7:0] wire_data_in;
	wire [7:0] wire_data_out;	
	
	saturation s(wire_data_in, clk, reset, wire_data_out);	 
	
	enum reg [1:0] {S0, S1, S2} stateDPCM;
	assign outState = stateDPCM;
	
	always @ (posedge clk or posedge reset)
		begin
		if(reset)
			stateDPCM <= S0;
		else
			case(stateDPCM)
				S0:
					begin
						x <= data_in - ant;						
						stateDPCM <= S1;
					end
				S1:
					begin
						wire_data_in <= x;
						stateDPCM <= S2;
					end
				S2:
					begin
						total <= wire_data_out;
						ant <= total;
						stateDPCM <= S0;
					end
			endcase				
		end
endmodule 