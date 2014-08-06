type css = Normal | NoCSS | File of string

let genHtml : bool ref = ref false
let printingHtml : bool ref = ref false
let css : css ref = ref Normal
let filename : string ref = ref "out.html"
let page : Buffer.t = Buffer.create 0


(* display:block; border: 1px dashed maroon;
 *)
let header =
"<html>\n<head>" ^
"\n\t<style type=\"text/css\">" ^
"\n\t\tbody {" ^
"\n\t\t\tpadding: 2em 1em 2em 1em;" ^
"\n\t\t\tmargin: 0;" ^
"\n\t\t\tfont-family: sans-serif;" ^
"\n\t\t\tcolor: black;" ^
"\n\t\t\tbackground: white;}" ^
"\n\t\ta{text-decoration:none;}"^
"\n\t\ta:link { color: #00C; background: transparent }" ^
"\n\t\ta:visited { color: #00C; background: transparent }" ^
"\n\t\ta:active { color: #C00; background: transparent }" ^
"\n\t\tkeyword { color: #3333cc ; background: transparent }" ^
"\n\t\tp {display: inline;}"^
"\n\t\tpre {"^
"\n\t\t\tborder: 1px dashed maroon;  display:block; "^
"\n\t\t\tpadding:8px; background-color: #dddddd;}" ^
"\n\t\tcode {" ^
"\n\t\t\tbackground-color: #dddddd;"^
"\n\t\t\tcolor: black; font-family: \"courier\";margin:0; "^
"\n\t\t\twhite-space: pre-wrap; }" ^
"\n\t\t.typ {color: #660000; font-weight:bold}" ^
"\n\t\t.constructor {color: #335C85; font-weight:bold}" ^
"\n\t\t.function {color: #660033; font-weight:bold}" ^
"\n\t\t.schema {color: #6600CC; font-weight:bold}" ^
"\n\t</style>\t" ^
"</head>\n"

let generatePage () = 
begin
  (* Merge different code blocks into, as long as there isn't anything inbetween *)
  let fixCodeRegex = Str.regexp "</code></pre>\\(\\([\r\n\t]\\|<br>\\)*?\\)<pre><code>" in
  let page = Str.global_replace fixCodeRegex "\\1" (Buffer.contents page) in

  (* Output the HTML file *)
  let oc = open_out !filename in
  let out = output_string oc in
  begin match !css with
  | NoCSS -> out  (page ^ "\n");
  | Normal -> begin
      out header;
      out "<body>\n";
      out  page;
      out "\n</body>\n</html>\n"
    end
  | File s -> begin
      out "<html>\n<head>\n\t<link rel=\"stylesheet\" type=\"text/css\" href=\"";
      out s; out "\">\n</head>\n<body>\n";
      out page;
      out "\n</body>\n</html>\n"
    end
  end;
  close_out oc
end

(* let replaceNewLine = Str.global_replace (Str.regexp "[\n]") "<br>" *)

let append innerHtml =
  Buffer.add_string page ("<br><pre><code>" ^ innerHtml ^ "</code></pre>")

let appendAsComment innerHtml = 
  let innerHtml = Str.global_replace (Str.regexp_string "```") "" innerHtml in
  Buffer.add_string page  ("\n" ^ "<p>" ^ innerHtml ^ "</p>")

let ids = ref []

let addId s = ids := s::!ids

let idExists s = List.exists (fun x -> x=s) !ids

(* let turnstile = '⊢'

let arrow = '→'

let arrow2 = '⇒'*)