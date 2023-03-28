#!/usr/bin/python3
import numpy as np
from matplotlib import pyplot as plt
import glob
import math
import math
from scipy import interpolate
import os,glob
import csv
plt.ion()

fig, ax1 = plt.subplots(1,1)


time1=[]
spinz=[]
f1_axial_tilt=[]

f1_x = []
f1_y = []
f1_axis_z = []
f1_axis_x = []
f1_axis_y = []
with open("planet_e_v2.txt", 'r') as f:  
	lines =  f.read().splitlines()[1:]   

	for line in lines:
		time1.append(float(line.split(None, 21)[0]))
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
         
f_Npsi = interpolate.interp1d(time1, Npsi)

f_Spinz = interpolate.interp1d(time1, spinz)

Npsi = np.zeros(5000)
Spinz =  np.zeros(5000)

for i in range(5000):

    time = (101)+i
    radyr = f_Spinz(time)
    rotp = 1/ (radyr/(2*np.pi) / 365.)
    orbp = 6.4

    Npsi[i] = f_Npsi(time)
    Spinz[i]= rotp


color_list = ['firebrick', 'royalblue','goldenrod']

ts_array=[]
time2=np.linspace(1,5000,5000)
for filename in glob.glob('subp_long.csv'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            ts_array.append(float(line.split(None, 1)[0]))
        ax1.plot(time2, ts_array,linestyle='-', lw=2,color='dodgerblue',label='substellar longitude')

        
        ts_array=[]

for filename in glob.glob('rotp_long.csv'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            ts_array.append(float(line.split(None, 1)[0]))
        ax2 = ax1.twinx()
        ax2.plot(time2, ts_array,linestyle='--', lw=2,color='cadetblue', label='rotation period')
        
        ts_array=[]


#ax3.annotate('Rotation \nPeriod (days)', xy=(280,20),color='silver',fontsize=7)

ax1.set_ylabel('Substellar Point \nLongitude ($^{\\rm o}$)',color='dodgerblue',fontsize=16)

ax2.set_ylabel('Rotation \nPeriod (d)',color='cadetblue',fontsize=16)
#ax4.set_ylabel('Sea Ice \nThickness (m)',fontsize=8)

fig.text(0.5, 0.03, 'time since start of simulation (Earth years)', ha='center',fontsize=16)
# Hide the right and top spines

#fig.suptitle('TRAPPIST-1 e                    TRAPPIST-1 f', fontsize=12)
fig.text(0.17, 0.86, '(b)', ha='center',fontsize=16)

ax1.tick_params(axis='both', which='major', labelsize=9)
ax1.tick_params(axis='y', colors='dodgerblue')
ax1.set_yticks([0,180,360])
ax2.set_yticks([9.1,9.2,9.3,9.4,9.5])
ax2.tick_params(axis='both',which='major', labelsize=9)
ax2.tick_params(axis='y', colors='cadetblue')

fig.set_size_inches(7, 2)
fig.subplots_adjust(hspace=.08, wspace=.08, bottom=0.26, top=0.75, left=0.2, right=0.82)
plt.savefig('fig1_out.png',dpi=1000)
