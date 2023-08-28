open GMain
open GdkKeysyms
module Log = Dolog.Log

let _ = GtkMain.Main.init ()

let open_yml_file () =
  (*    let _ = prerr_endline "Ouch!" in *)
  let () = Log.info "ouch %s" "" in
  ()

let enter_entry_gpx_file x () =
  let () = Log.info "enter gpx file %s" x#text in
  ()

(* let enter_entry_google_maps_file x () = *)
(*  let () = Log.info "enter google_maps file %s" x#text in *)
(*  () *)

let enter_entry_orienteering_map_file x () =
  let () = Log.info "enter orienteering map file %s" x#text in
  ()

let enter_entry_pdf_output_file x () =
  let () = Log.info "enter pdf output file %s" x#text in
  ()


let file_ok_fs_google_maps_file x () =
  let () = Log.info "file changed %s" x#filename in
  ()

let main () =
  Log.set_log_level Log.INFO;
  Log.set_output stdout;
  Log.color_on ();

  let window =
    GWindow.window (*~width:320 ~height:240*)  (*~border_width:20*) ~title:"GPX and CO map plot" ()
  in

  let vbox = GPack.vbox ~packing:window#add () in
  let _ = window#connect#destroy ~callback:Main.quit in

  (* Menu bar *)
  let menubar = GMenu.menu_bar ~packing:vbox#pack () in
  let factory = new GMenu.factory menubar in
  let accel_group = factory#accel_group in
  let file_menu = factory#add_submenu "File" in

  (* File menu *)
  let factory = new GMenu.factory file_menu ~accel_group in
  let _ = factory#add_item "Open" ~key:_O ~callback:open_yml_file in
  let _ = factory#add_item "Quit" ~key:_Q ~callback:Main.quit in

  (* Button *)
(*  let button = GButton.button ~label:"Push me!" ~packing:vbox#add () in *)
(*  let _ = button#connect#clicked ~callback:(fun () -> prerr_endline "Ouch!") in *)

  let table = GPack.table ~rows:5 ~columns:5 ~homogeneous:true
      ~packing:vbox#add () in

let max_length=4 in

    let () = List.map( fun i ->
    let label = GMisc.label ~text:(Printf.sprintf "Point %d") () in
    let _ = table#attach ~left:i ~top:0 (label#coerce) in
    ()) [ 1;2;3] in

    let label = GMisc.label ~text:"Point 2" () in
  let _ = table#attach ~left:1 ~top:0 (label#coerce) in


 (* gpx file *)
  let label = GMisc.label ~text:"gpx point "  () in
  let _ = table#attach ~left:0 ~top:0 (label#coerce) in
  let entry_gpx_file =
    GEdit.entry ~text:"???" ~max_length ()

  in
  let _ = table#attach ~left:1 ~top:0 (entry_gpx_file#coerce) in
  let _ =
    entry_gpx_file#connect#activate
      ~callback:(enter_entry_gpx_file entry_gpx_file)
  in

    (* google maps file *)
  let label = GMisc.label ~text:"google maps file"  () in
  let _ = table#attach ~left:0 ~top:1 (label#coerce) in
  let fs_google_maps_file = GWindow.file_selection ~title:"google maps" ~border_width:10
     () in
       (* Connect the ok_button to file_ok_sel function *)
  let _ = fs_google_maps_file#ok_button#connect#clicked ~callback:(file_ok_fs_google_maps_file fs_google_maps_file) in

  (* Connect the cancel_button to destroy the widget *)
  let _ = fs_google_maps_file#cancel_button#connect#clicked ~callback:fs_google_maps_file#destroy in


  (* Display the windows and enter Gtk+ main loop *)
  window#add_accel_group accel_group;
  window#show ();
  Main.main ()

let () = main ()
