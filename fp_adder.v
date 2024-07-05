`timescale 1ns/1ns

module fp_adder(
//------------------------------------decelering ports------------------------------------
   input [31:0] a,
   input [31:0] b,
   output [31:0] s
);
//------------------------------------decelering wires------------------------------------
   wire [7:0]Ex_a;
   wire [26:0]adad_a;
   wire [7:0]EX_a; 

   wire [7:0]Ex_b;
   wire [26:0]adad_b;
   wire [7:0]EX_b; 

   wire [8:0]EmainshiftEXp;

   wire [26:0]preadad_1;
   wire [26:0]adad_1;
   wire [26:0]adad_2;

   wire [7:0]shift_1;
   
   wire [25:0]preonebit;
   wire onebit;

   wire [7:0]EX_1;
   wire [7:0]EX_2; 

   wire sign_1;
   wire sign_2;

   wire [28:0]Final_adad_1;
   wire [28:0]Final_adad_2;

   wire [28:0]presum;
   wire [28:0]sum;

   wire [4:0]OneLead;
   wire checker;

   wire [28:0]shifted_sum;
   wire [28:0]shiftedsum;
   wire [27:0]Shiftedsum;

   wire [8:0]stkShift;
   wire [28:0]forsticky;
   wire forstickyor;
   wire [28:0]prenormalizedsum;

   wire [28:0]normalizedsum;
   wire [28:0]reshifted_normalizedsum;

   wire [22:0]SUM;

   wire [7:0]de_exp;
   wire [7:0]exp;
   wire [7:0]EXP;

//------------------------------------combo logic part------------------------------------
   assign Ex_a = a[30:23];//Exponent
   assign adad_a = {Ex_a == 0 ? 1'b0 : 1'b1, a[22:0], 2'b00};//unpack and bulid the number in right format
   assign EX_a = Ex_a == 0 ? {8'b00000001} : Ex_a;//Check denormalize range for EXP = 0

   assign Ex_b = b[30:23];
   assign adad_b = {Ex_b == 0 ? 1'b0 : 1'b1, b[22:0], 2'b00};
   assign EX_b = Ex_b === 0 ? {8'b00000001} : Ex_b;

   assign EmainshiftEXp = EX_b - EX_a;//diffrence between two Exponent

   assign preadad_1 = EmainshiftEXp[8] == 0 ? adad_a : adad_b;//Small number Before build with shift and onebit in LSB

   assign shift_1 = EmainshiftEXp[8] ? (~EmainshiftEXp[7:0]+1) : EmainshiftEXp[7:0];//Andaze Ekhtelaf Exponent - Andaze shift
   assign preonebit = shift_1 > 26 ? preadad_1 : preadad_1 << (26 - shift_1);//Bits for OR together

   assign onebit = |preonebit;//build that one bit

   assign adad_1 = {preadad_1 >> shift_1, onebit};//Smaller number with shift
   assign EX_1 = EmainshiftEXp[8] == 0 ? EX_a : EX_b;
   assign sign_1 = EmainshiftEXp[8] == 0 ? a[31] : b[31];

   assign adad_2 = EmainshiftEXp[8] == 0 ? adad_b : adad_a;//Bigger number
   assign EX_2 = EmainshiftEXp[8] == 0 ? EX_b : EX_a;
   assign sign_2 = EmainshiftEXp[8] ? a[31] : b[31];

   assign Final_adad_1 = sign_1==0 ? {sign_1, sign_1, adad_1} : {sign_1, sign_1, (~adad_1 + 1)};//Using previous adad_1 for sign----adad_1 with onebit
   assign Final_adad_2 = sign_2==0 ? {sign_2, sign_2, adad_2, 1'b0} : {sign_2, sign_2, (~adad_2 + 1), 1'b0};//put 0 for being same bits with Final_adad_1

   assign presum = Final_adad_1 + Final_adad_2;//main sum
   assign sum  = presum[28]==0 ? presum : (~presum + 1) ;//positive sum (andaze)
 
   assign OneLead = sum[27] ? 27 :
              sum[26] ? 26 :
              sum[25] ? 25 :
              sum[24] ? 24 :
              sum[23] ? 23 :
              sum[22] ? 22 :
              sum[21] ? 21 :
              sum[20] ? 20 :
              sum[19] ? 19 :
              sum[18] ? 18 :
              sum[17] ? 17 :
              sum[16] ? 16 :
              sum[15] ? 15 :
              sum[14] ? 14 :
              sum[13] ? 13 :
              sum[12] ? 12 :
              sum[11] ? 11 :
              sum[10] ? 10 :
              sum[9] ? 9:
              sum[8] ? 8 :
              sum[7] ? 7 :
              sum[6] ? 6 :
              sum[5] ? 5 :
              sum[4] ? 4 :
              sum[3] ? 3 :
              sum[2] ? 2 :
              sum[1] ? 1 : 0; 
   assign checker = OneLead < 26 ? 1 : 0;//checkers for Onelead location

   assign shifted_sum = checker ? sum << (26 - OneLead) : sum >> (OneLead - 26);//Right shift or left shift
   assign shiftedsum = OneLead + EX_2 > 26 ? shifted_sum : sum << (EX_2 - 1);//check for denormalize numbers
   assign Shiftedsum = shiftedsum[28:1];//save for going to rounding(bulid sticky bit)

   assign stkShift = checker ? 28 : 54 - OneLead;//Andaze shift baraye sakht sticky bit
   assign forsticky = sum << stkShift;//bits for OR
   assign forstickyor = |forsticky;//Sticky bit
   assign prenormalizedsum = {Shiftedsum,forstickyor};//Before rounding

   assign normalizedsum = prenormalizedsum[2] == 0 ? prenormalizedsum ://Rounding
                prenormalizedsum[1] == 1 ? (prenormalizedsum + 4'b1000) :
                prenormalizedsum[0] == 1 ? (prenormalizedsum + 4'b1000) :
                prenormalizedsum[3] == 0 ? prenormalizedsum : (prenormalizedsum + 4'b1000);
   assign reshifted_normalizedsum = normalizedsum[27]==0 ? normalizedsum : normalizedsum >> 1;//normalize after rounding
   assign SUM = reshifted_normalizedsum[25:3];//Sum output

   assign de_exp = OneLead + EX_2 > 26 ? (EX_2 + OneLead - 26 ) : 8'b00000000;//For denormalize range
   assign exp = |sum ? de_exp : 8'b00000000;
   assign EXP = normalizedsum[27]==0 ? exp : exp + 1;//normalize after rounding - Exp output

//------------------------------------output------------------------------------
   assign s = 
   (a[30:0] == 0) ? b :
   (b[30:0] == 0) ? a :
   {presum[28], EXP, SUM};//Using previous sum for sign

endmodule