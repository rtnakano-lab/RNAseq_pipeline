
require(ggplot2)

theme_RTN <- theme_bw() +
	theme(panel.border=element_blank(),
	      panel.grid=element_blank(),
	      legend.key=element_blank(),
	      legend.text.align=0,
	      legend.position="top",
	      strip.text=element_text(face="bold"),
	      axis.line=element_line(),
	      axis.line.x=element_line(),
	      axis.line.y=element_line(),
	      panel.background=element_rect(fill="transparent", colour=NA),
	      plot.background=element_rect(fill="transparent", colour=NA),
	      strip.background=element_rect(fill="transparent", colour=NA),
	      strip.placement="outside")

# colours_Ruben
alpha <- .7
c_yellow <-          rgb(255 / 255, 255 / 255,   0 / 255, alpha)
c_dark_yellow <-     rgb(128 / 255, 128 / 255,   0 / 255, alpha)
c_blue <-            rgb(  0 / 255, 000 / 255, 255 / 255, alpha)
c_orange <-          rgb(255 / 255,  69 / 255,   0 / 255, alpha)
c_green <-           rgb( 50 / 255, 220 / 255,  50 / 255, alpha)
c_dark_green <-      rgb( 50 / 255, 200 / 255, 100 / 255, alpha)
c_very_dark_green <- rgb( 50 / 255, 150 / 255, 100 / 255, alpha)
c_sea_green <-       rgb( 46 / 255, 129 / 255,  90 / 255, alpha)
c_black <-           rgb(  0 / 255,   0 / 255,   0 / 255, alpha)
c_grey <-            rgb(180 / 255, 180 / 255, 180 / 255, alpha)
c_dark_brown <-      rgb(101 / 255,  67 / 255,  33 / 255, alpha)
c_red <-             rgb(200 / 255,   0 / 255,   0 / 255, alpha)
c_dark_red <-        rgb(255 / 255, 130 / 255,   0 / 255, alpha)
c_dark_red_weak <-   rgb(255 / 255, 210 / 255, 120 / 255, alpha)
c_very_dark_green_weak <- rgb( 150 / 255, 255 / 255, 200 / 255, alpha)

# colours_Thomas
c_cudo_skyblue <-    rgb(102 / 255, 204 / 255,  255 / 255, alpha)
c_cudo_magenta <-    rgb(154 / 255,   0 / 255,  121 / 255, alpha)
c_cudo_red <-        rgb(255 / 255,  50 / 255,    0 / 255, alpha)
c_cudo_orange <-     rgb(255 / 255, 153 / 255,    0 / 255, alpha)
c_white <-           rgb(255 / 255, 255 / 255,  255 / 255, alpha)
c_dark_grey <-       rgb( 80 / 255,  80 / 255,   80 / 255, alpha)

# saturate function
saturate <- function(value, cut){
	if(cut >= .5){
		message("cut should be lower quantile, please")
		return(NULL)
	} else{
		max <- quantile(value, (1-cut))
		idx <- value > max
		value[idx] <- max

		min <- quantile(value, cut)
		idx <- value < min
		value[idx] <- min

		return(value)
	}
}




















