module elevator(seconds,req_floor,clk,reset,over_weight,
					 requested_floor,up,weight_alert,down,open_door,rescue,responce_rescue,out1);
	
  //input ports
  input wire clk;
  input wire reset;
  input wire rescue;
  input wire over_weight;
  input  [3:0] requested_floor;

  //output ports
  output wire up;
  output wire weight_alert;
  output wire down;
  output wire open_door;
  output wire responce_rescue;
  output [3:0] req_floor;
  output reg seconds;

	
  //registers
  reg [3:0] current_floor_reg;  // using
  reg up_pressed;
  reg down_pressed;
  reg door_open;
  reg weight_over;
  reg rescue_alert;
		
	
  always @(posedge seconds or posedge reset) begin
		
		
		
    //if we have reset signal
    if (reset) begin
	 
      current_floor_reg <= 4'b0000;
      up_pressed <= 1'b0;
      down_pressed <= 1'b0;
      door_open <= 1'b0;
		end
		
		
	else if(rescue) begin
		
		up_pressed <= 1'b0;
      down_pressed <= 1'b0;
		rescue_alert <= 1'b1;
		
		end
		
	else 	if(over_weight) begin
	
		up_pressed <= 1'b0;
      down_pressed <= 1'b0;
		weight_over <= 1'b1;
		door_open <= 1'b1;
		
    end else begin  // here starts the normal working mode of elevator -->>
	 
	 

      if (current_floor_reg < requested_floor) begin
		
        current_floor_reg <= current_floor_reg + 1;
        up_pressed <= 1'b1;
        down_pressed <= 1'b0;
		  
      end else if (current_floor_reg > requested_floor) begin
		
		
        current_floor_reg <= current_floor_reg - 1;
        up_pressed <= 1'b0;
        down_pressed <= 1'b1;
		  
		  
      end else begin
		
        up_pressed <= 1'b0;
        down_pressed <= 1'b0;
		  
		  
      end
      
      if (current_floor_reg == requested_floor && door_open == 1'b0) begin
		
        door_open <= 1'b1;
		  
      end else begin
		
        door_open <= 1'b0;
		  
      end
		
    end
	 
  end
  
  

  assign req_floor = current_floor_reg;
  assign up = up_pressed;
  assign down = down_pressed;
  assign open_door = door_open;
  assign weight_alert = weight_over;
  assign responce_rescue = rescue_alert;
 
 
 
  output [13:0] out1;
  wire [6:0] o1,o2;
  sev_Seg(requested_floor,o1);
  sev_Seg(current_floor_reg,o2);
  assign out1 = {o2,o1};
  
  

endmodule


module sev_Seg(bcd,s);
     
    
     input wire [3:0] bcd;
     output wire [6:0] s;
     reg [6:0] seg;

	  assign s = seg;	
		
		
    always @(bcd)
    begin
        case (bcd) //case statement
         4'b0000 : seg = 7'b1000000;
			4'b0001 : seg = 7'b1111001;
			4'b0010 : seg = 7'b0100100;
			4'b0011 : seg = 7'b0110000;
			4'b0100 : seg = 7'b0011001;
			4'b0101 : seg = 7'b0010010;
			4'b0110 : seg = 7'b0000010;
			4'b0111 : seg = 7'b1111000;
			4'b1000 : seg = 7'b0000000;
			4'b1001 : seg = 7'b0011000;
			default: seg = 7'b1111111;
        endcase
    end
    
endmodule

module delay (clk,seconds);
 
output reg seconds; 

input clk;
 
reg [26:0] count;

always @(posedge clk) 
begin 
if (count == 27'd25_000_000) 
begin

count = 0; 
seconds=~seconds;

end else begin
count <= count + 1'b1;

end
end 
endmodule
