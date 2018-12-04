module BitCounter(
    input clk, valid_in, reset, input reg [7:0]data_in,    
    output reg [2:0] data_out,    
    output reg ready_in,
    //isso serve para mostrar os estados como saidas
    output [1:0] outState     
);

    reg [2:0] cont0; 
    reg [2:0] cont1;
     reg [7:0] read_data;
     
     int i = 1;
    
    // Declare states
    enum reg [1:0] {IDLE, DATA_IN, COUNT} state;
    assign outState = state;
    
    // Determine the next state synchronously, based on the
    // current state and the input
    always @ (posedge clk or posedge reset) begin        
        if (reset)
            state <= IDLE;
        else            
            case (state)
                IDLE:
                    begin                                
                        ready_in <= 1'd1;
                        state <= DATA_IN;
                        i <= 1'd1;
                        cont0 <= 1'd0;
                        cont1 <= 1'd0;
                    end
                DATA_IN:
                    begin                        
                        if(valid_in)
                            begin
                                ready_in <= 1'd0;
                                read_data <= data_in;
                                state <= COUNT;
                            end
                        else
                            begin
                                state <= DATA_IN;
                            end
                    end
                COUNT:
                    begin                        
                                if(read_data[i] == 1)
                                    cont1 = cont1 + 1;    
                                else
                                    cont0 = cont0 + 1;
                                i = i + 1;
                                
                                if (i == 8)
                                    begin
                                        if(read_data[0] == 0)
                                            data_out <= cont0;
                                        else
                                            data_out <= cont1;
                                        state <= IDLE;                                
                                    end
                                else
                                    begin
                                        state <= COUNT;
                                    end                        
                    end                
            endcase
    end    
endmodule    