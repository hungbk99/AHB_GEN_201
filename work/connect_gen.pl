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
}



close(SAMPLE);
close(DEST);

#foreach my $i_1 (0 .. scalar @sheet_3_data)
#{
#  if(($sheet_3_data[$i_1][0] eq 'ARBITER_IDENTIFY') && ($sheet_3_data[$i_1][1] ne 'sample'))
#  {
#    my $slave_name = $sheet_3_data[$i_1][1];
#
#    open(SAMPLE, "<${sample}") or die "CAN'T open sample file"; 
#    open(DEST, ">>${dest}");
#
#    while (my $line = <SAMPLE>)
#    {
#      #db print ("db_2\n");
#      #$line =~ s///;
#      print DEST "$line";
#      if($line =~ /#MI#/)
#      {
#        print DEST ("\tslv_send_type  ${slave_name}_in \n");
#      }
#    close(SAMPLE);
#    close(DEST);
#    }
#  }
#}
