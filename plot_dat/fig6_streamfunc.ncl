begin
;************************************************
; read in netCDF file
;************************************************
  a1= addfile("../saved_tr1e_earth/var_ts.nc","r")

;************************************************
; read in data required for calculation
;************************************************
  time =  ispan(450,550,10)
  val = 65.
  set = floattointeger(val)
  
  v_1    =   a1->va(110,:,:,{0:180}) 
  v_2    =   a1->va(400,:,:,{0:180})
  v_3    =   a1->va(339,:,:,{0:180})
  p_1 = a1->lev
  ps_1   =   a1->ps(79,:,{0:180})*100
  ps_2   =   a1->ps(400,:,{0:180})*100
  ps_3   =   a1->ps(339,:,{0:180})*100
  lat  =   a1->lat
  lon  =   a1->lon
  lev_p = fspan(70,800,10)
  lev_p@units     = "mb"                        ; required for vinth2p
  print(lon)
;************************************************
; calculate the meridional stream function
;************************************************
  psi_1 = zonal_mpsi(v_1,lat,lev_p*100,ps_1)*1e-11   ; calculate the zonal mean msf

  psi_1!0   = "lev"                             ; name the coordinates since
  psi_1!1   = "lat"                             ; zmmsf does not copy them.
  psi_1&lev = lev_p
  psi_1&lat = lat                               ; cp lat to "lat"
  psi_2 = zonal_mpsi(v_2,lat,lev_p*100,ps_2)*1e-11   ; calculate the zonal mean msf

  printVarSummary(psi_2)
  psi_2!0   = "lev"                             ; name the coordinates since
  psi_2!1   = "lat"                             ; zmmsf does not copy them.
  psi_2&lev = lev_p
  psi_2&lat = lat                               ; cp lat to "lat"
  psi_3 = zonal_mpsi(v_3,lat,lev_p*100,ps_3)*1e-11   ; calculate the zonal mean msf

  psi_3!0   = "lev"                             ; name the coordinates since
  psi_3!1   = "lat"                             ; zmmsf does not copy them.
  psi_3&lev = lev_p
  psi_3&lat = lat                               ; cp lat to "lat"

;************************************************
; create plot
;************************************************

  wks  = gsn_open_wks ("pdf", "fig6_circ" )          ; send graphics to PNG file
  plot = new(3,graphic) 
  res                      = True                 ; plot mods desired


  res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
  ;res@cnLevelSpacingF      = 5.0                  ; contour spacing
  ;res@cnMinLevelValF       = 4e-9                ; min level
  ;res@cnMaxLevelValF       =  6e-8                ; max level

  res@cnLineLabelsOn       = False                 ; turn on line labels
  res@cnFillOn             = True                 ; turn on color fill
  res@cnFillPalette        = "MPL_RdPu"             ; choose colormap
  res@tmYLMode = "Automatic"
  res@cnLinesOn   = False
  res@gsnRightString =""
  res@gsnDraw = False
  res@gsnFrame = False
  res@cnInfoLabelOn = False
  res@tiYAxisOn = True
  res@tmYROn = False
  res@tmYRLabelsOn =False
  res@tmYLLabelFontHeightF = 0.04

  res@tmYRLabelFontHeightF = 0.04
  res@lbLabelFontHeightF = 0.05
  res@tmYLMode        = "Explicit"	
  res@tmYLValues      = (/100,250,500,700/)
  res@tmYLLabels      = "" + res@tmYLValues 
  res@pmLabelBarHeightF = 0.2
  res@lbLabelBarOn        = False
 
  delete(res@cnMinLevelValF)
  delete(res@cnMaxLevelValF)
  res@cnMinLevelValF       = -4e10             ; min level
  res@cnMaxLevelValF       = 4e10               ; max level
  res@cnFillPalette        = "MPL_RdBu"             ; choose colormap 
  res@cnLevelSelectionMode = "ExplicitLevels" ; set explicit contour levels
  ;res@cnLevels = ((/-10^11,-10^9,0, 10^9,10^11/)) ; set levels 

  res@tmYRMode             = "Automatic"          ; turn off special labels on right axis

  res@tiYAxisString = "Pressure (mbar)"
   res@tiYAxisFontHeightF =0.04
  res@tiXAxisString = ""
  plot(0) = gsn_csm_pres_hgt(wks,psi_1,res)
  res@tiYAxisString = ""

  res@tiXAxisString = "Latitude"
   res@tiXAxisFontHeightF =0.04
    plot(1) = gsn_csm_pres_hgt(wks,psi_2,res)
   res@tiXAxisString = ""
  delete(res@cnLevelSpacingF)
  delete(res@cnMaxLevelValF)
  delete(res@cnMinLevelValF)
  res@pmLabelBarParallelPosF =  -0.88
  res@pmLabelBarOrthogonalPosF = 0.18
  res@pmLabelBarWidthF = 1.4
  res@lbLabelBarOn        = True
  res@lbTitleOn = True
  res@lbTitlePosition = "Bottom"
  res@lbTitleFontHeightF = 0.045
  res@lbTitleString = "Meridional Overturning Streamfunction (x10~S~11~N~ kg s~S~-1~N~)"
  plot(2) = gsn_csm_pres_hgt(wks,psi_3,res)
  res@lbLabelBarOn        = False

  txres                       = True
  txres@txAngleF              = 0
  txres@txFontHeightF   =0.031
  txtitle                       = True
  txtitle@txAngleF              = 0
  txtitle@txFontHeightF   =0.033
  txida= gsn_create_text(wks, "(a)", txres)
  txidb= gsn_create_text(wks, "(b)", txres)
  txidc= gsn_create_text(wks, "(c)", txres)
  txidd= gsn_create_text(wks, "(d)", txres)
  txide= gsn_create_text(wks, "(e)", txres)
  txidf= gsn_create_text(wks, "(f)", txres)
  txidg= gsn_create_text(wks, "(g)", txres)
  txidh= gsn_create_text(wks, "(h)", txres)
  txidi= gsn_create_text(wks, "(i)", txres)

  txG = gsn_create_text(wks, "~F8~f = 185~S~o~N~", txres) 
  txK = gsn_create_text(wks, "~F8~f = 20~S~o~N~", txres) 
  txM = gsn_create_text(wks, "~F8~f = 277~S~o~N~", txres) 

  amres_a = True
  amres_a@amParallelPosF   =  -0.42
  amres_a@amOrthogonalPosF = -0.4
  amres_title1 = True
  amres_title1@amParallelPosF   =  -0.65
  amres_title1@amOrthogonalPosF = -0.65
  amres_title2 = True
  amres_title2@amParallelPosF   =  -0.63
  amres_title2@amOrthogonalPosF = 0.73
  amres_2600 = True
  amres_2600@amParallelPosF   =  -0.3
  amres_2600@amOrthogonalPosF = -0.6
  amres_3300 = True
  amres_3300@amParallelPosF   =  0.3
  amres_3300@amOrthogonalPosF = -0.6


  annoid_a = gsn_add_annotation(plot(0), txida, amres_a)
  annoid_b = gsn_add_annotation(plot(1), txidb, amres_a)
  annoid_c = gsn_add_annotation(plot(2), txidc, amres_a)


  annoid_2600 = gsn_add_annotation(plot(0), txG, amres_2600)
  annoid_3000 = gsn_add_annotation(plot(1), txK, amres_2600)
  annoid_3300 = gsn_add_annotation(plot(2), txM, amres_2600)
   resP = True
  resP@gsnPanelScalePlotIndex      = 0
  gsn_panel(wks,plot,(/1,3/),resP)        ; create panel plot

  frame(wks)
end
