#!/bin/bash
#tempfile=$(mktemp)
#exec 3>"$tempfile"
#exec 4<"$tempfile"
#rm "$tempfile"
#matlab -nodisplay -nosplash -r "param_iden_kevindata;exit" 2>&1 | tee ${tempfile}
#matlab -nodisplay -nosplash -r "param_iden_kevindata_radial;exit" 2>&1 | tee ${tempfile}

#matlab -nodisplay -nosplash -r "param_iden_kevindata_radial_bivariate;exit"
matlab -nodisplay -nosplash -r "param_iden_kevindata_radial;exit"

#mail -s "[param] param est ${1} done" yue.liu@maths.ox.ac.uk <${tempfile}
mail -s "[param] param est ${1} done" yue.liu@maths.ox.ac.uk </dev/null
#rm ${tempfile}
