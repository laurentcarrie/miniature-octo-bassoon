open GMain
open GdkKeysyms
module Log = Dolog.Log

let _ = GtkMain.Main.init ()
let n_points_to_try = 5

let open_yml_file () =
  (*    let _ = prerr_endline "Ouch!" in *)
  let () = Log.info "ouch %s" "" in
  ()

let gpx_entry i x () =
  let () = Log.info "gpx entry %d %s" i x#text in
  ()

let gmap_entry i xy x () =
  let () = Log.info "gpx entry %d %s %s" i xy x#text in
  ()

let comap_entry i xy x () =
  let () = Log.info "gpx entry %d %s %s" i xy x#text in
  ()

type the_widgets = { nb_points : int;
see_gpx:GButton.toggle_button ;
gpx_indexes : GEdit.entry list;
see_google:GButton.toggle_button ;
google_coords : GEdit.entry list list ;
see_co:GButton.toggle_button ;
}

let project_of_widgets ~the_widgets =
  try
    let range = List.init the_widgets.nb_points (fun x -> x) in

    (*    let () = List.iter (fun i -> Log.info "in range : %d" i) range in *)
    let common_points =
      List.map
        (fun i ->
          {
            Gpx_plot.Model.gpx_index =
              int_of_string (List.nth the_widgets.gpx_indexes i)#text;
            google = { Gpx_plot.Model.x =
            float_of_string (List.nth (List.nth the_widgets.google_coords 0) i)# text ;
            y=float_of_string (List.nth (List.nth the_widgets.google_coords 1) i)# text ;
            } ;
            co = { Gpx_plot.Model.x = 0.0; y = 0.0 };
          })
        range
    in

    let p =
      {
        (*        Gpx_plot.Model.pdf = "out.pdf"; *)
        (*        gpx_file = "input.gpx"; *)
        (*        google_png_file = "google.png"; *)
        (*        co_png_file = "co.png"; *)
        Gpx_plot.Model.common_points;
        see_gpx = the_widgets.see_gpx#active ;
        see_google = the_widgets.see_google#active;
        see_co = the_widgets.see_co#active;
      }
    in
    p
  with e ->
    let msg = Printexc.to_string e and stack = Printexc.get_backtrace () in
    Printf.eprintf "there was an error: %s%s\n" msg stack;
    Stdlib.exit 1

let go_cb workdir the_widgets () =
  let () = Log.info "go %s" workdir in
  let project = project_of_widgets ~the_widgets in
  let () = Gpx_plot.Work.work ~workdir ~project in
  ()

let save_yml_file workdir the_widgets () =
  (*    let _ = prerr_endline "Ouch!" in *)
  let project_filename = Printf.sprintf "%s/conf2.yml" workdir in
  let () = Log.info "save %s" project_filename in
  let project = project_of_widgets ~the_widgets in
  let data = Gpx_plot.Model.serialize project in
  let () = Core.Out_channel.write_all project_filename ~data in
  ()

let widgets_of_project project w =
  try
    let _ = (project, w) in
    let () = Log.info "widgets of project %s" "" in

    let range = List.init n_points_to_try (fun x -> x) in
    let () = Log.info "range length : %d" (List.length range) in
    (*    let () = List.iter (fun i -> Log.info "in range : %d" i) range in *)

    (* gpx *)
    let () =
      List.iter
        (fun i ->
          let value =
            if i < List.length project.Gpx_plot.Model.common_points then
              let common_point =
                List.nth project.Gpx_plot.Model.common_points i
              in
              common_point.Gpx_plot.Model.gpx_index
            else 0
          in
          let () =
            (List.nth w.gpx_indexes i)#set_text (Printf.sprintf "%d" value)
          in
          ())
        range
    in

    (* google *)
    let () =
      List.iter
        (fun i ->
          let value =
            if i < List.length project.Gpx_plot.Model.common_points then
              let common_point =
                List.nth project.Gpx_plot.Model.common_points i
              in
              common_point.Gpx_plot.Model.google
            else { Gpx_plot.Model.x=0.0 ; y=0.0 }
          in
          let () =
            (List.nth (List.nth w.google_coords 0) i)#set_text (Printf.sprintf "%f" value.Gpx_plot.Model.x)
          in
          let () =
            (List.nth (List.nth w.google_coords 1) i)#set_text (Printf.sprintf "%f" value.Gpx_plot.Model.y)
          in
          ())
        range
    in



    let () = w.see_gpx#set_active project.Gpx_plot.Model.see_gpx in
    let () = w.see_google#set_active project.Gpx_plot.Model.see_google in
    let () = w.see_co#set_active project.Gpx_plot.Model.see_co in
    ()
  with e ->
    let msg = Printexc.to_string e and stack = Printexc.get_backtrace () in
    Printf.eprintf "there was an error: %s%s\n" msg stack;
    Stdlib.exit 1

