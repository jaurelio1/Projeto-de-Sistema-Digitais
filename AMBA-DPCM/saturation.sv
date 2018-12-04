module saturation(input reg[7:0]data_in, 
						input clk, input reset,
						output [7:0]data_out						
);
	int limiar_sup = 8'b01111000;
	int limiar_inf = 8'b11111000;

	enum reg [1:0] {S0, S1, S2} state;	
	
	reg [7:0]read_data;
	reg [7:0]write_data;

	always @ (posedge clk or posedge reset)
		begin
			if(reset)
				state <= S0;
			else
				begin
					case(state)
						S0:
							begin
								read_data <= data_in;
								state <= S1;
							end
						S1:
							begin
								if(read_data > limiar_sup)
									write_data <= limiar_sup;
								else if(read_data < limiar_inf)
									write_data <= limiar_inf;
								else
									write_data <= read_data;
								state <= S2;
							end
						S2:
							begin
								data_out <= write_data;
								state <= S0;
							end
					endcase
				end
		end
endmodule 