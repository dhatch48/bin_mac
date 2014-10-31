#!/bin/bash

fileData='Art Venere,art@venere.org,256.62394383
Lenna Paprocki,lpaprocki@hotmail.com,259.688783099
Donette Foller,donette.foller@cox.net,282.32979844
Simona Morasca,simona@morasca.com,139.51911647
Dominque Dickerson,dominque.dickerson@dickerson.org,167.045197551
Leota Dilliard,leota@hotmail.com,253.646335223
Sage Wieser,sage_wieser@cox.net,155.55576823
Kris Cho,kris@gmail.com,210.794277775
Minna Amigon,minna_amigon@yahoo.com,95.47955397
Abel Maclead,amaclead@gmail.com,225.774477397
Kiley Caldarera,kiley.caldarera@aol.com,172.957628871
Graciela Ruta,gruta@cox.net,202.68364784
Josephine Darakjy,josephine_darakjy@darakjy.org,178.877840188
Cammy Albares,calbares@gmail.com,290.446513401
Mattie Poquette,mattie@aol.com,283.23995223
Meaghan Garufi,meaghan@hotmail.com,227.142916195
Gladys Rim,gladys.rim@rim.org,243.459635712
Yuki Whobrey,yuki_whobrey@aol.com,128.321717297
Fletcher Flosi,fletcher.flosi@yahoo.com,221.394141603'

# Using printf you have control over how each field is formatted specifically
# %s=string %d=integer %f=float
# -20 says it is left justified and 20 character length
# 6.2 says the float is 6 character length total (including decimal) and 2
# decimal places
echo "$fileData" |
awk -F, '{
    printf("%-20s %-35s %6.2f\n", $1, $2, $3)
}'
