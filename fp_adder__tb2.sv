
`timescale 1ns/1ns

module fp_adder__tb2();

  reg [31:0] s_true, a, b;

  shortreal ar,br;
  int errors, no_of_tests;

  initial begin
  
    errors = 0;
    no_of_tests = 2000000;
    for (int i = 0; i < no_of_tests; i++) begin
      a = $random();
      b = $random();
      ar = $bitstoshortreal(a);
      br = $bitstoshortreal(b);
      s_true = $shortrealtobits(ar+ br);
      #10;
      if (uut.s != s_true && s_true[30:23] != 255 && a[30:23] != 255 && b[30:23] != 255) begin
        $write("\tError: %8x + %8x, expected: %8x, but got: %8x\n", a, b, s_true, uut.s);
        errors++;
        $stop;  
      end
      if(i && i % 20000 == 0)
         $display("No. of random tests applied: %0d", i);
    end

    $display("%d (%%%0d) errors are found.\n", errors, (errors*100.0 + no_of_tests/2)/(no_of_tests + 1));
    $stop;  
  end

  fp_adder uut( .a(a), .b(b), .s());
  
endmodule
