#!/usr/bin/perl
#======================================================================================
# File Name: 		connect_gen.pl
# Project Name:	AHB_Gen
# Email:         quanghungbk1999@gmail.com
# Version    Date      Author      Description
# v0.0       29/11/2020 Quang Hung  First Creation, this version does not support
#                                   hsplit & hretry
#======================================================================================

use 5.016;
use warnings;
use strict;

use Spreadsheet::Read qw(ReadData);
my $sample = '../Sample/AHB_bus.sv';
my $AHB_config = '../Input/AHB_config.xlsx';
my $dest = '../Gen_Result/AHB_bus.sv';
my $data = ReadData(${AHB_config});
#say "A1 " . $data->[2]{A1};
my $spe = "@";

print ("****************************************************************************\n");
print ("                              AHB_config\n");
print ("****************************************************************************\n");
print (" File Name: 	connect_gen.pl\n");
print (" Project Name:	AHB_Gen\n");
print (" Email:         quanghungbk1999${spe}gmail.com\n");
print (" Version    Date      Author      Description\n");
print (" v0.0       29/11/2020 Quang Hung  First Creation, this version does not support\n");
print ("                                   hsplit & hretry\n");
print ("****************************************************************************\n");
print ("                              AHB_config\n");
print ("****************************************************************************\n");

my $sheet_1_name = say $data->[1]{A1};
my $sheet_2_name = say $data->[2]{A1};
my $sheet_3_name = say $data->[3]{A1};
my @sheet_1_data = Spreadsheet::Read::rows($data->[1]);
my @sheet_2_data = Spreadsheet::Read::rows($data->[2]);
my @sheet_3_data = Spreadsheet::Read::rows($data->[3]);

open(SAMPLE, "<${sample}") or die "CAN'T open sample file"; 
open(DEST, ">${dest}");



while (my $line = <SAMPLE>)
{
  #db print ("db_2\n");
  $line =~ s///;
  print DEST "$line";
  if($line =~ /#SI#/)
  {
    foreach my $i_1 (0 .. scalar @sheet_1_data)
    {
      if(($sheet_1_data[$i_1][0] eq 'DECODER_IDENTIFY') && ($sheet_1_data[$i_1][1] ne 'sample'))
      {
        my $master_name = $sheet_1_data[$i_1][1];
        print DEST ("\tmas_send_type  ${master_name}_in,\n");
      }
    }
  }
  elsif($line =~ /#MI#/)
  {
    foreach my $i_1 (0 .. scalar @sheet_3_data)
    {
      if(($sheet_3_data[$i_1][0] eq 'ARBITER_IDENTIFY') && ($sheet_3_data[$i_1][1] ne 'sample'))
      {
        my $slave_name = $sheet_3_data[$i_1][1];
        print DEST ("\tslv_send_type  ${slave_name}_in,\n");
      }
    }
    print DEST ("\tinput\t\t\t\t\t hclk,\n");
    print DEST ("\tinput\t\t\t\t\t hreset_n\n");
  }
  elsif($line =~ /#SIGGEN#/) 
  {
    foreach my $i_1 (0 .. scalar @sheet_1_data)
    {
      if(($sheet_1_data[$i_1][0] eq 'DECODER_IDENTIFY') && ($sheet_1_data[$i_1][1] ne 'sample'))
      {
        my $master_name = $sheet_1_data[$i_1][1];
        $i_1++;
        $i_1++;
        $i_1++;
        my $slave_num = $sheet_1_data[$i_1][1];
        print DEST ("\tlogic [${slave_num}-1:0][MI_PAYLOAD-1:0] payload_${master_name}_in;\n");
        print DEST ("\tlogic [MI_PAYLOAD-1:0] payload_${master_name}_out;\n");
      }
    }
    foreach my $i_1 (0 .. scalar @sheet_3_data)
    {
      if(($sheet_3_data[$i_1][0] eq 'ARBITER_IDENTIFY') && ($sheet_3_data[$i_1][1] ne 'sample'))
      {
        my $slave_name = $sheet_3_data[$i_1][1];
        $i_1++;
        $i_1++;
        $i_1++;
        my $master_num = $sheet_3_data[$i_1][1];
        print DEST ("\tlogic [${master_num}-1:0][SI_PAYLOAD-1:0] payload_${slave_name}_out;\n");
        print DEST ("\tlogic [SI_PAYLOAD-1:0] payload_${slave_name}_out;\n");
      }
    }
  }
  elsif($line =~ /#DECGEN#/)
  {
    foreach my $i_1 (0 .. scalar @sheet_1_data)
    {
      if(($sheet_1_data[$i_1][0] eq 'DECODER_IDENTIFY') && ($sheet_1_data[$i_1][1] ne 'sample'))
      {
        my $master_name = $sheet_1_data[$i_1][1];
        print DEST ("\tAHB_decoder_${master_name} DEC_${master_name}");
        print DEST ("\t(\n"); 
        print DEST ("\t\t.haddr(haddr_${master_name}),\n");
        print DEST ("\t\t.htrans(htrans_${master_name}),\n");
        print DEST ("\t\t.hremap(hremap_${master_name}),\n");
        print DEST ("\t\t.hsplit(hsplit_${master_name}),\n");
        print DEST ("\t\t.default_slv_sel(default_slv_sel_${master_name}),\n");
        print DEST ("\t\t.hreq(hreq_${master_name}),\n");
        print DEST ("\t\t.*\n");
        print DEST ("\t);\n\n\n");  
        print DEST ("\tAHB_mux_${master_name} MUX_${master_name}\n");  
        print DEST ("\t(\n");  
        print DEST ("\t\t.payload_in(payload_${master_name}_in),\n");  
        print DEST ("\t\t.payload_out(payload_${master_name}_out),\n");  
        print DEST ("\t\t.sel(sel_${master_name})\n");  
        print DEST ("\t);\n");  
      }
    }
  }
  elsif($line =~ /#ARBGEN#/)
  {
    foreach my $i_1 (0 .. scalar @sheet_3_data)
    {
      if(($sheet_3_data[$i_1][0] eq 'ARBITER_IDENTIFY') && ($sheet_3_data[$i_1][1] ne 'sample'))
      {
        my $slave_name = $sheet_3_data[$i_1][1];
        $i_1++;
        $i_1++;
        $i_1++;
        $i_1++;
        my $prior = $sheet_3_data[$i_1][1];
        print DEST ("\tAHB_arbiter_${slave_name } ARB_${slave_name}\n");
      }
    }
  }
}



close(SAMPLE);
close(DEST);

