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

  (*  let () = fprintf fout "%% %s\n" filename in *)
  (*  let () = fprintf fout "%% %s\n" trk.Model.title in *)
  (*  let () = fprintf fout "width:=%f ;\n" width in *)
  (*  let () = fprintf fout "height:=%f ;\n" height in *)
  let data : string =
    {whatever|
prologues:=3;
outputtemplate := "marly.mps";
outputformat := "mps";
input boxes ;
input TEX ;
verbatimtex
\documentclass{article}
%%\usepackage{lmodern}
\usepackage[tt=false]{libertine}
\usepackage[libertine]{newtxmath}
\usepackage{amsmath}
\begin{document}
etex

beginfig(0);
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



    pickup pencircle scaled .01;

    %draw (-width,-height) -- (width,-height) -- (width,height) -- (-width,height) -- cycle withcolor (1,0,0) ;

    path trk ;
    trk =

|whatever}
  in

  let _ = data in
  let _ = width in
  let _ = height in
  let _ = ratio in

  (*  let () = fprintf fout "%s\n" data in *)
  let pair_of_point (x, y, _) = sprintf "(%f,%f)" x y in

  let pairs =
    List.fold_left
      (fun a b -> a ^ " -- " ^ b ^ "\n")
      (pair_of_point (List.hd xyz_points))
      (List.map pair_of_point (List.tl xyz_points))
  in

  let () = fprintf fout "%s" "vardef gpx(expr t)=\n" in
  let () = fprintf fout "path p ; p := %s ; \n" pairs in
  let () = fprintf fout "p := p transformed t ;\n" in
  let () = fprintf fout "p \n" in
  let () = fprintf fout "enddef;\n" in
  let epilog = {whatever|
endfig;
end.

|whatever} in
  (*  let () = fprintf fout "%s" epilog in *)
  let _ = epilog in
  ()
