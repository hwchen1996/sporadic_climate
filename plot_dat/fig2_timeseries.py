#!/usr/bin/python3
import numpy as np
from matplotlib import pyplot as plt
import glob
import matplotlib.colors as colors
import matplotlib.cm as cm
from statistics import mean
plt.ion()

#fig, (ax1, ax2 , ax3) = plt.subplots(nrows=3, sharex=False)

fig,ax = plt.subplots(3,2)
color_list1 = iter(cm.viridis(np.linspace(0.05, 0.95, 3)))
color_list1= iter(['brown', 'black', 'powderblue'])

color_list2 = iter(cm.viridis(np.linspace(0.05, 0.95, 3)))
label_list = ['Control (Perturbed)', 'Synchronized (1 : 1)','Pure CO$_2$ Atm. (Perturbed)']
color_list2= iter(['brown', 'black', 'powderblue'])
time=np.linspace(1,400,400)
subp_array=[]
for filename in glob.glob('txt_data/subps_e_v2.csv'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            subp_array.append(float(line.split(None, 1)[0]))
        ax[0,0].plot(time, subp_array,linestyle='-', lw=2,color='brown')
        


deviation_e = np.zeros(400)
for i in range(400):
    deviation_e[i] = abs(180-subp_array[i])


for filename in glob.glob('txt_data/spinzs_e_v2.csv'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
#        for line in lines:
       #     ts_array.append(float(line.split(None, 1)[0]))
       # ax1 = ax[0,0].twinx()
       # ax1.plot(time, ts_array,linestyle='--', lw=2,color='brown')

        
        ts_array=[]


i=0
time=[]
eb_array=[]
ts_array=[]
sic_array=[]

for filename in glob.glob('txt_data/tr1e*.txt'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            time.append(float(line.split(None, 4)[0]))
            ts_array.append(float(line.split(None, 4)[1]))
            sic_array.append(float(line.split(None, 4)[2]))
            eb_array.append(float(line.split(None, 4)[3]))

        ax[1,0].plot(time, ts_array,linestyle='-', lw=2,color=next(color_list1),label = label_list[i])

        ax[2,0].plot(time, sic_array,linestyle='-', lw=2,color=next(color_list2))
        i=i+1
        time=[]
        eb_array=[]
        ts_array=[]
        sic_array=[]

#########################diff planet below##############################

color_list1 = iter(cm.viridis(np.linspace(0, 1, 4)))

color_list1= iter(['brown', 'black', 'powderblue','gold'])
color_list2 = iter(cm.viridis(np.linspace(0, 1, 4)))
color_list2= iter(['brown', 'black', 'powderblue','gold'])
label_list = ['Control (Perturbed)','Synchronized (1 : 1)','+5 Bar H$_2$O (Perturbed)', 'Solar SED (Perturbed)']

subp_array=[]
time=np.linspace(1,400,400)
for filename in glob.glob('txt_data/subps_f_v2.csv'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            subp_array.append(float(line.split(None, 1)[0]))
        ax[0,1].plot(time, subp_array,linestyle='-', lw=2,color='brown')
        
        

deviation_f = np.zeros(400)
for i in range(400):
    deviation_f[i] = abs(180-subp_array[i])



for filename in glob.glob('txt_data/spinzs_f_v2.csv'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
 #       for line in lines:
 #           ts_array.append(float(line.split(None, 1)[0]))
 #       ax2 = ax[0,1].twinx()
 #       ax2.plot(time, ts_array,linestyle='--', lw=2,color='brown')

        
        ts_array=[]


i=0
time=[]
eb_array=[]
ts_array=[]
sic_array=[]

for filename in glob.glob('txt_data/tr1f*.txt'):
    with open(filename,'r') as f:
        print(filename)
        lines =  f.read().splitlines()
        for line in lines:
            time.append(float(line.split(None, 4)[0]))
            ts_array.append(float(line.split(None, 4)[1]))
            sic_array.append(float(line.split(None, 4)[2]))
            eb_array.append(float(line.split(None, 4)[3]))

        ax[1,1].plot(time, ts_array,linestyle='-', lw=2,color=next(color_list1),label = label_list[i])

        ax[2,1].plot(time, sic_array,linestyle='-', lw=2,color=next(color_list2))
        i=i+1
        time=[]
        eb_array=[]
        ts_array=[]
        sic_array=[]




ax[1,0].legend(loc='lower right',fontsize=6)
ax[1,1].legend(loc='lower left',fontsize=6)

ax[1,0].legend(loc='upper left',ncol=2,bbox_to_anchor=(-0.05,2.63),fontsize=6)
ax[1,1].legend(loc='upper left',ncol=2,bbox_to_anchor=(-0.05,2.63),fontsize=6)
ax[0,0].set_ylabel('Substellar Pt. \nLongitude ($^{\\rm o}$)',fontsize=11)

ax[1,0].set_ylabel('Surface \nTemp. (K)',fontsize=11)
ax[2,0].set_ylabel('Sea Ice \nThickness (m)',fontsize=11)

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
ax[2,0].spines.right.set_visible(False)
ax[2,0].spines.top.set_visible(False)
# Only show ticks on the left and bottom spines
ax[2,0].yaxis.set_ticks_position('left')
ax[2,0].xaxis.set_ticks_position('bottom')
# Hide the right and top spines
ax[1,1].spines.right.set_visible(False)
ax[1,1].spines.top.set_visible(False)
# Only show ticks on the left and bottom spines
ax[1,1].yaxis.set_ticks_position('left')
ax[1,1].xaxis.set_ticks_position('bottom')
# Hide the right and top spines
ax[2,1].spines.right.set_visible(False)
ax[2,1].spines.top.set_visible(False)
# Only show ticks on the left and bottom spines
ax[2,1].yaxis.set_ticks_position('left')
ax[2,1].xaxis.set_ticks_position('bottom')
#fig.suptitle('Planet e, Dayside Hemisphere', fontsize=15)
#fig.suptitle('TRAPPIST-1 e                    TRAPPIST-1 f', y=1.2, fontsize=12)

ax[0,0].set_title('TRAPPIST-1 e', pad=36)
ax[0,1].set_title('TRAPPIST-1 f', pad=36)
ax[0,0].annotate('(a)', xy=(-0.08, 0.88), xycoords='axes fraction', fontsize=8)
ax[1,0].annotate('(c)', xy=(-0.08, 0.88), xycoords='axes fraction', fontsize=8)
ax[2,0].annotate('(e)', xy=(-0.08, 0.88), xycoords='axes fraction', fontsize=8)
ax[0,1].annotate('(b)', xy=(-0.08, 0.88), xycoords='axes fraction', fontsize=8)
ax[1,1].annotate('(d)', xy=(-0.07, 0.88), xycoords='axes fraction', fontsize=8)
ax[2,1].annotate('(f)', xy=(-0.07, 0.88), xycoords='axes fraction', fontsize=8)

ax[0,0].annotate('Mean Migration = 40.5$^{\\rm o}$', xy=(0.1, 0.95), xycoords='axes fraction', fontsize=8)
ax[0,1].annotate('Mean Migration = 68.0$^{\\rm o}$', xy=(0.1, 0.95), xycoords='axes fraction', fontsize=8)


#ax2.set_ylim(9.18,9.48)

ax[1,0].set_ylim(210,297)
ax[1,1].set_ylim(237,297)
ax[2,0].set_ylim(0,9.8)
ax[2,1].set_ylim(0,9.8)
#ax[1,1].set_ylim(227,287)


ax[0,0].tick_params(axis='both', which='major', labelsize=6)
ax[1,0].tick_params(axis='both', which='major', labelsize=6)
ax[2,0].tick_params(axis='both', which='major', labelsize=6)
ax[0,1].tick_params(axis='both', which='major', labelsize=6)
ax[1,1].tick_params(axis='both', which='major', labelsize=6)
ax[2,1].tick_params(axis='both', which='major', labelsize=6)
#ax1.tick_params(axis='both', which='major', labelsize=6)
#ax2.tick_params(axis='both', which='major', labelsize=6)
fig.subplots_adjust(hspace=.2, wspace=.1, bottom=0.1, top=0.8, left=0.12, right=0.92)
plt.savefig('Figure1.png',dpi=1000)
