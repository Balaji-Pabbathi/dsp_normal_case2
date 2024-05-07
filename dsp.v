
module main#(parameter data_width=16)(
    input clk,
    input en,
    input s_axis_valid_a,
    input [data_width-1:0] s_axis_data_a,
    input s_axis_last_a,
    output s_axis_ready_a,
    
    input s_axis_valid_b,
    input [data_width-1:0] s_axis_data_b,
    input s_axis_last_b,
    output s_axis_ready_b,
    
     input s_axis_valid_c,
    input [data_width-1:0] s_axis_data_c,
    input s_axis_last_c,
    output s_axis_ready_c,
    
    output m_axis_valid,
  output [(2*data_width):0] m_axis_data,
    output m_axis_last,
    input m_axis_ready
   
   
);


assign s_axis_ready_a=m_axis_ready;

assign s_axis_ready_b=m_axis_ready;

assign s_axis_ready_c=m_axis_ready;

reg [data_width-1:0] a;
reg a_last;
reg a_valid;   //considering input will go if all the data inputs are valid only
reg [data_width-1:0] b;
reg b_last;
 
reg [data_width-1:0] c;
reg c_last;

reg [data_width-1:0] y;
reg last;
reg valid;

always@(posedge clk)
    begin
        if(~en)
            begin
                a<=0;
                a_last<=0;
                a_valid<=0;
             
                b<=0;
        
                b_last<=0;
                c<=0;
                c_last<=0;
         
            end
        else if((s_axis_valid_a &&s_axis_ready_a)&&(s_axis_valid_b &&s_axis_ready_b)&&(s_axis_valid_c &&s_axis_ready_c))
            begin
                a<=s_axis_data_a;
                a_last<=s_axis_last_a;
                a_valid<=s_axis_valid_a;
              
                b<=s_axis_data_b;
                b_last<=s_axis_last_b;
               
                c<=s_axis_data_c;
                c_last<=s_axis_last_c;
                 
               
            end
     
                
                
    end        
  
  
  always@(posedge clk)
    	begin
    if(~en)
      	begin
           y<= 0;
                last<=0;
                valid<=0;
        end
  	else
      	begin
           y<= (a+b)*c;
           last<=(a_last && b_last && c_last);
           valid<=a_valid;
        end
        end
  
  	
    	
    
    assign m_axis_data=y;
    
    assign m_axis_valid=valid;
    
    assign m_axis_last=last;     
                





endmodule



//testbench

module test;
  
  parameter data_width=8;
  
  reg clk;
  
  reg en;
  
  reg [data_width-1:0]  s_data1;
  
  reg s_valid1;
  
  reg s_last1;
  
  reg [data_width-1:0]  s_data2;
  
  reg s_valid2;
  
  reg s_last2;
  
  reg [data_width-1:0]  s_data3;
  
  reg s_valid3;
  
  reg s_last3;
  
  wire s_ready1;
  
  wire s_ready2;
  
  wire s_ready3;
  
  
  wire [(2*data_width):0] m_data;
  
  wire m_valid;
  
  wire m_last;
  
  reg m_ready;
  
  main uut(clk,en,s_valid1,s_data1,s_last1,s_ready1,s_valid2,s_data2,s_last2,s_ready2,s_valid3,s_data3,s_last3,s_ready3,m_valid,m_data,m_last,m_ready);
  
  
  initial begin
    $dumpfile("a.vcd");
    $dumpvars;
  end
  
  initial begin
    	clk=0;
    	forever #5 clk=~clk;
  end 
  
  initial begin
    	en=0;
    	m_ready=0;
    	#10;
    
    	en=1;
    	m_ready=1;
    
    	data;
    
    	#100;
        $finish;
    
  end  
  
  
  task data;
    begin
     
      repeat(10)
        	begin
              @(posedge clk)
					s_data1<=$random;
              		s_valid1<=1;
              		s_last1<=0;
              		
              		s_data2<=$random;
              		s_valid2<=1;
              		s_last2<=0;
              		
              		s_data3<=$random;
              		s_valid3<=1;
              		s_last3<=0;
            end
      
         @(posedge clk)
					s_data1<=$random;
              		s_valid1<=1;
              		s_last1<=1;
              		
              		s_data2<=$random;
              		s_valid2<=1;
              		s_last2<=1;
              		
              		s_data3<=$random;
              		s_valid3<=1;
              		s_last3<=1;
      @(posedge clk)
					s_data1<=0;
              		s_valid1<=0;
              		s_last1<=0;
              		
              		s_data2<=0;
              		s_valid2<=0;
              		s_last2<=0;
              		
              		s_data3<=0;
              		s_valid3<=0;
              		s_last3<=0;
      
      
      
      
      
      
    end
    
  endtask  
  
  
endmodule
  
 
