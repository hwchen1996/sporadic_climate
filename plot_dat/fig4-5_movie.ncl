;load "/home/hcx2925/ncl_colormaps/cmocean_tempo.rgb"
begin
;************************************************
; read in netCDF file
;************************************************

  a= addfile("../saved_tr1f_2600spec_33bar/var_ts.nc","r")
  a2= addfile("../saved_tr1f_2600spec_33bar_tl/var_ts.nc","r")
  a3= addfile("../saved_tr1e_earth/var_ts.nc","r")
  
;************************************************
; read in zonal winds
;************************************************
i=0
	do while(i.le.400)
	  
	  ta_1 = a->ts(i,:,:)        
	  ta_2 = a2->ts(i,:,:)
	  ta_3 = a3->ts(i,:,:)
	  ta_all = a->ts(:i,:,:)

	  TMQ_1 = a->sit(i,:,:)
	  TMQ_2 = a2->sit(i,:,:)
	  TMQ_3 = a3->sit(i,:,:)
	  tmq_all = a->sit(:,:,:)

	  sit_1 = a->rlut(i,:,:)
	  sit_2 = a2->rlut(i,:,:)
	  sit_3 = a3->rlut(i,:,:)
	  sit_all = a->rlut(:,:,:)

	  lat = a->lat
	  lon = a->lon
	  lev = a->lev

	 ta_avg = dim_avg_n(ta_all,0) 
	 sit_avg = dim_avg_n(tmq_all,0)
	 rlut_avg = dim_avg_n(sit_all,0)

	 ta_avg!0   = "lat"                             ; name the coordinates since
	 ta_avg!1   = "lon"                            
	 ta_avg&lat = lat
	 ta_avg&lon  =  lon
	 sit_avg!0   = "lat"                             ; name the coordinates since
	 sit_avg!1   = "lon"                            
	 sit_avg&lat = lat
	 sit_avg&lon  =  lon
	 rlut_avg!0   = "lat"                             ; name the coordinates since
	 rlut_avg!1   = "lon"                            
	 rlut_avg&lat = lat
	 rlut_avg&lon  =  lon

	 ta_1&lat@units="degrees_north"
	 ta_1&lon@units="degrees_east"
	 ta_2&lat@units="degrees_north"
	 ta_2&lon@units="degrees_east"
	 ta_3&lat@units="degrees_north"
	 ta_3&lon@units="degrees_east"
	 ta_avg&lat@units="degrees_north"
	 ta_avg&lon@units="degrees_east"

	 TMQ_1&lat@units="degrees_north"
	 TMQ_1&lon@units="degrees_east"
	 TMQ_2&lat@units="degrees_north"
	 TMQ_2&lon@units="degrees_east"
	 TMQ_3&lat@units="degrees_north"
	 TMQ_3&lon@units="degrees_east"
	 sit_avg&lat@units="degrees_north"
	 sit_avg&lon@units="degrees_east"

	 sit_1&lat@units="degrees_north"
	 sit_1&lon@units="degrees_east"
	 sit_2&lat@units="degrees_north"
	 sit_2&lon@units="degrees_east"
	 sit_3&lat@units="degrees_north"
	 sit_3&lon@units="degrees_east"
	 rlut_avg&lat@units="degrees_north"
	 rlut_avg&lon@units="degrees_east"

	;************************************************
	; create plot
	;************************************************
	  strs = (/tostring(i), "_proj"/)
	  fig_name = str_concat(strs)

	  wks = gsn_open_wks("png",fig_name)          ; send graphics to PNG file
	  plot = new(2,graphic)  

	  cmap_1 = read_colormap_file("MPL_RdYlBu")
	  cmap_2 = read_colormap_file("MPL_Blues")
	  cmap_3 = read_colormap_file("MPL_YlOrRd")
	  cmap_4 = read_colormap_file("NCV_blue_red")

	  newline = inttochar(10) 
	  res                   = True
	  res@mpProjection      = "Robinson"       ; choose projection
	  res@mpGridAndLimbOn   = False            ; turn on lat/lon lines
	  res@mpPerimOn         = False             ; turn off box around plot
	  res@mpGridLatSpacingF = 300.               ; spacing for lat lines
	  res@mpGridLonSpacingF = 90.               ; spacing for lon lines
	  res@mpGridLineDashPatplanet   = True               ; lat/lon lines dashed
	  res@mpFillOn          = False
	  res@mpOutlineOn = False
	  res@gsnTickMarksOn = False
	  res@cnLinesOn   = False
	  res@lbOrientation   = "vertical"
	  res@lbLabelFontHeightF   =0.026
	  res@lbBoxLinesOn = False
	  res@pmLabelBarWidthF      = 0.35

	  res@mpCenterLonF = 180
	  res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
	  ;res@cnLevelSpacingF      = 0.05         ; contour spacing
	  ;res@cnMinLevelValF       =  1    ; min level
	  ;res@cnMaxLevelValF       = 8 ; max level
	  ;res@cnLevelSelectionMode   = "EqualSpacedLevels"
	  ;res@cnMaxLevelCount  = 12

	  res@cnFillOn          = True           ; color plot desired
	  res@cnLineLabelsOn    = False         ; turn off contour lines
	  res@txFontHeightF     = 0.015 
	  res@gsnContourLineThicknessesScale = 0.01

	  res@vpXF            = 0.1                 ; make plot bigger
	  res@vpYF            = 0.9         
	  res@vpWidthF        = 0.8
	  res@vpHeightF       = 0.8
	  res@lbOrientation   = "vertical"
	  res@gsnDraw = False
	  res@gsnFrame = False

	  res@cnFillPalette     = cmap_1(::-1,:)
	  res@gsnRightString     =  ""
	  res@gsnLeftString  =  ""
	  res@tiMainString = ""
	  res@gsnCenterString  =  "Planet f, Year " +  tostring(i)
	  res@lbLabelBarOn        = False

	  ;res@cnLevelSpacingF      = 0.05         ; contour spacing
	  ;res@cnMinLevelValF       =  180.    ; min level
	  ;res@cnMaxLevelValF       = 310. ; max level

	  res@gsnStringFontHeightF      = 0.045
	  plot(0) = gsn_csm_contour_map(wks,ta_1,res)  ;create the plot
	 ; getvalues plot@contour
	 ;   "cnLevels" : levels1
	 ; end getvalues
	 
	  res@lbLabelBarOn = True
	  res@gsnCenterString  =     "Planet f, Averaged from Year 1 to " + tostring(i)


          res@pmLabelBarParallelPosF =  -0.02
          res@pmLabelBarOrthogonalPosF = 0.05
          res@pmLabelBarWidthF = 0.9
  
          res@lbTitleOn = True
          res@lbTitleString = "Surface Temperature (K)"
          res@lbTitleFontHeightF = 0.05
          res@cnLevelSpacingF      = 5
          res@cnMinLevelValF       =  230.    ; min level
          res@cnMaxLevelValF       = 300. ; max level

	  plot(1) = gsn_csm_contour_map(wks,ta_avg,res)
	  txres                       = True
	  txres@txAngleF              = 90
	  txres@txFontHeightF   =0.038
	   txtitle                       = True
	   txtitle@txAngleF              = 00
	   txtitle@txFontHeightF   =0.04


	  ;txres@txBackgroundFillColor = "White"
	  txid1= gsn_create_text(wks, "~F21~Surf. Temperature (K)", txres)
	  txres@txAngleF              = 00
	  txres@txFontHeightF   =0.04
	  txida= gsn_create_text(wks, "(a)", txres)
	  txidb= gsn_create_text(wks, "(b)", txres)

	  txres@txAngleF              = 0
	  amres1 = True
	  amres1@amParallelPosF   =  -0.534
	  amres1@amOrthogonalPosF = 0.0
	  amres_a = True
	  amres_a@amParallelPosF   =  -0.43
	  amres_a@amOrthogonalPosF = -0.47
	  amres_scale = True
	  amres_scale@amParallelPosF   =  0.67
	  amres_scale@amOrthogonalPosF = 0.58
	   amres_title = True
	   amres_title@amParallelPosF   =  -0.5
	   amres_title@amOrthogonalPosF = -0.78

	  annoid1 = gsn_add_annotation(plot(0), txid1, amres1)
 

	  annoida = gsn_add_annotation(plot(0), txida, amres_a)
	  annoidb = gsn_add_annotation(plot(1), txidb, amres_a)
 
	   ;annoid_t = gsn_add_annotation(plot(2), txid_title, amres_title)

	  resP = True
	  resP@gsnPanelRight = .9
	  plx1 = (/90,90/)
	  plx2 = (/270,270/)
	  ply = (/-90,90/)

	  resP@gsLineDashPattern  = 1

	  dum = new(40,graphic)
	  dum(0) = gsn_add_polyline(wks,plot(0),plx1,ply,resP)
	  dum(1) = gsn_add_polyline(wks,plot(0),plx2,ply,resP)
	  dum(2) = gsn_add_polyline(wks,plot(1),plx1,ply,resP)
	  dum(3) = gsn_add_polyline(wks,plot(1),plx2,ply,resP)

	  ;resP@gsnPanelBottom = .2
	  gsn_panel(wks, plot,(/1,2/),resP )   ; draw as one plot
	  resP@gsnPanelScalePlotIndex      = 5
	  frame(wks)
	  delete(ta_all)
	  i = i+10
	end do
end
