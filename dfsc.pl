#!/usr/local/bin/perl
use strict;
# input - .csv concept file from spreadsheet (ss) -  puts into matrix @gm
# @gm - col 1 is concept name/label, then inarcs to go into columns
# output - : starts each path, each node has a , after it
# cycles - if found node names framed with a !  - first one not repeated at end
# This is dfs.pl with checking for cycle(s) added, also minor changes

# Depth First Search - prints node (concept) names in order visited
# (would run faster if arc minimization done first -but wouldn't show all nodes)
# Looks for root node(s) first, does DFS, then does DFS for all unvisited nodes 
# DFS is described on pagese 219 and 221 in
# Data Structures and Algorithms
# Aho, Alfred V, John E. Hopcroft and Jeffrey D. Ullman 
# Addison-Wesley Publishing Co. Reading, Mass.  1983 

my (@gm, @nodein, @nodes, $nn, $i, $j, $k, $k1, $k2, $tmp, @tmp, @stack, 
    $debug1, $base, @visited, $found, $done, $hrn, $nrnl);

# @gm matrix format of graph rows show inarcs to nodes, columns outarcs from
#   (I think that some use it the other way - i.e.,transpose)
# @nodein array of one line of input
# @nodes array of node names
# @stack - to manage visiting nodes
# $base - node name in top of stack
# @visited - shows when node-name has been visited
# $found so stop at first ok entry in column
# $done when have visited all nodes Y, N
# $hrn have root node  Y, N, i.e. just found one
# $nrnl no root nodes left Y, N - so can stop looking
# $k, $k1, $k2 loop indices used in checking for cycle
# $i, $j indices - when used with @gm are respectively row, column indices

$debug1 = 0; # manages printing of debugging stuff - print when == 1

$i = 1; # start with row 1 for consistency with ss
$nodes[0]=""; # so start with row 1
while (<>) {
  chomp($_);
  @nodein = split (/,/, $_); # .csv
push (@nodes, shift (@nodein)); # concept name
  foreach $j (@nodein) { 
    $gm[$i][$j] = $j; # inarcs
  }
  $i++;
} # now have all of input arcs in 2D array @gm - also concept names in @nodes
$nn = $i-1; # index of last row = number of nodes (rows are 1, ..., $nn)
print "$nn nodes \n"; # just as a check

if ($debug1 == 1) {
for ($i=1; $i < $nn; $i++) { print "$nodes[$i],"; }
print "$nodes[$nn]\n"; # so get the last one without a trailing comma
print "--end of node names ---\n";
for ($i=1; $i <= $nn; $i++) {
    for ($j=1; $j < $nn; $j++) { print $gm[$i][$j], ","; }
  print "$gm[$i][$nn]\n";  # so get the last one without a trailing comma
} 
print "--end of ss graph info--\n";
} # end of $debug1 == 1

# starts search for unvisited node to use - first root(s) then rest
print "Sequence of nodes visited\n"; # each path will start with a ":"
$done = "N"; $nrnl ="N";
while ($done eq "N"){
  # find first root node in @gm, if any (i.e. find a row all undef)
   if ($nrnl eq "N") {
     $hrn = "N";
     for ($i=1; $i<=$nn; $i++) {#  print "row $i checking for root";
       if ($visited[$i] != 1) { #only go across unvisited nodes (rows)
         for ($j=1; $j<=$nn; $j++) { # print "$i $j - ";
           if ($gm[$i][$j] ne undef)  {$hrn="N";last}
         } #end of $j loop
         if ($j > $nn) {$hrn="Y"; last} # have (unvisited) root node
       }
     } # end of $i loop
     if ($hrn eq "Y") {$base = $i; $visited[$i]=1 }
     if ($i > $nn) {$nrnl = "Y"}
   } # end of   if ($nrnl eq "N")
  # when no root nodes left, find first unvisited node - if any
   if ($hrn eq "N") {
    $done = "Y";
    for ($i = 1; $i <= $nn; $i++) {
      if ($visited[$i] != 1){ $base = $i; $visited[$i]=1; $done = "N"; last}
    }
  }

  if ($done eq "Y") {last} # end if all nodes visited
  print ":"; # : indicates start of a new path, then each node has a , after it
  push (@stack, $base); # start with first root or unvisited node found

if ($debug1 == 1) {
  @tmp = "";
  foreach $tmp (@stack) { push (@tmp, $nodes[$tmp]) } # use names
  $tmp = join(" ", @tmp); 
  print ";", $tmp, "\n";
}
  print "$nodes[$base], "; # so print concept name

  while (scalar @stack > 0) { # finished when stack is empty
    $found = 0;
    # go down base @gm column - select first outarc, unvisited node
    for ($j = 1; $j <= $nn; $j++) # go down @gm column
      {
        if (($visited[$j] != 1) && ($gm[$j][$base] ne undef))
        {
          push(@stack, $j);
          # added another node to @stack - (already at least one there
          # because the first root/unvisited is at [0])
          # check for cycle - i.e. outarc to node earlier on stack - Aho p221
          for ($k = 1; $k <=$nn; $k++) { # find outarcs
            if ($gm[$k][$j] ne undef) { # found an outarc
              for ($k1 = 0; $k1 <$#stack; $k1++) {#chk stk for outarc dest
                if ($stack[$k1] == $k) {# if there print the cycle part of stack
                  for ($k2 = $k1; $k2 <= $#stack; $k2++) { 
                    print "!$nodes[$stack[$k2]]"; # node names bounded with !
                  } print "! "; # don't print the first one again
                }
              }
            }
          }
if ($debug1 == 1) {
  @tmp = "";
  foreach $tmp (@stack) { push (@tmp, $nodes[$tmp]) } # use names
  $tmp = join(" ", @tmp); 
  print ";", $tmp, "\n";
}
          $visited[$j] = 1; #marked as visited
          $base = $j;
        print "$nodes[$base], ";
        $found = 1;
        last; # have found one and pushed it to the stack
        }
      } # last  when found comes here

    if (scalar @stack == 0) { print "-done \n"; last } # ????? not executed ???
    if ($found == 0) {pop(@stack); $base = $stack[-1]}
  } # last just above should come here
}

if ($debug1 == 1) {
print "visited "; for ($j=1; $j <=6; $j++) {print "$visited[$j]"} print "\n";
} # end of $debug1 == 1
print "\n";
