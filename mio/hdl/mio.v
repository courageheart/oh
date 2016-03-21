module mio (/*AUTOARG*/
   // Outputs
   tx_full, tx_prog_full, tx_empty, rx_full, rx_prog_full, rx_empty,
   tx_access, tx_packet, rx_wait, wait_out, access_out, packet_out,
   // Inputs
   clk, io_clk, nreset, datasize, ddr_mode, lsbfirst, tx_en, rx_en,
   tx_wait, rx_clk, rx_access, rx_packet, access_in, packet_in,
   wait_in
   );

   //#####################################################################
   //# INTERFACE
   //#####################################################################

   //parameters
   parameter PW    = 104;           // data width (core)
   parameter N     = 8;             // Mini IO width
   localparam CW   = $clog2(2*PW/N);// transfer count width
   
   // reset, clk, config
   input           clk;          // main core clock   
   input 	   io_clk;       // clock for TX
   input 	   nreset;       // async active low reset
   input [7:0] 	   datasize;     // size of data transmitted
   input 	   ddr_mode;	 // dual data rate mode
   input 	   lsbfirst;     // send data lsbfirst
   input 	   tx_en;        // enable transmit
   input 	   rx_en;        // enable receive
   
   // status
   output 	   tx_full;
   output 	   tx_prog_full;
   output 	   tx_empty;
   output 	   rx_full;
   output 	   rx_prog_full;
   output 	   rx_empty;
      
   // tx interface
   output 	   tx_access;    // access signal for IO
   output [N-1:0]  tx_packet;    // packet for IO
   input 	   tx_wait;      // pushback from IO
   
   // rx interface
   input 	   rx_clk;       // rx clock
   input 	   rx_access;    // rx access
   input [N-1:0]   rx_packet;    // rx packet
   output 	   rx_wait;      // pushback from IO

   // core interface
   input 	   access_in;    // fifo data valid
   input [PW-1:0]  packet_in;    // fifo packet  
   output 	   wait_out;     // wait pushback for fifo

   output 	   access_out;   // fifo data valid
   output [PW-1:0] packet_out;   // fifo packet
   input 	   wait_in;      // wait pushback for fifo
   
   /*AUTOOUTPUT*/
   /*AUTOINPUT*/
   /*AUTOWIRE*/
      
   mtx #(.N(N),
	 .PW(PW))
   mtx (/*AUTOINST*/
	// Outputs
	.wait_out			(wait_out),
	.tx_access			(tx_access),
	.tx_packet			(tx_packet[N-1:0]),
	// Inputs
	.clk				(clk),
	.io_clk				(io_clk),
	.nreset				(nreset),
	.tx_en				(tx_en),
	.datasize			(datasize[7:0]),
	.ddr_mode			(ddr_mode),
	.lsbfirst			(lsbfirst),
	.access_in			(access_in),
	.packet_in			(packet_in[PW-1:0]),
	.tx_wait			(tx_wait));
   
   mrx #(.N(N),
	 .PW(PW))
   mrx (/*AUTOINST*/
	// Outputs
	.rx_empty			(rx_empty),
	.rx_full			(rx_full),
	.rx_prog_full			(rx_prog_full),
	.rx_wait			(rx_wait),
	.access_out			(access_out),
	.packet_out			(packet_out[PW-1:0]),
	// Inputs
	.clk				(clk),
	.nreset				(nreset),
	.datasize			(datasize[7:0]),
	.ddr_mode			(ddr_mode),
	.lsbfirst			(lsbfirst),
	.rx_clk				(rx_clk),
	.rx_access			(rx_access),
	.rx_packet			(rx_packet[N-1:0]),
	.wait_in			(wait_in));
      
endmodule // mio


