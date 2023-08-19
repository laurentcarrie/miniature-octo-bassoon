module Log = Dolog.Log

let model_of_gpx gpx_filename =
  let point_of_gpxpt xml =
    let () =
      match Xml.tag xml with "trkpt" | "wpt" -> () | _ -> failwith "bad tag"
    in
    let xml_time =
      List.hd
        (Xml.children
           (List.hd
              (List.filter (fun c -> Xml.tag c = "time") (Xml.children xml))))
    in
    let xml_ele =
      List.hd
        (Xml.children
           (List.hd
              (List.filter (fun c -> Xml.tag c = "ele") (Xml.children xml))))
    in

    (* <trkpt lat="48.8837222" lon="1.9895962999999999"><ele>224.81900000000002</ele><time>2023-08-06T09:56:55Z</time></trkpt> *)
    (*            <time>2023-08-17T11:16:01.000Z</time> *)
    let point =
      {
        Model.lon = Float.of_string (Xml.attrib xml "lon");
        Model.lat = Float.of_string (Xml.attrib xml "lat");
        Model.ele = Float.of_string (Xml.pcdata xml_ele);
        (*    val of_string_with_utc_offset : Base.String.t -> t *)
        (*  *)
        (* of_string_with_utc_offset requires its input to have an explicit UTC offset, e.g. 2000-01-01 12:34:56.789012-23, or use the UTC zone, "Z", e.g. 2000-01-01 12:34:56.789012Z. *)
        Model.time =
          (let tm : Unix.tm =
             Scanf.sscanf (Xml.pcdata xml_time)
               "%04d-%02d-%02dT%02d:%02d:%02d%s" (fun y m d h min s _ ->
                 {
                   Unix.tm_year = y;
                   tm_mon = m;
                   tm_mday = d;
                   tm_hour = h;
                   tm_min = min;
                   tm_sec = s;
                   tm_wday = 0;
                   tm_yday = 0;
                   tm_isdst = false;
                 })
           in
           let f, _ = Unix.mktime tm in
           f);
      }
    in
    point
  in

  let xml = Xml.parse_file gpx_filename in

  (*  let _ = Log.info ".. %s .." (Xml.to_string xml) in *)
  let gpx =
    List.hd (List.filter (fun c -> Xml.tag c = "trk") (Xml.children xml))
  in
  let gpxseg =
    List.hd (List.filter (fun c -> Xml.tag c = "trkseg") (Xml.children gpx))
  in
  let xml_wps = List.filter (fun c -> Xml.tag c = "wpt") (Xml.children xml) in
  let points = List.map point_of_gpxpt (Xml.children gpxseg) in
  let wpts = List.map point_of_gpxpt xml_wps in
  let data = { Model.title = "hello"; points; wpts } in

  (*  let _ = *)
  (*    List.iter *)
  (*      (fun point -> *)
  (*        let tm = Unix.gmtime point.Model.time in *)
  (*        Log.info "%02d:%02d:%02d" tm.tm_hour tm.tm_min tm.tm_sec) *)
  (*      data.Model.points *)
  (*  in *)
  let _ = Log.info "%d points" (List.length data.Model.points) in

  data
