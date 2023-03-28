#!/usr/bin/env python
import exoplasim as exo
import numpy as np
import math 
from scipy import interpolate
import os, glob

trappist1f = exo.Model(workdir="tr1f_notl",modelname="tr1f_notl",ncpus=32,resolution="T21",outputtype=".nc")

trappist1f.configure(startemp=2600.0, flux=518.0, eccentricity=0.,obliquity=0.,fixedorbit=True,synchronous=True,substellarlon= 180,rotationperiod=9.2,radius=1.04,gravity=6.5,aquaplanet=True,pN2=1.,pCO2=33.,ozone=False,mldepth= 50, timestep=60.0,physicsfilter="gp|exp|sp")

trappist1f.exportcfg()

trappist1f.run(years=400,crashifbroken=True)


