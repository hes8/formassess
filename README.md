# formassess
Automated Individualized Formative Feedback Based on a Directed Concept Graph

See: -- citation of article in Frontiers in Educational Psychology ----
Figure references refer to that article.

This is accomplished by a computer program which analyzes student
performance on a multiple choice assessment based on metadata.

Auxiliary programs are included to transform the concept chart into
different formats to enhance the ease of use.
The concept and quiz metadata are read in as tab separated variable
files - probably entered into spreadsheets by the faculty member or
someone, and then exported into .tsv files for use by the programs
discussed below.

The data on student performance on quizzes (i.e. the correct/incorrect
answers) usually is downloaded from a Learning Management System (e.g.
Moodle, BlackBoard, ...) or from a scan of mark-sense forms. (For 
Scantron scanners which output .sdf files, the script sdf2csv.pl uses
that file to produce a .csv file.) In all of these cases, the data may 
need to be reformatted and further processed to get it into the sqp.tsv 
format needed by the process.pl script.

The Perl scripts and the .tsv files included produce the examples shown
in the manuscript. Later versions of the Perl script have additional
capabilities mentioned in the manuscript, but don't change the main
functions.

process.pl reads in 3 files - all in .tsv format (concept-table.tsv,
qwm.tsv and sqp.tsv). This is an easy way to export from a spreadsheet
and avoids any problems with regards to the possible use of commas in
the Resources field of the Concept Table. The names of the 3 files must
be entered into the script a few rows below the variable declarations.
Outut is via >.

s2f.pl short-to-long version of the concept table file
  reads in the short-form .tsv concept file via <, output long-form via >
f2s.pl long-to-short version of the concept table file
  reads in the long-form .tsv concept file via <, output short-form via >
sco.pl student version of the concept table file
  reads in the short-form .tsv concept file via <, output via >

All of the Perl scripts were used with Perl 5, version 16.

                       Files and Their Formats

Concept Table: Concept; 5 IPCs (if fewer than 5 are used, the remaining
ones are left blank); Resource(s)  Example: gn-concept-table.tsv Figs 1-2

Quiz with Metadata (qwm): Quiz name (left blank after first row); number
of questions (left blank after first row); Stem of Question; First-Fifth
Answer choices (which aren't used in the processing); Correct answer
(A-E); Bloom's level; 5 IPCs (if fewer than 5 are used, the remaining
ones are left blank) Example: qwm-ex.tsv Fig. 4

Student Quiz Performance (sqp): Quiz name (left blank after first row);
student id; correct/incorrect for each question (the number of questions
is given in the qwm) Example: sqp-ex.tsv Fig. 5

          Concept Table - formats and processing between them

The concept spreadsheet uses line numbers to show the concept row for
each IPC as shown in Figures 1 and 2. That greatly reduces typing, and
eliminates typographical errors. When the concept spreadsheet is
downloaded as a .tsv that's called the "short version", and this is what
is used in processing quizzes. It is inflexible - rows can't be deleted
or changed in order. Rows added must be added at the bottom. The full
version removes these constraints.

The "full version" uses the concept names for each IPC. It is better for
faculty reading and revising as it eliminates the need to keep on
referring to spreadsheet line numbers. It also allows
adding/removing/moving rows as desired. The down side is that if any
revisions are made, the spelling/spacing of the concepts must *not* be
altered at all. I.e. the concept entries in the IPC columns must be
identical to the concepts given in the Concept column.

s2f.pl and f2s.pl change the .tsv versions between short and full.
The short version is the only one which can be used for processing.

For student use, neither spreadsheet version is desireable. Rather the
students are presented as a "student version" (not a spreadsheet) which
has the Concepts listed in alphabetical order with the IPCs and
Resources listed below each concept. See Fig. 7.

sco.pl produces the student version. It uses the short version as input.
There is no reason why it couldn't use the full version - but that's not
what it does.

                            Examples of Use

To read in gn-concept-table.tsv (Fig. 1), qwm-ex.tsv  (Fig. 4) and
sqp-ex.tsv (Fig. 5) and output the report (Fig. 6)
$ ./process.pl

To read in the short version and output the full version into a file,
and vice versa
$ ./s2f.pl < gn-concept-table.tsv > full-gn-concept-table.tsv
$ ./f2s.pl < full-gn-concept-table.tsv > gn-concept-table.tsv

To produce the student version of the concept table (Fig. 7)
Actually prints out the full table, not just the top as shown in Fig. 7
$ ./sco.pl < gn-concept-table.pl

Copyright (C) 2017 Henry E. Schaffer
# License: Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
