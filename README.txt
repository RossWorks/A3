The A3 (Airplane Aerodynamic Analysis) is tool developed in GNU Octave to estimate lift and drag of an airplane.
For its estimation it uses the prandtl lifting line, with expedient aimed to improve performance and accuracy.

The script make use of plain text files to receive input and produce output. some basic graphs are also plotted at runtime.

INPUT

in the INPUT_FILES directory lie several .DAT files:
  INPUT.DAT
  The first line sets which analysis is requested: 101 calculates the wing performance at a defined incidence, while 102 analyses the behaviour of the wing at several incidences
  the second line determines the flying altitude to comopute the freestream condition. Input -1 to enforce arbitray conditions.
  3rd to 6th lines determine the SLS conditions and flight Mach
  7th line sets the incidence of freestream velocity with respects to the x axis
  8th to 10th lines sets, in order: min AoA, max AoA and AoA increment
 
  1D_WING_GEOMETRY.DAT
  this file set the geometry of a wing.
  the 1st line indicates how many nodes (which will be distributed cosine-wise) there are in the wing
  2nd line tells how many sections compose a semiwing
  3rd sets how many airfoils are to be loaded in this wing
  4th line sets the wingspan
  5th line is not used, but is required for correct execution
  6th line sets the chord evolution as a 3rd grade polynomial
  7th line sets the leading edge sweep angle 
  8th line sets the twist evolution as a 3rd grade polynomial
  9th line sets the diedral, positive if upwards
  10th line indicate which arifoil is used in the current section
  11th line tells where the section end (in fratcion of semi wingspan)
  line 6 to 11 are repeated for every section declared
  
  AIRFOILx.DAT
  every x-th airfoil datafile is taken from an X-Foil polar file.
  1st line is the name of the airfoil
  2nd line reports the max thickness
  3rd flag the airoil being supercritical or not
  4th line is the header line
  from the 5th line until EOF there is the polar for the airfoil
