open Printf

let string_0 =
  {whatever|
    \documentclass[border=5mm]{standalone}
\usepackage{luamplib}
\usepackage{graphicx}
\mplibtextextlabel{enable}

\begin{document}

    \begin{mplibcode}

        input gpx.mp ;
        input waypoints.mp ;
        input infos.mp

        color gpx_color,google_color ;
        gpx_color = (0,1,0) ;
        google_color = (0,1,1) ;

        beginfig(0);

        xmin=3 ;
        xmax=10 ;
        ymin = 1.1 ;
        ymax = 10 ;

        numeric dx,dy,ratio ;
        dx=0;
        dy=0 ;
        ratio=1 ;
        draw background_image ;

        path bounding_box_background_image ;
        bounding_box_background_image := bbox background_image ;
        show bounding_box_background_image ;
        pair center_bounding_box_background_image ;

        center_bounding_box_background_image = whatever [
            point 0 of bounding_box_background_image,
            point 2 of bounding_box_background_image
        ]         ;
        center_bounding_box_background_image = whatever [
            point 1 of bounding_box_background_image,
            point 3 of bounding_box_background_image
        ]         ;

        draw  bounding_box_background_image  withcolor red ;

        %fill fullcircle scaled 10 shifted center_bounding_box_background_image withcolor (1,0,0) ;

        numeric gpx_ratio ;
        gpx_ratio := 1000 ;
        path gpx ;

        gpx = original_gpx scaled gpx_ratio ;
        path bounding_box_gpx ;



        pair center_bounding_box_gpx ;
        bounding_box_gpx := bbox gpx ;
        draw bounding_box_gpx ;
        center_bounding_box_gpx = whatever [
            point 0 of bounding_box_gpx,
            point 2 of bounding_box_gpx
        ]         ;
        center_bounding_box_gpx = whatever [
            point 1 of bounding_box_gpx,
            point 3 of bounding_box_gpx
        ]         ;

        pickup pencircle scaled 1;
        %gpx := gpx shifted (center_bounding_box_background_image-center_bounding_box_background_image)  ;
        transform t_gpx ;
        t_gpx := identity scaled gpx_ratio shifted (center_bounding_box_background_image-center_bounding_box_background_image) ;
        gpx := original_gpx transformed t_gpx ;
        draw gpx withcolor gpx_color ;


        % gpx_common
        numeric i ;
        i:=0 ;
        forever :
            exitif unknown original_gpx_common[i] ;
            show original_gpx_common[i] ;
            pair p ;
            p = original_gpx_common[i] transformed t_gpx ;
            draw fullcircle scaled 10 shifted p withcolor gpx_color ;
            dotlabel.ulft(decimal(i),p) withcolor gpx_color ;
            i:=i+1 ;
        endfor ;

        % google_common
        numeric i ;
        i:=0 ;
        forever :
            exitif unknown original_google_common[i] ;
            pair p ;
            p = original_google_common[i] ;
            draw fullcircle scaled 10 shifted p withcolor google_color ;
            dotlabel.ulft(decimal(i),p) withcolor google_color ;
            i:=i+1 ;
        endfor ;


%        path p ;
%        transform t ;
%        numeric scale,dx,dy;
%        scale=1200;
%        dx=10.0cm;
%        dy=5.3cm ;
%        theta=-5 ;
%        t := identity scaled scale rotated theta shifted (dx,dy);
%        p := get_route(t) ;
%
%
%
%        pair qq[] ;
%        color qcolor ;
%        qcolor=(1,0,0) ;
%
%        qq0 = (134,166) ;
%        draw fullcircle scaled 5 shifted qq0 withcolor qcolor ;
%        dotlabel.ulft("0",qq0) withcolor qcolor ;
%
%        qq1 = (67,150) ;
%        draw fullcircle scaled 5 shifted qq1 withcolor qcolor ;
%        dotlabel.ulft("1",qq1) withcolor qcolor ;
%
%        qq2 = (143,13) ;
%        draw fullcircle scaled 5 shifted qq2 withcolor qcolor ;
%        dotlabel.ulft("2",qq2) withcolor qcolor ;
%
%        qq3 = (228,120) ;
%        draw fullcircle scaled 5 shifted qq3 withcolor qcolor ;
%        dotlabel.ulft("3",qq3) withcolor qcolor ;
%
%
%        pickup pencircle scaled 1;
%%        draw p withcolor pcolor ;
%
%        transform tt[] ;
%%        qq0 = pp0 transformed tt0 ;
%        qq1 = pp1 transformed tt0 ;
%        qq2 = pp2 transformed tt0 ;
%        qq3 = pp3 transformed tt0 ;
%
%        %qq0 = pp0 transformed tt0 ;
%%        qq1 = pp1 transformed tt1 ;
%%        qq2 = pp2 transformed tt1 ;
%%        qq3 = pp3 transformed tt1 ;
%
%        transform chosen_tt ;
%        chosen_tt=tt0 ;
%
%        path pp ;
%        pp = p transformed chosen_tt ;
%
%        pickup pencircle scaled .1;
%        draw pp withcolor (0,1,0) ;
%
%%        draw p transformed tt0 withcolor (0,0,1) ;
%        %draw p transformed tt1 withcolor (0,0,1) ;
%
%%        pp = .5[p transformed tt0 ,p  transformed tt1 ] ;
%%        draw pp withcolor (1,0,0) ;
%
%
%        pair wpts[] ;
%        get_wpts(wpts)(t) ;
%        show "this is wpts" ;
%        show wpts ;
%        numeric i;
%        i=0 ;
%        forever:
%                exitif unknown wpts[i] ;
%                show wpts[i] ;
%                pair pwpt ;
%%                pwpt = wpts[i] transformed chosen_tt ;
%%                draw fullcircle scaled 10 shifted pwpt withcolor (1,0,0) ;
%                i:=i+1 ;
%        endfor ;
%
%
        endfig;

    \end{mplibcode}

\end{document}
|whatever}

let write_tex_file project =
  let _ = project in
  let fout = open_out "main.tex" in
  let () = fprintf fout "%s\n" string_0 in
  let () = close_out fout in
  ()
