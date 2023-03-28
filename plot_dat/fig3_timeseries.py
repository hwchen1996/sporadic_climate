#!/usr/bin/python3
import numpy as np
from matplotlib import pyplot as plt
import glob
import matplotlib.colors as colors
import matplotlib.cm as cm
from statistics import mean
plt.ion()

#fig, (ax1, ax2 , ax3) = plt.subplots(nrows=3, sharex=False)

fig,ax = plt.subplots(2,2)
color_list1 = iter(cm.viridis(np.linspace(0.05, 0.95, 3)))

color_list2 = iter(cm.viridis(np.linspace(0.05, 0.95, 3)))
label_list = ['Control', 'High Tidal Dissipation', '"Young" System']
subp_array=[]
time=np.linspace(1,400,400)
for filename in glob.glob('txt_data/subps_f_v2_lowE.csv'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            subp_array.append(float(line.split(None, 1)[0]))
        ax[0,0].plot(time, subp_array,linestyle='-', lw=2,color=cm.viridis(0.95))
        


deviation_f1 = np.zeros(400)
for i in range(400):
        deviation_f1[i] = abs(180-subp_array[i])


i=0
time=[]
eb_array=[]
ts_array=[]
sic_array=[]

for filename in glob.glob('txt_data/tr1f_tides/*p1.txt'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            time.append(float(line.split(None, 4)[0]))
            ts_array.append(float(line.split(None, 4)[1]))
            sic_array.append(float(line.split(None, 4)[2]))
            eb_array.append(float(line.split(None, 4)[3]))

        ax[1,0].plot(time, ts_array,linestyle='-', lw=2,color=next(color_list1),label = label_list[i])

        ax[1,1].plot(time, sic_array,linestyle='-', lw=2,color=next(color_list2))
        i=i+1
        time=[]
        eb_array=[]
        ts_array=[]
        sic_array=[]

#########################diff planet below##############################

color_list1 = iter(cm.viridis(np.linspace(0, 1, 4)))
color_list2 = iter(cm.viridis(np.linspace(0, 1, 4)))

label_list = ['Control (Perturbed)', 'High Tidal Realignment']

subp_array=[]
time=np.linspace(1,400,400)
for filename in glob.glob('txt_data/subps_f_v3.csv'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            subp_array.append(float(line.split(None, 1)[0]))
        ax[0,1].plot(time, subp_array,linestyle='-', lw=2,color=cm.viridis(0.38))
        
        

deviation_f2 = np.zeros(400)
for i in range(400):
        deviation_f2[i] = abs(180-subp_array[i])


ax[1,0].legend(loc='lower right',fontsize=6)
ax[1,1].legend(loc='lower left',fontsize=6)

ax[1,0].legend(loc='upper left',ncol=3,bbox_to_anchor=(-0.1,2.45),fontsize=11)

ax[0,0].set_ylabel('Substellar Point \nLongitude ($^{\\rm o}$)',fontsize=11)

ax[1,0].set_ylabel('Surface \nTemperature (K)',fontsize=11)
ax[1,1].set_ylabel('Sea Ice \nThickness (m)',fontsize=11)

fig.text(0.5, 0.03, 'time since start of simulation (Earth years)', ha='center',fontsize=11)

ax[0,0].spines.right.set_visible(False)
ax[0,0].spines.top.set_visible(False)
# Only show ticks on the left and bottom spines
ax[0,0].yaxis.set_ticks_position('left')
ax[0,0].xaxis.set_ticks_position('bottom')
# Hide the right and top spines
ax[0,1].spines.right.set_visible(False)
ax[0,1].spines.top.set_visible(False)
# Only show ticks on the left and bottom spines
ax[0,1].yaxis.set_ticks_position('left')
ax[0,1].xaxis.set_ticks_position('bottom')
# Hide the right and top spines
ax[1,0].spines.right.set_visible(False)
ax[1,0].spines.top.set_visible(False)
# Only show ticks on the left and bottom spines
ax[1,0].yaxis.set_ticks_position('left')
ax[1,0].xaxis.set_ticks_position('bottom')

# Hide the right and top spines
ax[1,1].spines.right.set_visible(False)
ax[1,1].spines.top.set_visible(False)
# Only show ticks on the left and bottom spines
ax[1,1].yaxis.set_ticks_position('left')
ax[1,1].xaxis.set_ticks_position('bottom')

#fig.suptitle('Planet e, Dayside Hemisphere', fontsize=15)
#fig.suptitle('TRAPPIST-1 e                    TRAPPIST-1 f', y=1.2, fontsize=12)

ax[0,0].set_title('           TRAPPIST-1 f', pad=35,fontsize=14)
ax[0,0].annotate('(a)', xy=(0.08, 0.9), xycoords='axes fraction', fontsize=12)
ax[1,0].annotate('(c)', xy=(0.08, 0.9), xycoords='axes fraction', fontsize=12)

ax[0,1].annotate('(b)', xy=(0.08, 0.9), xycoords='axes fraction', fontsize=12)
ax[1,1].annotate('(d)', xy=(0.08, 0.9), xycoords='axes fraction', fontsize=12)
#ax2.set_ylim(9.18,9.48)

ax[0,0].annotate('Mean Migration = 11.01$^{\\rm o}$', xy=(0.2, 0.88), xycoords='axes fraction', fontsize=8)
ax[0,1].annotate('Mean Migration = 7.89$^{\\rm o}$' , xy=(0.2, 0.88), xycoords='axes fraction', fontsize=8)

ax[0,0].set_ylim(148,219)
ax[0,1].set_ylim(148,219)
ax[1,0].set_ylim(246,284)
ax[1,1].set_ylim(0,9.8)
#ax[1,1].set_ylim(227,287)
ax[1,0].set_yticks(np.arange(250, 280, 10))

ax[0,0].tick_params(axis='both', which='major', labelsize=9)
ax[1,0].tick_params(axis='both', which='major', labelsize=9)
ax[1,1].tick_params(axis='both', which='major', labelsize=9)
ax[0,1].tick_params(axis='both', which='major', labelsize=9)
ax[1,1].tick_params(axis='both', which='major', labelsize=9)
#ax1.tick_params(axis='both', which='major', labelsize=6)
#ax2.tick_params(axis='both', which='major', labelsize=6)
fig.subplots_adjust(hspace=.2, wspace=.25, bottom=0.1, top=0.82, left=0.13, right=0.97)
plt.savefig('Figure2.png',dpi=1000)
