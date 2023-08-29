open Printf
module Log = Dolog.Log

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

        color gpx_color,google_color,co_color ;
        gpx_color = (0,1,0) ;
        google_color = (1,0,0) ;
        co_color = (1,0,1) ;
        numeric gpx_ratio ;
        gpx_ratio := 1000 ;


        path bounding_box_google_image ;
        bounding_box_google_image := bbox google_image ;
        show bounding_box_google_image ;
        pair center_bounding_box_google_image ;

        center_bounding_box_google_image = whatever [
            point 0 of bounding_box_google_image,
            point 2 of bounding_box_google_image
        ]         ;
        center_bounding_box_google_image = whatever [
            point 1 of bounding_box_google_image,
            point 3 of bounding_box_google_image
        ]         ;


        transform t_gpx ;
        t_gpx := identity scaled gpx_ratio shifted (center_bounding_box_google_image-center_bounding_box_google_image) ;


        transform tt ;
        original_gpx_common0 transformed t_gpx transformed tt = original_google_common0 ;
        original_gpx_common1 transformed t_gpx transformed tt = original_google_common1 ;
        original_gpx_common2 transformed t_gpx transformed tt = original_google_common2 ;


        transform ttt ;
        original_gpx_common0 transformed t_gpx transformed tt transformed ttt = original_co_common0 ;
        original_gpx_common1 transformed t_gpx transformed tt transformed ttt = original_co_common1 ;
        original_gpx_common2 transformed t_gpx transformed tt transformed ttt = original_co_common2 ;


        beginfig(0);

        xmin=3 ;
        xmax=10 ;
        ymin = 1.1 ;
        ymax = 10 ;

        numeric dx,dy,ratio ;
        dx=0;
        dy=0 ;
        ratio=1 ;
        if see_google :
            draw google_image ;
        fi ;


        if see_google:
            draw  bounding_box_google_image  withcolor red ;
        fi;

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
        gpx := original_gpx transformed t_gpx ;
        if see_gpx:
            draw gpx withcolor gpx_color ;
        fi;




        if see_co :
            draw co_image ;
        fi;
        i:=0 ;
            forever :
                exitif unknown original_co_common[i] ;
                pair p ;
                p = original_co_common[i] ;
                draw fullcircle scaled 10 shifted p withcolor co_color ;
                dotlabel.ulft(decimal(i+1),p) withcolor co_color ;
                i:=i+1 ;
            endfor ;


        % gpx_common
        numeric i ;
        i:=0 ;
        if see_gpx:
            forever :
                exitif unknown original_gpx_common[i] ;
                show original_gpx_common[i] ;
                pair p ;
                p = original_gpx_common[i] transformed t_gpx ;
                draw fullcircle scaled 10 shifted p withcolor gpx_color ;
                dotlabel.ulft(decimal(i+1),p) withcolor gpx_color ;
                i:=i+1 ;
            endfor ;
        fi;

        % google_common
        numeric i ;
        i:=0 ;
        forever :
            exitif unknown original_google_common[i] ;
            pair p ;
            p = original_google_common[i] ;
            draw fullcircle scaled 10 shifted p withcolor google_color ;
            dotlabel.ulft(decimal(i+1),p) withcolor google_color ;
            i:=i+1 ;
        endfor ;



        path gpxa ;
        gpxa = gpx transformed tt ;
        draw gpxa withcolor blue ;


        path gpxb ;
        gpxb := gpxa transformed ttt ;
        draw gpxb withcolor (1,1,0) ;



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

let write_tex_file ~workdir ~project =
  let _ = project in
  let filename = sprintf "%s/main.tex" workdir in
  let _ = Log.info "write_tex_file %s" filename in
  let fout = open_out filename in
  let () = fprintf fout "%s\n" string_0 in
  let () = close_out fout in
  let _ = Log.info "write_tex_file done" in
  ()
