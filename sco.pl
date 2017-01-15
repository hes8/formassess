#!/usr/local/bin/perl -w
use strict;

# Read in short subject categories .tsv (via <) print out full student version
# - make a table @c_table (row 1 based)
# predecessor c(s) - up to 5, resources (string)

#Copyright (C) 2014 Henry E. Schaffer
# License Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

#                             Variables Used
# $debug used to control debugging printing
# # "c" stands for "concept"
# $data_line  to input one row of a database
# @data_row split $data_line at commas
# @c_table  internal version of c database  2D
# @full_c full version of @c_table 1D
# @full_c_table  full 2D version
# @short_c string version of @c_table to sort for spreadsheet input
# @sorted_c sorted table @full_c
# @fsc  full student concept table - to hold student version for sorting/print
# @sfsc sorted @fsc

my ($i, $j,$data_line, @c_table, @data_row, $data_row_number,
    $c_file_name, %c, $debug, @sorted_c, @full_c, @short_c, @fsc, @sfsc);

$debug = 0;

# Read concept (tsv) file
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

# fill in for full version from .ods, sort, then print - for students

# First Concept, next Resource(s) - then Immediate Predecessor Concepts
#   use spaces not tabs so control indent
#   write to a table, sort, then print

# $fsc[$i][0] the concept
# $fsc[$i][1] the "list" of IPCs
# $fsc[$i][2] the resources
# @sfsc is @fsc sorted by concept

for ($i = 0; $i < $data_row_number; $i++) { #for each concept
  $fsc[$i][0] = $c_table[$i][0]; #concept (there always is one)
  $fsc[$i][1] = ""; $fsc[$i][2] = ""; #so they are defined
  for ($j = 1;$j<6;$j++) {  #predecessor concepts
    if ($c_table[$i][$j] ne "") {
      if ($j > 1) {$fsc[$i][1] .= "; "} #put in separator for IPCs
      $fsc[$i][1] .=  $c_table[$c_table[$i][$j] - 1][0]; 
                                       #correct for row offset
    }
   $fsc[$i][2] = $c_table[$i][6];
  }
}

#have everything in @fsc but in .ods order
@sfsc = sort {lc $a->[0] cmp lc $b->[0]} @fsc; #sort alphabetically by concept
                                               # i.e. column [0]
for ($i = 0; $i < $data_row_number; $i++) { #for each concept
  print $sfsc[$i][0], "\n"; #concept
  if ($sfsc[$i][2] ne ""){
    print "  Resource Page(s): ", $sfsc[$i][2], "\n"; #Resources
  }
  if ($sfsc[$i][1] ne ""){
    print "  Relevant Predecessor Concepts: ", $sfsc[$i][1], "\n"; #IPC(s)
  }
}
print "\n";
