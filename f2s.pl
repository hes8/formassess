#!/usr/local/bin/perl -w
use strict;

# Read in full concept categories .tsv print out short .tsv version  f2s

#Copyright (C) 2014 Henry E. Schaffer
# License Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

#                             Variables Used
# "c" stands for "concept"
# $data_line  to input one row of a database
# @data_row split $data_line at commas
# $data_row_number eventually the number of rows
# @c_table  internal version of c database  2D
# %c hash of concepts
# $tmp, $tmp2  - tmp variables

my ($i, $j,$data_line, @c_table, @data_row, $data_row_number,
    $c_file_name, %c, $tmp, $tmp2);

# Read full concept (tsv) file
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
#    print $c_table[$data_row_number][$j], "*\n";
#    print $data_row[$j], "*";
  }
$data_row_number++;
}

# shorten @c_table in place
for ($i = 0; $i < $data_row_number; $i++) { # make a hash
  $c{$c_table[$i][0]} = $i; #make a hash: concept is key, row (0 based)is value
}

for ($i = 0; $i < $data_row_number; $i++) { #for each concept
  for ($j = 1; $j < 6; $j++) { #shorten the IPC values
    if ($c_table[$i][$j] ne ""){ #only shorten if there is an IPC
      if ( defined  $c{$c_table[$i][$j]}) { #check if the IPC matches a concept
        $c_table[$i][$j] = $c{$c_table[$i][$j]} +1; #restore 1 based row
      }
      else { # error if a full IPC doesn't match any Concept
        print "row $i+1  column $j+1  cannot find $c_table[$i][$j] \n";
      }
    }
  }
}

for ($i = 0; $i < $data_row_number; $i++) { #print each shortened concept row
  for ($j = 0; $j < 6; $j++) {
      print $c_table[$i][$j], "\t"; #tab separator
  }
    print $c_table[$i][6], "\n"; #end of row
}
