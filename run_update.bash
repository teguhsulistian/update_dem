####convert data BATNAS dari format tif ke grd
#gdal_translate -of "NetCDF" area2.tif input1.grd
echo -n '1. Input DEM yang akan di update: '
read input1
echo -n '2. Input Data Observasi untuk update: '
read input2
echo -n '3. Resolusi output x dan y (dalam satuan arc): '
read input3


gdal_translate -of "NetCDF" ${input1} input1.grd

lat0=`gdalinfo "$input1" | grep "Lower Left" | awk -F "(" '{print $2}' | awk -F ", " '{print $2}' | sed -e 's/ //g' -e 's/)//g'`
lon0=`gdalinfo "$input1" | grep "Lower Left" | awk -F "(" '{print $2}' | awk -F ", " '{print $1}' | sed 's/ //g'`
latf=`gdalinfo "$input1" | grep "Upper Right" | awk -F "(" '{print $2}' | awk -F ", " '{print $2}' | sed -e 's/ //g' -e 's/)//g'`
lonf=`gdalinfo "$input1" | grep "Upper Right" | awk -F "(" '{print $2}' | awk -F ", " '{print $1}' | sed 's/ //g'`

echo "Processing data dari $lon0 sampai $lonf dan dari $lat0 sampai $latf"

csh update_bathy.csh ${input2} input1.grd $lon0 $lonf $lat0 $latf ${input3} ${input3} 1000
mv final_predicted.grd input1.grd
gdal_translate -of "GTiff" input1.grd DTM_FINAL2.tif
#csh update_bathy.csh input2.txt input1.grd $lon0 $lonf $lat0 $latf 0.0003 0.0003 100
#mv final_predicted.grd input1.grd
#csh update_bathy.csh input2.txt input1.grd $lon0 $lonf $lat0 $latf 0.00015 0.00015 30
#mv final_predicted.grd input2.grd
#gdal_translate -of "GTiff" input2.grd output15m.tif
#csh update_bathy.csh input2.txt input2.grd $lon0 $lonf $lat0 $latf 0.00005 0.00005 10
#mv final_predicted.grd final_output.grd
#gdal_translate -of "GTiff" final_output.grd DTM_FINAL_5m.tif
