open Printf
module Log = Dolog.Log

let write_mp_file trk filename width height x0 y0 ratio =
  let origin = List.hd trk.Model.points in

  let xyz_points : (float * float * float) list =
    List.map (fun point -> Gps.xyz_of_point origin point) trk.Model.points
  in

  let xyz_points =
    List.map
      (fun (x, y, z) -> ((x *. ratio) +. x0, (y *. ratio) +. y0, z))
      xyz_points
  in

  let fout = open_out filename in
  let () = fprintf fout "%% %s\n" filename in
  let () = fprintf fout "%% %s\n" trk.Model.title in
  let () = fprintf fout "width:=%f ;\n" width in
  let () = fprintf fout "height:=%f ;\n" height in
  let data : string =
    {whatever|
input exteps ;
prologues:=2;
outputtemplate := "marly.mps";
outputformat := "mps";
input boxes ;
%input TEX ;
%input exteps ;
verbatimtex
\documentclass{article}
%%\usepackage{lmodern}
\usepackage[tt=false]{libertine}
\usepackage[libertine]{newtxmath}
\usepackage{amsmath}
\begin{document}
etex

beginfig(0);

%begineps "le-carrosse.eps";
%base := (25,25);
%clipping := true;
%grid := true;
%epsdrawdot(36pct,80pct) withpen pencircle scaled 10pct withcolor blue;
%epsdrawdot(60.5pct,80pct) withpen pencircle scaled 10pct withcolor blue;
%epsdraw (35pct,60pct)..(48pct,54pct){right}..(61pct,60pct) withpen pencircle
%scaled 2pct withcolor red;
%endeps;

    pickup pencircle scaled .05;

    numeric m ;
    path p;
    m=10 ;

    pickup pencircle scaled .001;
%    for i = -m upto m: 
%        p := (-m/10,i/10) -- (m/10,i/10)  ; 
%        draw p withcolor (0,1,0); 
%    endfor ; 
%  
%    for i = -m upto m: 
%        p := (i/10,-m/10) -- (i/10,m/10) ; 
%        draw p withcolor (0,1,0); 
%    endfor ; 
%
    %picture A ;
    %A = TEX("\includegraphics[width=300pt]{le-carrosse.pdf}");
    %draw A ;



    fill fullcircle scaled .05 withcolor (0,1,0) ;


    pickup pencircle scaled .01;

    %draw (-width,-height) -- (width,-height) -- (width,height) -- (-width,height) -- cycle withcolor (1,0,0) ;

    path trk ;
    trk =

|whatever}
  in

  let () = fprintf fout "%s\n" data in

  let pair_of_point (x, y, _) = sprintf "(%f,%f)" x y in

  let pairs =
    List.fold_left
      (fun a b -> a ^ " -- " ^ b)
      (pair_of_point (List.hd xyz_points))
      (List.map pair_of_point (List.tl xyz_points))
  in

  let () = fprintf fout "%s ; \n draw trk withcolor (0,1,0) ;\n" pairs in

  let epilog = {whatever|
endfig;
end.

|whatever} in
  let () = fprintf fout "%s" epilog in

  ()
