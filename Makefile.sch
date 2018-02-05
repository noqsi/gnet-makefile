v 20130925 2
C 40000 40000 0 0 0 title-B.sym
C 47400 45700 1 0 0 gnet-osmond.sym
{
T 48700 47000 5 10 1 1 0 0 1
refdes=R3
}
C 44600 46900 1 0 0 gschem.sym
{
T 45300 47600 5 10 1 1 0 0 1
refdes=R1
}
C 44600 45200 1 0 0 gschem.sym
{
T 45300 45900 5 10 1 1 0 0 1
refdes=R2
}
N 47400 44000 47400 47300 4
C 40500 48700 1 0 0 makefile-prolog.sym
{
T 42000 50500 5 10 1 1 0 0 1
refdes=Boilerplate
}
C 45600 46800 1 0 0 schematic.sym
{
T 46900 47900 5 10 1 1 0 0 1
refdes=S1
T 46500 47300 5 10 1 1 0 4 1
source=example.1.sch
}
C 45600 45100 1 0 0 schematic.sym
{
T 46900 46200 5 10 1 1 0 0 1
refdes=S2
T 46500 45600 5 10 1 1 0 4 1
source=example.2.sch
}
C 49200 45900 1 0 0 netlist.sym
{
T 50500 47000 5 10 1 1 0 0 1
refdes=F1
T 50100 46400 5 10 1 1 0 4 1
file=example.net
}
C 51000 44800 1 0 0 command.sym
{
T 52300 45900 5 10 1 1 0 0 1
refdes=C1
T 51900 45300 5 10 1 1 0 4 1
value=all-products
}
C 47400 43300 1 0 0 partslist1.sym
{
T 48700 44600 5 10 1 1 0 0 1
refdes=R4
}
C 49200 43500 1 0 0 partslist.sym
{
T 50500 44600 5 10 1 1 0 0 1
refdes=P1
T 50100 43700 5 10 1 1 0 4 1
file=example.parts.txt
}
N 51000 44000 51000 46400 4