let main () =
  Log.set_log_level Log.INFO;
  Log.set_output stdout;
  Log.color_on ();
  try
    let workdir = Array.get Sys.argv 1 in
    let project_filename = Printf.sprintf "%s/conf.yml" workdir in
    let data = Core.In_channel.read_all project_filename in
    let project = Gpx_plot.Model.deserialize data in

    let window =
      GWindow.window
      (*~width:320 ~height:240*)
      (*~border_width:20*)
        ~title:"GPX and CO map plot" ()
    in

    let vbox = GPack.vbox ~packing:window#add () in
    let _ = window#connect#destroy ~callback:Main.quit in

    (* Menu bar *)
    let menubar = GMenu.menu_bar ~packing:vbox#pack () in
    let factory = new GMenu.factory menubar in
    let accel_group = factory#accel_group in
    let file_menu = factory#add_submenu "File" in

    (* Button *)
    (*  let button = GButton.button ~label:"Push me!" ~packing:vbox#add () in *)
    (*  let _ = button#connect#clicked ~callback:(fun () -> prerr_endline "Ouch!") in *)
    let table =
      GPack.table ~rows:5 ~columns:5 ~homogeneous:true ~col_spacings:20
        ~border_width:1 ~packing:vbox#add ()
    in

    let current_row = 0 in
    let range = List.init n_points_to_try (fun x -> x) in

    let () =
      List.iter
        (fun i ->
          let label =
            GMisc.label ~text:(Printf.sprintf "Point %d" (i + 1)) ()
          in
          let _ = table#attach ~left:(i + 2) ~top:current_row label#coerce in
          ())
        range
    in

    let current_row = current_row + 2 in

    (* gpx points *)
    let entries_gpx : GEdit.entry list =
      let () =
        let label = GMisc.label ~text:"GPX point index" () in
        let _ = table#attach ~left:0 ~top:current_row label#coerce in
        ()
      in

      let entries =
        List.map
          (fun i ->
            let entry = GEdit.entry ~text:"" () in
            let _ = table#attach ~left:(i + 2) ~top:current_row entry#coerce in
            let _ =
              entry#connect#activate ~callback:(gpx_entry (i + 1) entry)
            in
            entry)
          range
      in
      entries
    in
    let cb_gpx = GButton.check_button ~label:"see" () in
    let _ = table#attach ~left:1 ~top:current_row cb_gpx#coerce in

    (*  let _ = entries in *)
    (*  let _ : GEdit.entry * GEdit.entry * GEdit.entry = (List.nth entries 0 , List.nth entries 1 , List.nth entries 2) in *)

    let current_row = current_row + 1 in

    (* google maps points *)
    let (entries_google : GEdit.entry list list) =
      List.map
        (fun (row, t) ->
          let label =
            GMisc.label ~text:(Printf.sprintf "maps image %s " t) ()
          in
          let _ = table#attach ~left:0 ~top:row label#coerce in

          let entries =
            List.map
              (fun i ->
                let entry = GEdit.entry ~text:"" () in
                let _ = table#attach ~left:(i + 2) ~top:row entry#coerce in
                let _ =
                  entry#connect#activate ~callback:(gmap_entry (i + 1) t entry)
                in
                entry)
              range
          in
          entries)
        [ (current_row, "X"); (current_row + 1, "Y") ]
    in
    let cb_google = GButton.check_button ~label:"see" () in
    let _ = table#attach ~left:1 ~top:current_row cb_google#coerce in

    let current_row = current_row + 2 in

    (* co maps points *)
    let () =
      let _ =
        List.iter
          (fun (row, t) ->
            let label = GMisc.label ~text:(Printf.sprintf "co map %s " t) () in
            let _ = table#attach ~left:0 ~top:row label#coerce in

            let () =
              List.iter
                (fun i ->
                  let entry = GEdit.entry ~text:"" () in
                  let _ = table#attach ~left:(i + 2) ~top:row entry#coerce in
                  let _ =
                    entry#connect#activate
                      ~callback:(comap_entry (i + 1) t entry)
                  in
                  ())
                range
            in

            ())
          [ (current_row, "X"); (current_row + 1, "Y") ]
      in
      ()
    in
    let cb_co = GButton.check_button ~label:"see" () in
    let _ = table#attach ~left:1 ~top:current_row cb_co#coerce in

    let button = GButton.button ~label:"Go !" () in
    let _ = table#attach ~left:0 ~top:0 button#coerce in

    let the_widgets = { nb_points = 3; see_gpx = cb_gpx ; see_google=cb_google;see_co=cb_co ;gpx_indexes = entries_gpx ;
     google_coords=entries_google ; } in

    let _ = button#connect#clicked ~callback:(go_cb workdir the_widgets) in


    let () = widgets_of_project project the_widgets in

    (* File menu *)
    let factory = new GMenu.factory file_menu ~accel_group in
    let _ = factory#add_item "Open" ~key:_O ~callback:open_yml_file in
    let _ =
      factory#add_item "Save" ~key:_S
        ~callback:(save_yml_file workdir the_widgets)
    in
    let _ = factory#add_item "Quit" ~key:_Q ~callback:Main.quit in

    (* Display the windows and enter Gtk+ main loop *)
    window#add_accel_group accel_group;
    window#show ();
    Main.main ()
  with e ->
    let msg = Printexc.to_string e and stack = Printexc.get_backtrace () in
    Printf.eprintf "there was an error: %s%s\n" msg stack;
    Stdlib.exit 1

let () = main ()
