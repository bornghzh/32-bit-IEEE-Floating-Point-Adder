
`timescale 1ns/1ns

module fp_adder__tb3;

   wire [31:0] s;
   reg[31:0] a, b, expected_s;
   shortreal ar, br, sr;
   int errors, no_of_tests = 1;

   fp_adder uut (
          .a( a ),
          .b( b ),
          .s( s )
        );
   
   initial begin
      test_vector(32'h00000000, 32'h00000000, 32'h00000000);
      test_vector(32'h440d491c, 32'h4d064db7, 32'h4d064dda);
      test_vector(32'h366b66c4, 32'h42307eb7, 32'h42307eb8);
      test_vector(32'h12e1798b, 32'h121f73da, 32'h131899bc);
      test_vector(32'h575360bf, 32'h5c673cd6, 32'h5c6771ae);
      test_vector(32'h422d54dc, 32'h368e0d66, 32'h422d54dd);
      test_vector(32'h49f7442b, 32'h50781481, 32'h50781c3b);
      test_vector(32'h18502b00, 32'h16d47f61, 32'h186abaec);
      test_vector(32'h4d675968, 32'h4ad42cf7, 32'h4d6dfad0);
      test_vector(32'h5d240588, 32'h55797cfe, 32'h5d240681);
      test_vector(32'h285248db, 32'h27251643, 32'h287b8e6c);
      test_vector(32'h01925662, 32'h81b81010, 32'h8096e6b8);
      test_vector(32'h00012832, 32'h0014283c, 32'h0015506e);
      test_vector(32'h00012832, 32'h8014283c, 32'h8013000a);
      test_vector(32'h00b627be, 32'h000a21a8, 32'h00c04966);
      test_vector(32'h00b627be, 32'h800a21a8, 32'h00ac0616);
      test_vector(32'h02682174, 32'h826f0850, 32'h803736e0);
      test_vector(32'h00d47943, 32'h80c67efc, 32'h000dfa47);
      test_vector(32'h440d491c, 32'h00000000, 32'h440d491c);
      test_vector(32'h00004002, 32'h00000002, 32'h00004004);
      test_vector(32'h3F800001, 32'hBF800001, 32'h00000000);
      test_vector(32'h3F800001, 32'hBF800000, 32'h34000000);
      test_vector(32'h40000000, 32'h34000000, 32'h40000000);
      test_vector(32'h40000000, 32'h34000001, 32'h40000001);
      test_vector(32'h3fffffff, 32'h34000000, 32'h40000000);
      test_vector(32'h440d491c, 32'h40000000, 32'h440dc91c);
      test_vector(32'h407fffff, 32'h347fffff, 32'h40800000);
      test_vector(32'h407fffff, 32'h34000000, 32'h40800000);
      test_vector(32'h407fffff, 32'h34400000, 32'h40800000);
      test_vector(32'h4d064db7, 32'h440d491c, 32'h4d064dda);
      test_vector(32'h42307eb7, 32'h366b66c4, 32'h42307eb8);
      test_vector(32'h121f73da, 32'h12e1798b, 32'h131899bc);
      test_vector(32'h5c673cd6, 32'h575360bf, 32'h5c6771ae);
      test_vector(32'h368e0d66, 32'h422d54dc, 32'h422d54dd);
      test_vector(32'h50781481, 32'h49f7442b, 32'h50781c3b);
      test_vector(32'h16d47f61, 32'h18502b00, 32'h186abaec);
      test_vector(32'h4ad42cf7, 32'h4d675968, 32'h4d6dfad0);
      test_vector(32'h55797cfe, 32'h5d240588, 32'h5d240681);
      test_vector(32'h27251643, 32'h285248db, 32'h287b8e6c);
      test_vector(32'h81b81010, 32'h01925662, 32'h8096e6b8);
      test_vector(32'h0014283c, 32'h00012832, 32'h0015506e);
      test_vector(32'h8014283c, 32'h00012832, 32'h8013000a);
      test_vector(32'h000a21a8, 32'h00b627be, 32'h00c04966);
      test_vector(32'h800a21a8, 32'h00b627be, 32'h00ac0616);
      test_vector(32'h826f0850, 32'h02682174, 32'h803736e0);
      test_vector(32'h80c67efc, 32'h00d47943, 32'h000dfa47);
      test_vector(32'h00000000, 32'h440d491c, 32'h440d491c);
      test_vector(32'h00000002, 32'h00004002, 32'h00004004);
      test_vector(32'hBF800001, 32'h3F800001, 32'h00000000);
      test_vector(32'hBF800000, 32'h3F800001, 32'h34000000);
      test_vector(32'h34000000, 32'h40000000, 32'h40000000);
      test_vector(32'h34000001, 32'h40000000, 32'h40000001);
      test_vector(32'h34000000, 32'h3fffffff, 32'h40000000);
      test_vector(32'h40000000, 32'h440d491c, 32'h440dc91c);
      test_vector(32'h347fffff, 32'h407fffff, 32'h40800000);
      test_vector(32'h34000000, 32'h407fffff, 32'h40800000);
      test_vector(32'h34400000, 32'h407fffff, 32'h40800000);
      test_vector(32'h15ffc7d4, 32'h1f7fabc1, 32'h1f7fabe1);

      #84;
      $display("\n\nStart of Comprehensive Random Test Vector Application\n\n");

      errors = 0;
      no_of_tests = 200;
      for (int i = 1; i <= no_of_tests; i++) begin
         random_test_vector();
         $display("@%10t ns: %9d random test vectors are applied", $time, i * 255 * 255 * 2 * 2);
      end

      $display("%d (%%%0d) errors are found.\n", errors, (errors*100.0)/(no_of_tests));
      $stop;
   end
      
   task random_test_vector;
   begin
      reg[1:0] sa, sb;
      reg [7:0] ea, eb;
      reg [22:0] frac_a, frac_b;
      for (ea = 0; $unsigned(ea) <= 254; ea++) begin
         for (eb = 0; $unsigned(eb) <= 254; eb++) begin
            for (sa = 0; $unsigned(sa) <= 1; sa++) begin
               for(sb =0; $unsigned(sb) <= 1; sb++) begin
                  frac_a = $random();
                  frac_b = $random();
                  a = {sa[0], ea, frac_a};
                  b = {sb[0], eb, frac_b};
                  ar = $bitstoshortreal(a);
                  br = $bitstoshortreal(b);
                  expected_s = $shortrealtobits(ar + br);
                  #2;
                  sr = $bitstoshortreal(s);
                  if (s != expected_s && expected_s[30:23]!=255 && a[30:23]!=255 && b[30:23]!=255) begin
                     errors++;
                     $display("Error! Error! Error! Error!\n%8x (%f) + %8x (%f) = expected %8x (%f) but got %8x\nError Location: %b", a, ar, b, br, expected_s, ar + br, s, s ^ expected_s);
                     $stop;  
                  end
                  //else
                     //$display("%g + %g = %g", ar, br, sr);
               end
            end
         end
      end
   end
   endtask
      
   task test_vector;
   input[31:0] x1, x2, sum;
   begin      
      if (x1[30:23] != 8'hff && x2[30:23] != 8'hff && sum[30:23] != 8'hff) begin
         {a, b} = {x1, x2};      
         #2;   
         $write("%8x + %8x = %8x, got %8x, ", x1, x2, sum, s);
         if (s !== sum) begin
            $display("Error, Location: %b\n", s ^ sum);
            $stop;
         end
         else
            $write("OK\n");
      end
   end   
   endtask
endmodule
