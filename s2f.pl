#!/usr/local/bin/perl -w
use strict;

# Read in short subject categories .tsv print out full .tsv version s2f

# Copyright (C) 2014 Henry E. Schaffer
# Creative Commons Attribution-NonCommercial 4.0 International License
# https://creativecommons.org/licenses/by-nc/4.0/

#            Variables Used
# # "c" stands for "concept"
# $data_line  to input one row of a database
# @data_row split $data_line at commas
# @c_table  internal version of c database  2D
# @full_c full version of @c_table 1D
# @full_c_table  full 2D version
# @short_c string version of @c_table to sort for spreadsheet input
# @sorted_c sorted table @full_c
# @fc  full concept table - for output

my ($i, $j,$data_line, @c_table, @data_row, $data_row_number,
    $c_file_name, %c, @sorted_c, @full_c, @short_c, @fc);

# Read concept (tsv) file
# read in gn-concept-table.csv  make a table @c_table (row 1 based)
# predecessor c(s) - up to 5, resources (string)

$data_row_number = 0; #NOTE: zero based, vs 1 based for spreadsheets!
while ( $data_line = <> ) {
  chomp($data_line);
  @data_row = split (/\t/,$data_line); #for .tsv file - change here for .csv
  for ($i = 0; $i < 7; $i++) { #get rid of undef values
    unless (defined $data_row[$i]) {$data_row[$i] = ""}
    }

# fill up table
  for ($j=0;$j < 7; $j++){
    $c_table[$data_row_number][$j] = $data_row[$j];
#    print $c_table[$data_row_number][$j], "*";
#    print $data_row[$j], "*";
  }
$data_row_number++;
}

# fill in for full version from .ods
for ($i = 0; $i < $data_row_number; $i++) { #for each concept
  $fc[$i][0] = $c_table[$i][0]; #concept (there always is one)
  for ($j = 1;$j<6;$j++) {  #predecessor concepts
    if ($c_table[$i][$j] ne "") {
      $fc[$i][$j] =  $c_table[$c_table[$i][$j] - 1][0]; 
    }
    else {
      $fc[$i][$j] =  "";
    }
  }
  $fc[$i][6] = $c_table[$i][6];
}

# now have everything in @fc 
for ($i = 0; $i < $data_row_number; $i++) { #for each concept
  for ($j = 0; $j < 6; $j++) {
#   print $i+1, "  ", $j+1, "\n";
    if ($fc[$i][$j] ne "") {
      print $fc[$i][$j], "\t";
    }
    else {
      print "\t";
    }
  }
# print $i, " 7 \n";
  print $fc[$i][6], "\n";
}
