#!/usr/local/bin/perl -w
use strict;
# Process results of 1 quiz (qwm) - produce report with  section for 
# each student plus class summary for instructor
# read in 3 .tsv files - all exported from spreadsheet or other
# Copyright (C) 2014, 2017 Henry E. Schaffer
# Creative Commons Attribution-NonCommercial 4.0 International License
# https://creativecommons.org/licenses/by-nc/4.0/

#               Variables Used
# $debug used to control debugging printing
# "c" stands for "concept"
# $data_line  to input one row of a database
# @data_row split $data_line at commas
# @c_table  internal version of c database
#   Note: spreadsheet tables are 1 based, tables here may or may not be
# @sqp_table  internal version of sqp database
# $s_name  student name/id 3rd column of @sqp_table/database
# @qwm_internal version of qwm database - omits text fields
# $data_row_number
# %c_hash c string -> @c_table row ?
# $i $j $k index
# $tmp $ tmp1  temporary/local
# $nqq number of questions in quiz
# $nqc number of questions correct for a student
# $ns number of students
# $c_file_name name of concept file
# $sqp_file_name  ditto for sqp
# $qwm_file_name  ditto for qwm
# %c hash of concepts used in a quiz - indexed by concept row number (1, ...)
# $q_name name of quiz
# @qbp quiz Bloom's profile - list of L, M, H
# %qbp quiz Bloom's profile  level -> count
# @qbl quiz Bloom's list - level for each question
# @qct quiz concept tally
# %qcc quiz concept count - uses row of concept
# %qcm quiz concept missed count
# $swarn fraction of concept occurances missed - above which triggers warning
# @sbp student Bloom's profile - list of L, M, H
# %sbp student Bloom's profile  level -> count
# @scm student concepts missed list
# %sccm student clumped missed concepts
# @sbm students missed Bloom's level over whole class quiz
# $c_name  
# $c_missed

my ($i, $j,$k,$data_line, @c_table, @data_row, $data_row_number,$nqq,$tmp,
    $c_file_name, $sqp_file_name, $qwm_file_name, @qwm_table, @sqp_table,
    $ns, %c, $nqc, @qbp, %qbp, $debug, @scm, @qbl, @sbp, %sbp, %sccm,$q_name,
    $c_name, $c_missed, $tmp1, @qct, %qcc, %qcm,$swarn, $s_name, @sbm );

$debug = 0;
$swarn = .5;

$c_file_name = "gn-concept-table.tsv";
$sqp_file_name = "sqp-ex.tsv";
$qwm_file_name = "qwm-ex.tsv";

# Read concept (.tsv) file
open(IN, $c_file_name) || die "can not open $c_file_name to read: $!";

