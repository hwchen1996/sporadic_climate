#!/usr/bin/env python
import exoplasim as exo
import numpy as np
import math 
from scipy import interpolate
import os, glob

trappist1f = exo.Model(workdir="tr1f_lowh2o",modelname="lowh2o",ncpus=32,resolution="T21",outputtype=".nc")

trappist1f.configure(startemp=2600.0,starspec='/glade/u/home/hchen/2600_4.0_BT-Settl.dat', flux=518.0, eccentricity=0.,obliquity=0.,fixedorbit=True,synchronous=True,substellarlon= 180,rotationperiod=9.2,radius=1.04,gravity=6.5,aquaplanet=True,pN2=1.,pCO2=33.,ozone=False,mldepth= 50, timestep=60.0,physicsfilter="gp|exp|sp")

trappist1f.exportcfg()

trappist1f.run(years=1,crashifbroken=True)


time=[]
spinz=[]
f1_axial_tilt=[]

f1_x = []
f1_y = []
f1_axis_z = []
f1_axis_x = []
f1_axis_y = []
with open("planet_f_v2", 'r') as f:  
	lines =  f.read().splitlines()[1:]   

	for line in lines:
		time.append(float(line.split(None, 21)[0]))
		f1_x.append(float(line.split(None, 21)[7]))
		f1_y.append(float(line.split(None, 21)[8]))
		f1_axis_x.append(float(line.split(None, 21)[13]))
		f1_axis_y.append(float(line.split(None, 21)[14]))
		f1_axis_z.append(float(line.split(None, 21)[15]))
		spinz.append(float(line.split(None, 21)[18]))
		f1_axial_tilt.append(float(line.split(None,21)[20]))



psi = [(np.pi-i)/np.pi*180 for i in f1_axial_tilt]


Npsi=psi
axis=[f1_axis_x, f1_axis_y, f1_axis_z]
for i in range(len(psi)):
     theta=  math.atan2(f1_y[i], f1_x[i])
    # Naxis= math3d.rotz(-theta/np.pi*180)*axis[i, :]
     c, s = np.cos(-theta/np.pi*180), np.sin(-theta/np.pi*180)
     R = np.matrix([[c, -s, 0], [s, c,0], [0,0,1]])
     v = np.matrix([j[i] for j in axis] )
     Naxis = R*v.reshape(3,1)
     if Naxis[2]<0:
         Npsi[i]=-psi[i]
         
f_Npsi = interpolate.interp1d(time, Npsi)
f_Spinz = interpolate.interp1d(time, spinz)

for i in range(400):

    time = 2+ i
    radyr = f_Spinz(time)
    rotp = 1/ (radyr/(2*np.pi) / 365.)
    orbp = 6.4

    Npsi = f_Npsi(time)
    subp =  180. + Npsi
    print('psi ='+ str(Npsi), 'rotp ='+ str(rotp), 'subp ='+ str(subp))
    
    trappist1f.configure(startemp=2600.0, starspec='/glade/u/home/hchen/2600_4.0_BT-Settl.dat',flux=518.0,eccentricity=0.,obliquity=0.,fixedorbit=True,synchronous=True,substellarlon= subp,rotationperiod= rotp,radius=1.04,gravity=6.5,aquaplanet=True,pN2=1.,pCO2=33. ,ozone=False, mldepth= 50,timestep=60.0,physicsfilter="gp|exp|sp",restartfile="/glade/u/home/hchen/tr1f_lowh2o/plasim_restart")
    trappist1f.exportcfg()
    trappist1f.run(years=1,crashifbroken=True)
    trappist1f.finalize(outputdir='/glade/scratch/hchen/plasim_runs/', allyears=True, keeprestarts=True, clean=False)
    for filename in glob.glob("/glade/u/home/hchen/tr1f_lowh2o/*nc"):
       os.remove(filename)
