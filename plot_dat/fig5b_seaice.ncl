;load "/home/hcx2925/ncl_colormaps/cmocean_tempo.rgb"
begin
;************************************************
; read in netCDF file
;************************************************

  a1= addfile("../saved_tr1f_2600spec_33bar/var_ts.nc","r")
  a2= addfile("../saved_tr1f_2600spec_33bar_tl/var_ts.nc","r")
  a3= addfile("../saved_tr1e_earth/var_ts.nc","r")
  a4= addfile("../saved_tr1e_tidelock/var_ts.nc","r")

;************************************************
; read in zonal winds
;************************************************
  sit_1 = a1->sit(1,:,:)        
  sit_2 = a1->sit(100,:,:)
  sit_3 = a1->sit(140,:,:)
  sit_4 = a1->sit(160,:,:)

  sic_1 = a1->sic(150,:,:)
  sic_2 = a1->sic(150,:,:)
  sic_3 = a1->sic(150,:,:)
  sic_4 = a1->sic(150,:,:)

  sit_all = a1->sit(:,:,:)

  lat = a1->lat
  lon = a1->lon
  lev = a1->lev

 sit_avg = dim_avg_n(sit_all,0) 
 sit_avg!0   = "lat"                             ; name the coordinates since
 sit_avg!1   = "lon"                            
 sit_avg&lat = lat
 sit_avg&lon  =  lon


 sit_1&lat@units="degrees_north"
 sit_1&lon@units="degrees_east"
 sit_2&lat@units="degrees_north"
 sit_2&lon@units="degrees_east"
 sit_3&lat@units="degrees_north"
 sit_3&lon@units="degrees_east"
 sit_4&lat@units="degrees_north"
 sit_4&lon@units="degrees_east"

 sit_avg&lat@units="degrees_north"
 sit_avg&lon@units="degrees_east"

;************************************************
; create plot
;************************************************
  wks = gsn_open_wks("pdf","fig5_seaice")          ; send graphics to PNG file
  plot = new(4,graphic)  

  cmap_1 = read_colormap_file("MPL_Blues")
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
  ;res@lbOrientation   = "vertical"
  res@lbLabelFontHeightF   =0.04
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
  res@gsnDraw = False
  res@gsnFrame = False

  res@cnFillPalette     = cmap_1(::-1,:)
  res@gsnRightString     =  ""
  res@gsnLeftString  =  ""
  res@tiMainString = ""
  
  res@lbLabelBarOn        = False

  ;res@cnLevelSpacingF      = 0.05         ; contour spacing
  res@cnMinLevelValF       =  0.    ; min level
  res@cnMaxLevelValF       = 9. ; max level
    res@gsnStringFontHeightF      = 0.04
  
  plot(0) = gsn_csm_contour_map(wks,sit_1,res)  ;create the plot
  getvalues plot@contour
    "cnLevels" : levels1
  end getvalues
  
  plot(1) = gsn_csm_contour_map(wks,sit_2,res)
 
  plot(2) = gsn_csm_contour_map(wks,sit_3,res)
  delete(res@cnLevelSpacingF)
  delete(res@cnMaxLevelValF)
  delete(res@cnMinLevelValF)
  res@pmLabelBarParallelPosF =  -0.01
  res@pmLabelBarOrthogonalPosF = 0.05
  res@pmLabelBarWidthF = 0.9
  res@lbLabelBarOn        = True
  res@lbTitleOn = True
  res@lbTitleString = "Sea Ice Thickness (m)"
  res@lbTitleFontHeightF = 0.06
  res@cnMinLevelValF       =  0.    ; min level
  res@cnMaxLevelValF       = 9. ; max level
  plot(3) = gsn_csm_contour_map(wks,sit_4,res)

  txres                       = True
  txres@txAngleF              = 90
  txres@txFontHeightF   =0.038
   txtitle                       = True
   txtitle@txAngleF              = 00
   txtitle@txFontHeightF   =0.04


  ;txres@txBackgroundFillColor = "White"
  txid1= gsn_create_text(wks, "~F21~Surf. Temperature (K)", txres)
  txid2= gsn_create_text(wks, "~F21~Sea Ice Thickness (m)", txres)
  txid3= gsn_create_text(wks, "~F21~TOA OLR (W m~S~-2~NN~)", txres)

  txres@txAngleF              = 00
  txres@txFontHeightF   =0.04
  txida= gsn_create_text(wks, "(a)", txres)
  txidb= gsn_create_text(wks, "(b)", txres)
  txidc= gsn_create_text(wks, "(c)", txres)
  txidd= gsn_create_text(wks, "(d)", txres)
  txide= gsn_create_text(wks, "(e)", txres)
  txid_1 =gsn_create_text(wks, "Planet f Year 1", txres)
  txid_100 =gsn_create_text(wks, "Planet f Year 100", txres)
  txid_140 =gsn_create_text(wks, "Planet f Year 140", txres)
  txid_170 =gsn_create_text(wks, "Planet f Year 170", txres)
  txres@txFontHeightF   =0.03
  txid_fhab1 =gsn_create_text(wks, "80% Ice-Free", txres)
  txid_fhab2 =gsn_create_text(wks, "11% Ice-Free", txres)
  txid_fhab3 =gsn_create_text(wks, "4% Ice-Free", txres)
  txid_fhab4 =gsn_create_text(wks, "0% Ice-Free", txres)

  txres@txAngleF              = 0
  txid_scale = gsn_create_text(wks, "(10~S~-8~NN~)", txres)
  txid_title = gsn_create_text(wks, "Chemistry-climate comparison between a barren and aquaplanet",txtitle)

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
  amres_ice = True
  amres_ice@amParallelPosF   =  0.4
  amres_ice@amOrthogonalPosF = -0.54

  annoida = gsn_add_annotation(plot(0), txidb, amres_a)
  annoidb = gsn_add_annotation(plot(1), txidc, amres_a)
  annoidc = gsn_add_annotation(plot(2), txidd, amres_a)
  annoidd = gsn_add_annotation(plot(3), txide, amres_a)

  annoid_1 = gsn_add_annotation(plot(0), txid_1, amres_cap)
  annoid_100 = gsn_add_annotation(plot(1), txid_100, amres_cap)
  annoid_140 = gsn_add_annotation(plot(2), txid_140, amres_cap)
  annoid_170 = gsn_add_annotation(plot(3), txid_170, amres_cap)

  annoid_1 = gsn_add_annotation(plot(0), txid_fhab1, amres_ice)
 amres_ice@amOrthogonalPosF = -0.48
  annoid_100 = gsn_add_annotation(plot(1), txid_fhab2, amres_ice)
  annoid_140 = gsn_add_annotation(plot(2), txid_fhab3, amres_ice)
  annoid_170 = gsn_add_annotation(plot(3), txid_fhab4, amres_ice)
  resP = True
  resP@gsnPanelRight = .9
  plx1 = (/90,90/)
  plx2 = (/270,270/)
  ply = (/-90,90/)

  resP@gsLineDashPattern  = 1
  resP@gsnPaperOrientation = "portrait"
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
  resP@gsnPanelScalePlotIndex      = 2
  frame(wks)

end
