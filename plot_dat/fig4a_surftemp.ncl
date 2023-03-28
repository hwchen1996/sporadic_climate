;load "/home/hcx2925/ncl_colormaps/cmocean_tempo.rgb"
begin
;************************************************
; read in netCDF file
;************************************************
  a1= addfile("../saved_tr1e_earth/var_ts.nc","r")
  a2= addfile("../saved_tr1e_tidelock/var_ts.nc","r")
 ; a1= addfile("../saved_tr1f_2600spec_33bar/var_ts.nc","r")
  ;a2= addfile("../saved_tr1f_2600spec_33bar_tl/var_ts.nc","r")
;************************************************
; read in zonal winds
;************************************************
  ts_1 = a1->ts(100,:,:)        
  ts_2 = a2->ts(400,:,:)
  ts_3 = a1->ts(150,:,:)


  ts_4_all = a1->ts(:,:,:)

  lat = a1->lat
  lon = a1->lon
  lev = a1->lev


 ts_4 = dim_avg_n(ts_4_all,0) 
 ts_4!0   = "lat"                             ; name the coordinates since
 ts_4!1   = "lon"                            
 ts_4&lat = lat
 ts_4&lon  =  lon

 ts_1&lat@units="degrees_north"
 ts_1&lon@units="degrees_east"
 ts_2&lat@units="degrees_north"
 ts_2&lon@units="degrees_east"
 ts_3&lat@units="degrees_north"
 ts_3&lon@units="degrees_east"
 ts_4&lat@units="degrees_north"
 ts_4&lon@units="degrees_east"

;************************************************
; create plot
;************************************************
  wks = gsn_open_wks("pdf","fig4_projb")          ; send graphics to PNG file
  plot = new(4,graphic)  

  cmap_1 = read_colormap_file("MPL_RdYlBu")
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
  ;res@lbOrientation   = "vertical"
  res@gsnDraw = False
  res@gsnFrame = False

  res@cnFillPalette     = cmap_1(::-1,:)
  res@gsnRightString     =  ""
  res@gsnLeftString  =  ""
  res@tiMainString = ""
  
  res@lbLabelBarOn        = False

  res@lbLabelFontHeightF    = .05
  res@gsnStringFontHeightF      = 0.09
  res@cnLevelSpacingF      = 5
  res@cnMinLevelValF       =  180.    ; min level  planet e`
  res@cnMaxLevelValF       = 290. ; max level

  plot(0) = gsn_csm_contour_map(wks,ts_1,res)  ;create the plot
  getvalues plot@contour
    "cnLevels" : levels1
  end getvalues
  res@gsnLeftString  =  ""
  plot(1) = gsn_csm_contour_map(wks,ts_3,res)
  res@gsnLeftString  =  ""
  ;res@gsnCenterStringOrthogonalPosF = .5
  plot(2) = gsn_csm_contour_map(wks,ts_4,res)

  
  res@pmLabelBarParallelPosF =  -0.02
  res@pmLabelBarOrthogonalPosF = 0.05
  res@pmLabelBarWidthF = 0.9
  res@lbLabelBarOn        = True
  res@lbTitleOn = True
  res@lbTitleString = "Surface Temperature (K)"
  res@lbTitleFontHeightF = 0.05
  plot(3) = gsn_csm_contour_map(wks,ts_2,res)

  delete(res@gsnCenterString)
 
  res@lbLabelBarOn        =False
 

  ;res@gsnRightString     =  "r~B~diff~NN~ = -112%"

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
  txid_title =gsn_create_text(wks, "TRAPPIST-1 e", txres)

  txida= gsn_create_text(wks, "(a)", txres)
  txidb= gsn_create_text(wks, "(b)", txres)
  txidc= gsn_create_text(wks, "(c)", txres)
  txidd= gsn_create_text(wks, "(d)", txres)

  txid_a =gsn_create_text(wks, "Year 100 (Perturbed)", txres)
  txid_b =gsn_create_text(wks, "Year 150 (Perturbed)", txres)
  txid_c =gsn_create_text(wks, "400-Year Avg (Perturbed)", txres)
  txid_d =gsn_create_text(wks, "400-Year Avg (1 : 1)", txres)

   txres@txAngleF              = 90
  txid_cap= gsn_create_text(wks, "(Surface Temperature (K)", txres)

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
  amres_cap = True
  amres_cap@amParallelPosF   =  -0.04
  amres_cap@amOrthogonalPosF = -0.58

  annoid_a = gsn_add_annotation(plot(1), txid_title, amres_title)
  annoida = gsn_add_annotation(plot(0), txida, amres_a)
  annoidb = gsn_add_annotation(plot(1), txidb, amres_a)
  annoidc = gsn_add_annotation(plot(2), txidc, amres_a)
  annoidd = gsn_add_annotation(plot(3), txidd, amres_a)

  annoid_a = gsn_add_annotation(plot(0), txid_a, amres_cap)
  annoid_b = gsn_add_annotation(plot(1), txid_b, amres_cap)
  annoid_c = gsn_add_annotation(plot(2), txid_c, amres_cap)
  annoid_d = gsn_add_annotation(plot(3), txid_d, amres_cap)
   resP = True

  plx1 = (/90,90/)
  plx2 = (/270,270/)
  ply = (/-90,90/)

  resP@gsLineDashPattern  = 1

  dum = new(40,graphic)
  dum(0) = gsn_add_polyline(wks,plot(0),plx1,ply,resP)
  dum(1) = gsn_add_polyline(wks,plot(0),plx2,ply,resP)
  dum(2) = gsn_add_polyline(wks,plot(1),plx1,ply,resP)
  dum(3) = gsn_add_polyline(wks,plot(1),plx2,ply,resP)
  dum(4) = gsn_add_polyline(wks,plot(2),plx1,ply,resP)
  dum(5) = gsn_add_polyline(wks,plot(2),plx2,ply,resP)
  dum(6) = gsn_add_polyline(wks,plot(3),plx1,ply,resP)
  dum(7) = gsn_add_polyline(wks,plot(3),plx2,ply,resP)

  ;resP@gsnPanelBottom = .2
  gsn_panel(wks, plot,(/2,2/),resP )   ; draw as one plot
  resP@gsnPanelScalePlotIndex      = 3
;  resP@gsnMaximize = True
;  resP@gsnPaperOrientation = "landscape"

  frame(wks)

end