$data_row_number = 0; #NOTE: zero based, vs 1 based for spreadsheets!
while ( $data_line = <IN> ) {
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
close(IN) || die "can not close $c_file_name; $!";

if ($debug == 1){
#for debugging print contents of @c_table - space separated
  for ($i = 0; $i < $data_row_number; $i++) {
    for ($j = 0;$j<7;$j++) {
      print $c_table[$i][$j], " ";
     }
     print "\n";
  }
}

#read in qwm (.tsv) file
$data_row_number = 0; #NOTE: zero based, vs 1 based for spreadsheets!
open(IN, $qwm_file_name) || die "can not open $qwm_file_name to read: $!";
while ( $data_line = <IN> ) {
  chomp($data_line);
  @data_row = split (/\t/,$data_line); #for .tsv file - change here for .csv
  # 15 columns in the .tsv file - only use 8 for $qwm_table
  for ($i = 0; $i < 15; $i++) { #get rid of undef values
    unless (defined $data_row[$i]) {$data_row[$i] = ""}
    }

# fill up table 
    $qwm_table[$data_row_number][0] = $data_row[0]; # Quiz ID
    $qwm_table[$data_row_number][1] = $data_row[1]; # # of questions
  for ($j=8;$j < 15; $j++){
    $qwm_table[$data_row_number][$j-6] = $data_row[$j]; #skip 6 fields
    if ($j > 9 && ($data_row[$j] ne "")) {
      push (@qct, $data_row[$j]);
    }
#     add each quiz concept encountered to @qct - will include duplicates
#     will count unique ones into %qcc 
  }
$data_row_number++;
}
close(IN) || die "can not close $qwm_file_name; $!";

if ($debug == 1)
{
#for debugging print contents of @qwm_table - * separated
  for ($i = 0; $i < $data_row_number; $i++) {
    for ($j = 0;$j<8;$j++) {
      print $qwm_table[$i][$j], "*";
     }
     print "\n";
  }
}

$nqq = $qwm_table[0][1];#$nqq+2 is number of fields- quiz ID in [0], $nqq in [1]
#read in sqp (.tsv) file
$data_row_number = 0; #NOTE: zero based, vs 1 based for spreadsheets!
open(IN, $sqp_file_name) || die "can not open $qwm_file_name to read: $!";
while ( $data_line = <IN> ) {
  chomp($data_line);
  @data_row = split (/\t/,$data_line); #for .tsv file - change here for .csv
  for ($i = 0; $i < $nqq + 2; $i++) { #get rid of undef values
    unless (defined $data_row[$i]) {$data_row[$i] = ""}
    }

# fill up table
    $sqp_table[$data_row_number][0] = $data_row[0]; # Quiz ID
  for ($j=1;$j < $nqq+2; $j++){
    $sqp_table[$data_row_number][$j] = $data_row[$j]; #skip 1st field
  }
$data_row_number++;
}
$ns = $data_row_number;

close(IN) || die "can not close $sqp_file_name; $!";

if ($debug == 1){
#for debugging print contents of @sqp_table - space separated
  for ($i = 0; $i < $data_row_number; $i++) {
    for ($j = 0;$j<$nqq+2;$j++) {
      print $sqp_table[$i][$j], " ";
     }
     print "\n";
  }
}

# ---have concepts, qwm and sqp in @c_table, @qwm_table, @sqp_table ---

$q_name = $sqp_table[0][0]; #name of quiz
@qbl = (); # clear profile list
%qbp = (); # make sure profile hash is clear
%qcm = (); # make sure count of wrong is clear
@sbm = ();
# @qct = (); # list of each concept encountered in quiz - incl. duplicates
%qcc = (); # count of each unique concept in @qct
for ($i = 0; $i < $nqq; $i++) { #loop through all questions
  $qbp{$qwm_table[$i][3]}++; # quiz Bloom's profile, how many L, M, H
  $qbl[$i] = $qwm_table[$i][3]; # list each question's Bloom's level
}
for ($k = 0; $k < scalar(@qct); $k++) { # fill in quiz concept tally
  $qcc{$qct[$k]}++; # have hash of counts of each unique concept
}

#$ns determined above from sqp input
for ($i = 0; $i < $ns; $i++) { #iterate over all students in @sqp_table
  $nqc = 0; @scm = (); %sccm=(); %sbp = (); #initialize for each student
  $s_name = $sqp_table[$i][1]; # this student's name/ID 
  for ($j = 0; $j < $nqq; $j++) { # iterate over all questions for this student
    if ($sqp_table[$i][$j+2] == 1) {$nqc++} #add up correct answers for student
    else {       # get concept(s) missed for jth question
                 # from jth row of @qwm_table, columns 4-8
     for ($k = 4; $k < 9; $k++) { # 0-5 concepts may be there
       #this works with multiple concepts in an item 
       if ($qwm_table[$j][$k] ne "") {push(@scm, $qwm_table[$j][$k])};
       }
     $sbp{$qwm_table[$j][3]}++;#student Bloom's profile, how many L,M,H missed
    }
  } #finished with all questions for student $i

print "\nStudent ", $s_name, " : ", $q_name, " : ", $nqc, " correct";
printf "%4d", int(100*$nqc/$nqq + 0.5); print "%\n"; #  grade in %
  unless ($nqc == $nqq) { # so don't do for students with 100% correct
    unless (defined  $sbp{"L"}) {$sbp{"L"} = 0}; # if none missed print a 0
    unless (defined  $sbp{"M"}) {$sbp{"M"} = 0};
    unless (defined  $sbp{"H"}) {$sbp{"H"} = 0};
    print "Bloom's profile of missed concepts";
    printf "%3d%s%3d%s%3d%s", $sbp{"L"}, "L", $sbp{"M"}, "M", $sbp{"H"}, "H\n"; 
    $sbm[0] += $sbp{"L"}; #accumulate for class quiz missed
    $sbm[1] += $sbp{"M"};
    $sbm[2] += $sbp{"H"};
  }

if ($debug == 1){
  for ($k = 0; $k < scalar(@scm); $k++) {print $scm[$k], " ";}
  print " : missed concepts \n";
}

  if (scalar(@scm)) { #only do this if >0 concepts missed
    for ($k = 0; $k < scalar(@scm); $k++) {
      $sccm{$scm[$k]}++; #wrong for this student
      $qcm{$scm[$k]}++;  #add to total wrong for all students
    } 
  }

  unless ($nqc == $nqq) { # skip for students with 100% correct
    print "# missed       concept\n";
    while (($c_name, $c_missed) = each (%sccm)) {
      printf "%6d      ", $c_missed; # how many of this concept missed
      print $c_table[$c_name-1][0]; # name of concept
      if ($c_missed / $qcc{$c_name} > $swarn) {
        print "*";
      }
    print "\n";
    }
  }
} #end of iterating over all students 

# Now print overall report for faculty member
print "\n$q_name has ", $nqq, " questions\n";
print "            Concept -        # of questions - % missed\n";
while (($tmp, $tmp1) = each (%qcc)) { #count is in $tmp1 
unless (defined $qcm{$tmp}) {$qcm{$tmp} =0}
  printf "%35s%6d",$c_table[$tmp-1][0],  $tmp1; 
  printf "%9d%s",  int(100*$qcm{$tmp}/($ns * $tmp1) +0.5), "\n"; 
  #concept, count, % missed
}

# for whole quiz - report on Bloom's performance
print "\n    L    M    H     quiz Bloom's profile \n"; 
printf "%5d%5d%5d%s\n", $qbp{"L"}, $qbp{"M"}, $qbp{"H"}, 
  "     questions at each level"; 
printf "%5d%5d%5d%s\n", int(100*$sbm[0]/($qbp{"L"}*$ns)+0.5), 
  int(100*$sbm[1]/($qbp{"M"}*$ns)+0.5),  int(100*$sbm[2]/($qbp{"H"}*$ns)+0.5), 
  "     % each level is missed";
  # Note change decimal fraction to rounded %
