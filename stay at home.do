tab V4 V12 if V4 == 276 [WEIGHT],row 
labellist V4

tab V4 V12 if V4 == 276 | V4 == 40 | V4 == 826 |V4 == 840|V4 == 752 | V4==208, row nofreq
tab V4 V12 if V4 == 276 | V4 == 40 | V4 == 826 |V4 == 840|V4 == 752 | V4==208 [aw=WEIGHT], row nofreq
tab V4 V12 if V4 == 276 [aw=WEIGHT], row

tab V4 V12, row
