#!/usr/bin/perl -w
use strict;
# Reads data in the Scantron .sdf format and writes it out in .csv format
#Copyright (C) 2014 by Henry E. Schaffer
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#hes@ncsu.edu  Box 7109 (OIT), NC State University, Raleigh, NC 27695-7109

#                      Variables Used
# $correct  string input from 1st sheet (which has the correct answers)
# $correctans string of correct answers
# $nq number of items/questions
# @ca individual correct answers  - 1-5 not offset
# $student (offset) index of each student
# $studentsheet  string of input of each student sheet
# $name  string holding names field
# $id string holding ID field
# $responses string of responses
# $i loop index

my ($correct, $correctans, $nq, $studentsheet, $name, $id, $responses, $i);

$correct = <>;  chomp($correct); #first sheet is correct answers
#two possible sets starting at 43 and 163 (0 based, 120 ea) - only use first
$correctans = substr($correct, 43, 120);
$correctans =~ s/[ ]*$//; #get rid of trailing blanks
$nq = substr($correct, 290, 3) + 0; #number of questions - change to number

print $nq, ",", "questions"; # start of 1st line of output
#output the correct ans csv
for ($i=0; $i<$nq; $i++){
print ",", substr($correctans, $i, 1);
}
print "\n"; #end of correct answers line

#read in answer sheets 1-per-student
while ($studentsheet = <>) {          # read/process all student answer sheets
  #note: answers are 1-5 or blank or "*" (can't be read) - output as read in
  chomp($studentsheet);
  $name = substr($studentsheet, 0, 19); #uc, last name first, whatever entered
  # so there might be leading/imbedded blanks, abbreviated names, ...
  $id = substr($studentsheet, 19, 9); #student ID 9 digits
  #ignore Sex(2), "Special Code"(6), birth year(2 digits), month(2) Education(2)
  $responses = substr($studentsheet, 43, $nq); #$nq <= 120
  print $name, ",", $id; #start of each student output - $nq answers
  for ($i=0; $i<$nq; $i++){
    print "," , substr($responses, $i, 1); #print each answer for the student
  }
  print "\n"; # end of responses for this student
}
