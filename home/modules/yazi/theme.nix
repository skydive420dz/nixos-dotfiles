{ palette }:

let
  p = palette;
in
{
  "app" = {
    "overall" = {
      "bg" = p.base;
    };
  };
  "cmp" = {
    "border" = {
      "fg" = p.blue;
    };
  };
  "confirm" = {
    "body" = {};
    "border" = {
      "fg" = p.blue;
    };
    "btn_no" = {};
    "btn_yes" = {
      "reversed" = true;
    };
    "list" = {};
    "title" = {
      "fg" = p.blue;
    };
  };
  "filetype" = {
    "rules" = [
      {
        "fg" = p.teal;
        "mime" = "image/*";
      }
      {
        "fg" = p.yellow;
        "mime" = "{audio,video}/*";
      }
      {
        "fg" = p.pink;
        "mime" = "application/*zip";
      }
      {
        "fg" = p.pink;
        "mime" = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
      }
      {
        "fg" = p.green;
        "mime" = "application/{pdf,doc,rtf}";
      }
      {
        "fg" = p.surface1;
        "mime" = "vfs/{absent,stale}";
      }
      {
        "bg" = p.red;
        "is" = "orphan";
        "url" = "*";
      }
      {
        "fg" = p.green;
        "is" = "exec";
        "url" = "*";
      }
      {
        "bg" = p.red;
        "is" = "dummy";
        "url" = "*";
      }
      {
        "bg" = p.red;
        "is" = "dummy";
        "url" = "*/";
      }
      {
        "fg" = p.blue;
        "url" = "*/";
      }
    ];
  };
  "help" = {
    "desc" = {
      "fg" = p.overlay2;
    };
    "footer" = {
      "bg" = p.surface1;
      "fg" = p.text;
    };
    "hovered" = {
      "bg" = p.surface2;
      "bold" = true;
    };
    "on" = {
      "fg" = p.teal;
    };
    "run" = {
      "fg" = p.pink;
    };
  };
  "icon" = {
    "exts" = [
      {
        "fg" = p.rosewater;
        "name" = "otf";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "import";
        "text" = "";
      }
      {
        "fg" = p.mauve;
        "name" = "krz";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "adb";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "ttf";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "webpack";
        "text" = "󰜫";
      }
      {
        "fg" = p.surface2;
        "name" = "dart";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "vsh";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "doc";
        "text" = "󰈬";
      }
      {
        "fg" = p.green;
        "name" = "zsh";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "ex";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "hx";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "fodt";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "mojo";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "templ";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "nix";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "cshtml";
        "text" = "󱦗";
      }
      {
        "fg" = p.surface2;
        "name" = "fish";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "ply";
        "text" = "󰆧";
      }
      {
        "fg" = p.green;
        "name" = "sldprt";
        "text" = "󰻫";
      }
      {
        "fg" = p.surface0;
        "name" = "gemspec";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "mjs";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "csh";
        "text" = "";
      }
      {
        "fg" = p.text;
        "name" = "cmake";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "fodp";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "vi";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "msf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "blp";
        "text" = "󰺾";
      }
      {
        "fg" = p.surface1;
        "name" = "less";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "sh";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "odg";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "mint";
        "text" = "󰌪";
      }
      {
        "fg" = p.crust;
        "name" = "dll";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "odf";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "sqlite3";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "Dockerfile";
        "text" = "󰡨";
      }
      {
        "fg" = p.surface2;
        "name" = "ksh";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "rmd";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "wv";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "xml";
        "text" = "󰗀";
      }
      {
        "fg" = p.text;
        "name" = "markdown";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "qml";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "3gp";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "pxi";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "flac";
        "text" = "";
      }
      {
        "fg" = p.mauve;
        "name" = "gpr";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "huff";
        "text" = "󰡘";
      }
      {
        "fg" = p.yellow;
        "name" = "json";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "gv";
        "text" = "󱁉";
      }
      {
        "fg" = p.overlay1;
        "name" = "bmp";
        "text" = "";
      }
      {
        "fg" = p.subtext1;
        "name" = "lock";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "sha384";
        "text" = "󰕥";
      }
      {
        "fg" = p.surface2;
        "name" = "cobol";
        "text" = "⚙";
      }
      {
        "fg" = p.surface2;
        "name" = "cob";
        "text" = "⚙";
      }
      {
        "fg" = p.red;
        "name" = "java";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "cjs";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "qm";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "ebuild";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "mustache";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "terminal";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "ejs";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "brep";
        "text" = "󰻫";
      }
      {
        "fg" = p.peach;
        "name" = "rar";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "gradle";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "gnumakefile";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "applescript";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "elm";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "ebook";
        "text" = "";
      }
      {
        "fg" = p.mauve;
        "name" = "kra";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "tf";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "xls";
        "text" = "󰈛";
      }
      {
        "fg" = p.yellow;
        "name" = "fnl";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "kdbx";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "kicad_pcb";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "cfg";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "ape";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "org";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "yml";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "swift";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "eln";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "sol";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "awk";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "7z";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "apl";
        "text" = "⍝";
      }
      {
        "fg" = p.peach;
        "name" = "epp";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "app";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "dot";
        "text" = "󱁉";
      }
      {
        "fg" = p.mauve;
        "name" = "kpp";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "eot";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "hpp";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "spec.tsx";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "hurl";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "cxxm";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "c";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcmacro";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "sass";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "yaml";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "xz";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "material";
        "text" = "󰔉";
      }
      {
        "fg" = p.yellow;
        "name" = "json5";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "signature";
        "text" = "λ";
      }
      {
        "fg" = p.overlay1;
        "name" = "3mf";
        "text" = "󰆧";
      }
      {
        "fg" = p.overlay1;
        "name" = "jpg";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "xpi";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcmat";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "pot";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "bin";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "xlsx";
        "text" = "󰈛";
      }
      {
        "fg" = p.sapphire;
        "name" = "aac";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "kicad_sym";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "xcstrings";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "lff";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "xcf";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "azcli";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "license";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "jsonc";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "xaml";
        "text" = "󰙳";
      }
      {
        "fg" = p.overlay1;
        "name" = "md5";
        "text" = "󰕥";
      }
      {
        "fg" = p.sapphire;
        "name" = "xm";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "sln";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "jl";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "ml";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "http";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "x";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "wvc";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "wrz";
        "text" = "󰆧";
      }
      {
        "fg" = p.surface2;
        "name" = "csproj";
        "text" = "󰪮";
      }
      {
        "fg" = p.overlay1;
        "name" = "wrl";
        "text" = "󰆧";
      }
      {
        "fg" = p.sapphire;
        "name" = "wma";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "woff2";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "woff";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "tscn";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "webmanifest";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "webm";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcbak";
        "text" = "";
      }
      {
        "fg" = p.text;
        "name" = "log";
        "text" = "󰌱";
      }
      {
        "fg" = p.sapphire;
        "name" = "wav";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "wasm";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "styl";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "gif";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "resi";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "aiff";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "sha256";
        "text" = "󰕥";
      }
      {
        "fg" = p.green;
        "name" = "igs";
        "text" = "󰻫";
      }
      {
        "fg" = p.overlay0;
        "name" = "vsix";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "vim";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "diff";
        "text" = "";
      }
      {
        "fg" = p.maroon;
        "name" = "drl";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "erl";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "vhdl";
        "text" = "󰍛";
      }
      {
        "fg" = p.peach;
        "name" = "🔥";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "hrl";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "fsi";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "mm";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "bz";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "vh";
        "text" = "󰍛";
      }
      {
        "fg" = p.green;
        "name" = "kdb";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "gz";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "cpp";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "ui";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "txt";
        "text" = "󰈙";
      }
      {
        "fg" = p.sapphire;
        "name" = "spec.ts";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "ccm";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "typoscript";
        "text" = "";
      }
      {
        "fg" = p.sky;
        "name" = "typ";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "txz";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "test.ts";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "tsx";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "mk";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "webp";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "opus";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "bicep";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "ts";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "tres";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "torrent";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "cxx";
        "text" = "";
      }
      {
        "fg" = p.flamingo;
        "name" = "iso";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "ixx";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "hxx";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "gql";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "tmux";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "ini";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "m3u8";
        "text" = "󰲹";
      }
      {
        "fg" = p.flamingo;
        "name" = "image";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "tfvars";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "tex";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "cbl";
        "text" = "⚙";
      }
      {
        "fg" = p.rosewater;
        "name" = "flc";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "elc";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "test.tsx";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "twig";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "sql";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "test.jsx";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "htm";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "gcode";
        "text" = "󰐫";
      }
      {
        "fg" = p.yellow;
        "name" = "test.js";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "ino";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "tcl";
        "text" = "󰛓";
      }
      {
        "fg" = p.sapphire;
        "name" = "cljs";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "tsconfig";
        "text" = "";
      }
      {
        "fg" = p.flamingo;
        "name" = "img";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "t";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcstd1";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "out";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "jsx";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "bash";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "edn";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "rss";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "flf";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "cache";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "sbt";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "cppm";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "svelte";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "mo";
        "text" = "∞";
      }
      {
        "fg" = p.green;
        "name" = "sv";
        "text" = "󰍛";
      }
      {
        "fg" = p.rosewater;
        "name" = "ko";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "suo";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "sldasm";
        "text" = "󰻫";
      }
      {
        "fg" = p.surface0;
        "name" = "icalendar";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "go";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "sublime";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "stl";
        "text" = "󰆧";
      }
      {
        "fg" = p.peach;
        "name" = "mobi";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "graphql";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "m3u";
        "text" = "󰲹";
      }
      {
        "fg" = p.surface2;
        "name" = "cpy";
        "text" = "⚙";
      }
      {
        "fg" = p.blue;
        "name" = "kdenlive";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "pyo";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "po";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "scala";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "exs";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "odp";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "dump";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "stp";
        "text" = "󰻫";
      }
      {
        "fg" = p.green;
        "name" = "step";
        "text" = "󰻫";
      }
      {
        "fg" = p.green;
        "name" = "ste";
        "text" = "󰻫";
      }
      {
        "fg" = p.sapphire;
        "name" = "aif";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "strings";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "cp";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "fsscript";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "mli";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "bak";
        "text" = "󰁯";
      }
      {
        "fg" = p.yellow;
        "name" = "ssa";
        "text" = "󰨖";
      }
      {
        "fg" = p.surface2;
        "name" = "toml";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "makefile";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "php";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "zst";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "spec.jsx";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "kbx";
        "text" = "󰯄";
      }
      {
        "fg" = p.overlay1;
        "name" = "fbx";
        "text" = "󰆧";
      }
      {
        "fg" = p.peach;
        "name" = "blend";
        "text" = "󰂫";
      }
      {
        "fg" = p.green;
        "name" = "ifc";
        "text" = "󰻫";
      }
      {
        "fg" = p.yellow;
        "name" = "spec.js";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "so";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "desktop";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "sml";
        "text" = "λ";
      }
      {
        "fg" = p.green;
        "name" = "slvs";
        "text" = "󰻫";
      }
      {
        "fg" = p.peach;
        "name" = "pp";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "ps1";
        "text" = "󰨊";
      }
      {
        "fg" = p.overlay0;
        "name" = "dropbox";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "kicad_mod";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "bat";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "slim";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "skp";
        "text" = "󰻫";
      }
      {
        "fg" = p.blue;
        "name" = "css";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "xul";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "ige";
        "text" = "󰻫";
      }
      {
        "fg" = p.peach;
        "name" = "glb";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "ppt";
        "text" = "󰈧";
      }
      {
        "fg" = p.overlay1;
        "name" = "sha512";
        "text" = "󰕥";
      }
      {
        "fg" = p.surface0;
        "name" = "ics";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "mdx";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "sha1";
        "text" = "󰕥";
      }
      {
        "fg" = p.green;
        "name" = "f3d";
        "text" = "󰻫";
      }
      {
        "fg" = p.yellow;
        "name" = "ass";
        "text" = "󰨖";
      }
      {
        "fg" = p.overlay1;
        "name" = "godot";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "ifb";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "cson";
        "text" = "";
      }
      {
        "fg" = p.crust;
        "name" = "lib";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "luac";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "heex";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "scm";
        "text" = "󰘧";
      }
      {
        "fg" = p.overlay1;
        "name" = "psd1";
        "text" = "󰨊";
      }
      {
        "fg" = p.red;
        "name" = "sc";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "scad";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "kts";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "svh";
        "text" = "󰍛";
      }
      {
        "fg" = p.sapphire;
        "name" = "mts";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "nfo";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "pck";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "rproj";
        "text" = "󰗆";
      }
      {
        "fg" = p.peach;
        "name" = "rlib";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "cljd";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "ods";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "res";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "apk";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "haml";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "d.ts";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "razor";
        "text" = "󱦘";
      }
      {
        "fg" = p.surface0;
        "name" = "rake";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "patch";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "cuh";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "d";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "query";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "psb";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "nu";
        "text" = ">";
      }
      {
        "fg" = p.peach;
        "name" = "mov";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "lrc";
        "text" = "󰨖";
      }
      {
        "fg" = p.blue;
        "name" = "pyx";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "pyw";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "cu";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "bazel";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "obj";
        "text" = "󰆧";
      }
      {
        "fg" = p.yellow;
        "name" = "pyi";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "pyd";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "exe";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "pyc";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fctb";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "part";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "blade.php";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "git";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "psd";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "qss";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "csv";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "psm1";
        "text" = "󰨊";
      }
      {
        "fg" = p.rosewater;
        "name" = "dconf";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "config.ru";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "prisma";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "conf";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "clj";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "o";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "mp4";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "cc";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "kicad_prl";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "bz3";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "asc";
        "text" = "󰦝";
      }
      {
        "fg" = p.overlay1;
        "name" = "png";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "android";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "pm";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "h";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "pls";
        "text" = "󰲹";
      }
      {
        "fg" = p.peach;
        "name" = "ipynb";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "pl";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "ads";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "sqlite";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "pdf";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "pcm";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "ico";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "a";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "R";
        "text" = "󰟔";
      }
      {
        "fg" = p.overlay0;
        "name" = "ogg";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "pxd";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "kdenlivetitle";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "jxl";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "nswag";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "nim";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "bqn";
        "text" = "⎉";
      }
      {
        "fg" = p.sapphire;
        "name" = "cts";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcparam";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "rs";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "mpp";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "fdmdownload";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "pptx";
        "text" = "󰈧";
      }
      {
        "fg" = p.overlay1;
        "name" = "jpeg";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "bib";
        "text" = "󱉟";
      }
      {
        "fg" = p.green;
        "name" = "vhd";
        "text" = "󰍛";
      }
      {
        "fg" = p.blue;
        "name" = "m";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "js";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "eex";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "tbc";
        "text" = "󰛓";
      }
      {
        "fg" = p.red;
        "name" = "astro";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "sha224";
        "text" = "󰕥";
      }
      {
        "fg" = p.peach;
        "name" = "xcplayground";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "el";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "m4v";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "m4a";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "cs";
        "text" = "󰌛";
      }
      {
        "fg" = p.overlay1;
        "name" = "hs";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "tgz";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "fs";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "luau";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "dxf";
        "text" = "󰻫";
      }
      {
        "fg" = p.teal;
        "name" = "download";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "cast";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "qrc";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "lua";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "lhs";
        "text" = "";
      }
      {
        "fg" = p.text;
        "name" = "md";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "leex";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "ai";
        "text" = "";
      }
      {
        "fg" = p.subtext1;
        "name" = "lck";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "kt";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "bicepparam";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "hex";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "zig";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "bzl";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "cljc";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "kicad_dru";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fctl";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "f#";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "odt";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "conda";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "vala";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "erb";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "mp3";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "bz2";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "coffee";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "cr";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "f90";
        "text" = "󱈚";
      }
      {
        "fg" = p.overlay0;
        "name" = "jwmrc";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "c++";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcscript";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "fods";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "cue";
        "text" = "󰲹";
      }
      {
        "fg" = p.yellow;
        "name" = "srt";
        "text" = "󰨖";
      }
      {
        "fg" = p.yellow;
        "name" = "info";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "hh";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "sig";
        "text" = "λ";
      }
      {
        "fg" = p.peach;
        "name" = "html";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "iges";
        "text" = "󰻫";
      }
      {
        "fg" = p.rosewater;
        "name" = "kicad_wks";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "hbs";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcstd";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "gresource";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "sub";
        "text" = "󰨖";
      }
      {
        "fg" = p.surface0;
        "name" = "ical";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "crdownload";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "pub";
        "text" = "󰷖";
      }
      {
        "fg" = p.green;
        "name" = "vue";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "gd";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "fsx";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "mkv";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "py";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "kicad_sch";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "epub";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "env";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "magnet";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = "elf";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "fodg";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "svg";
        "text" = "󰜡";
      }
      {
        "fg" = p.green;
        "name" = "dwg";
        "text" = "󰻫";
      }
      {
        "fg" = p.surface2;
        "name" = "docx";
        "text" = "󰈬";
      }
      {
        "fg" = p.yellow;
        "name" = "pro";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "db";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "rb";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "r";
        "text" = "󰟔";
      }
      {
        "fg" = p.red;
        "name" = "scss";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "cow";
        "text" = "󰆚";
      }
      {
        "fg" = p.pink;
        "name" = "gleam";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "v";
        "text" = "󰍛";
      }
      {
        "fg" = p.rosewater;
        "name" = "kicad_pro";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "liquid";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "zip";
        "text" = "";
      }
    ];
    "files" = [
      {
        "fg" = p.mauve;
        "name" = "kritadisplayrc";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = ".gtkrc-2.0";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "bspwmrc";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "webpack";
        "text" = "󰜫";
      }
      {
        "fg" = p.sapphire;
        "name" = "tsconfig.json";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".vimrc";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "gemfile$";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "xmobarrc";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "avif";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "fp-info-cache";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".zshrc";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "robots.txt";
        "text" = "󰚩";
      }
      {
        "fg" = p.blue;
        "name" = "dockerfile";
        "text" = "󰡨";
      }
      {
        "fg" = p.peach;
        "name" = ".git-blame-ignore-revs";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".nvmrc";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "hyprpaper.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierignore";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "rakefile";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "code_of_conduct";
        "text" = "";
      }
      {
        "fg" = p.text;
        "name" = "cmakelists.txt";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = ".env";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "copying.lesser";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "readme";
        "text" = "󰂺";
      }
      {
        "fg" = p.surface2;
        "name" = "settings.gradle";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "gruntfile.coffee";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = ".eslintignore";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "kalgebrarc";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "kdenliverc";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.cjs";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "cantorrc";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "rmd";
        "text" = "";
      }
      {
        "fg" = p.overlay0;
        "name" = "vagrantfile$";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".Xauthority";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "prettier.config.ts";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "node_modules";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.toml";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "build.zig.zon";
        "text" = "";
      }
      {
        "fg" = p.surface1;
        "name" = ".ds_store";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "PKGBUILD";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".bash_profile";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = ".npmignore";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".mailmap";
        "text" = "󰊢";
      }
      {
        "fg" = p.green;
        "name" = ".codespellrc";
        "text" = "󰓆";
      }
      {
        "fg" = p.peach;
        "name" = "svelte.config.js";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "eslint.config.ts";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "config";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".gitlab-ci.yml";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".gitconfig";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "_gvimrc";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".xinitrc";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "checkhealth";
        "text" = "󰓙";
      }
      {
        "fg" = p.surface0;
        "name" = "sxhkdrc";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".bashrc";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "tailwind.config.mjs";
        "text" = "󱏿";
      }
      {
        "fg" = p.peach;
        "name" = "ext_typoscript_setup.txt";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "commitlint.config.ts";
        "text" = "󰜘";
      }
      {
        "fg" = p.yellow;
        "name" = "py.typed";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = ".nanorc";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "commit_editmsg";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".luaurc";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "fp-lib-table";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = ".editorconfig";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "justfile";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "kdeglobals";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "license.md";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = ".clang-format";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "docker-compose.yaml";
        "text" = "󰡨";
      }
      {
        "fg" = p.yellow;
        "name" = "copying";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "go.mod";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "lxqt.conf";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "brewfile";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "gulpfile.coffee";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".dockerignore";
        "text" = "󰡨";
      }
      {
        "fg" = p.overlay0;
        "name" = ".settings.json";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "tailwind.config.js";
        "text" = "󱏿";
      }
      {
        "fg" = p.overlay1;
        "name" = ".clang-tidy";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".gvimrc";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "nuxt.config.cjs";
        "text" = "󱄆";
      }
      {
        "fg" = p.peach;
        "name" = "xsettingsd.conf";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "nuxt.config.js";
        "text" = "󱄆";
      }
      {
        "fg" = p.surface2;
        "name" = "eslint.config.cjs";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "sym-lib-table";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".condarc";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "xmonad.hs";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "tmux.conf";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "xmobarrc.hs";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.yaml";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".pre-commit-config.yaml";
        "text" = "󰛢";
      }
      {
        "fg" = p.rosewater;
        "name" = "i3blocks.conf";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "xorg.conf";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".zshenv";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "vlcrc";
        "text" = "󰕼";
      }
      {
        "fg" = p.yellow;
        "name" = "license";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "unlicense";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "tmux.conf.local";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".SRCINFO";
        "text" = "󰣇";
      }
      {
        "fg" = p.sapphire;
        "name" = "tailwind.config.ts";
        "text" = "󱏿";
      }
      {
        "fg" = p.subtext1;
        "name" = "security.md";
        "text" = "󰒃";
      }
      {
        "fg" = p.subtext1;
        "name" = "security";
        "text" = "󰒃";
      }
      {
        "fg" = p.surface2;
        "name" = ".eslintrc";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "gradle.properties";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "code_of_conduct.md";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "PrusaSlicerGcodeViewer.ini";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "PrusaSlicer.ini";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "procfile";
        "text" = "";
      }
      {
        "fg" = p.base;
        "name" = "mpv.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.json5";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "i3status.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "prettier.config.mjs";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = ".pylintrc";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "prettier.config.cjs";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".luacheckrc";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "containerfile";
        "text" = "󰡨";
      }
      {
        "fg" = p.surface2;
        "name" = "eslint.config.mjs";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "gruntfile.js";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "bun.lockb";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".gitattributes";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "gruntfile.ts";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "pom.xml";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "favicon.ico";
        "text" = "";
      }
      {
        "fg" = p.surface0;
        "name" = "package-lock.json";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "build";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "package.json";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "nuxt.config.ts";
        "text" = "󱄆";
      }
      {
        "fg" = p.green;
        "name" = "nuxt.config.mjs";
        "text" = "󱄆";
      }
      {
        "fg" = p.overlay1;
        "name" = "mix.lock";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "makefile";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "gulpfile.js";
        "text" = "";
      }
      {
        "fg" = p.overlay2;
        "name" = "lxde-rc.xml";
        "text" = "";
      }
      {
        "fg" = p.mauve;
        "name" = "kritarc";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "gtkrc";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "ionic.config.json";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.mjs";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.yml";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = ".npmrc";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "weston.ini";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "gulpfile.babel.js";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "i18n.config.ts";
        "text" = "󰗊";
      }
      {
        "fg" = p.teal;
        "name" = "commitlint.config.js";
        "text" = "󰜘";
      }
      {
        "fg" = p.peach;
        "name" = ".gitmodules";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "gradle-wrapper.properties";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "hypridle.conf";
        "text" = "";
      }
      {
        "fg" = p.rosewater;
        "name" = "vercel.json";
        "text" = "▲";
      }
      {
        "fg" = p.sapphire;
        "name" = "hyprlock.conf";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "go.sum";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "kdenlive-layoutsrc";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "gruntfile.babel.js";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "compose.yml";
        "text" = "󰡨";
      }
      {
        "fg" = p.overlay1;
        "name" = "i18n.config.js";
        "text" = "󰗊";
      }
      {
        "fg" = p.rosewater;
        "name" = "readme.md";
        "text" = "󰂺";
      }
      {
        "fg" = p.surface2;
        "name" = "gradlew";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "go.work";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "gulpfile.ts";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = "gnumakefile";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "FreeCAD.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "compose.yaml";
        "text" = "󰡨";
      }
      {
        "fg" = p.surface2;
        "name" = "eslint.config.js";
        "text" = "";
      }
      {
        "fg" = p.sapphire;
        "name" = "hyprland.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "docker-compose.yml";
        "text" = "󰡨";
      }
      {
        "fg" = p.surface2;
        "name" = "groovy";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "QtProject.conf";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = "platformio.ini";
        "text" = "";
      }
      {
        "fg" = p.surface2;
        "name" = "build.gradle";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".nuxtrc";
        "text" = "󱄆";
      }
      {
        "fg" = p.green;
        "name" = "_vimrc";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".zprofile";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".xsession";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "prettier.config.js";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = ".babelrc";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "workspace";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.json";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.js";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".Xresources";
        "text" = "";
      }
      {
        "fg" = p.peach;
        "name" = ".gitignore";
        "text" = "";
      }
      {
        "fg" = p.overlay1;
        "name" = ".justfile";
        "text" = "";
      }
    ];
  };
  "indicator" = {
    "current" = {
      "bg" = p.blue;
      "fg" = p.base;
    };
    "parent" = {
      "bg" = p.text;
      "fg" = p.base;
    };
    "preview" = {
      "bg" = p.text;
      "fg" = p.base;
    };
  };
  "input" = {
    "border" = {
      "fg" = p.blue;
    };
    "selected" = {
      "reversed" = true;
    };
    "title" = {};
    "value" = {};
  };
  "mgr" = {
    "border_style" = {
      "fg" = p.overlay1;
    };
    "border_symbol" = "│";
    "count_copied" = {
      "bg" = p.green;
      "fg" = p.base;
    };
    "count_cut" = {
      "bg" = p.red;
      "fg" = p.base;
    };
    "count_selected" = {
      "bg" = p.blue;
      "fg" = p.base;
    };
    "cwd" = {
      "fg" = p.teal;
    };
    "find_keyword" = {
      "fg" = p.yellow;
      "italic" = true;
    };
    "find_position" = {
      "bg" = "reset";
      "fg" = p.pink;
      "italic" = true;
    };
    "marker_copied" = {
      "bg" = p.green;
      "fg" = p.green;
    };
    "marker_cut" = {
      "bg" = p.red;
      "fg" = p.red;
    };
    "marker_marked" = {
      "bg" = p.teal;
      "fg" = p.teal;
    };
    "marker_selected" = {
      "bg" = p.blue;
      "fg" = p.blue;
    };
  };
  "mode" = {
    "normal_alt" = {
      "bg" = p.surface0;
      "fg" = p.blue;
    };
    "normal_main" = {
      "bg" = p.blue;
      "bold" = true;
      "fg" = p.base;
    };
    "select_alt" = {
      "bg" = p.surface0;
      "fg" = p.green;
    };
    "select_main" = {
      "bg" = p.green;
      "bold" = true;
      "fg" = p.base;
    };
    "unset_alt" = {
      "bg" = p.surface0;
      "fg" = p.flamingo;
    };
    "unset_main" = {
      "bg" = p.flamingo;
      "bold" = true;
      "fg" = p.base;
    };
  };
  "notify" = {
    "title_error" = {
      "fg" = p.red;
    };
    "title_info" = {
      "fg" = p.teal;
    };
    "title_warn" = {
      "fg" = p.yellow;
    };
  };
  "pick" = {
    "active" = {
      "fg" = p.pink;
    };
    "border" = {
      "fg" = p.blue;
    };
    "inactive" = {};
  };
  "spot" = {
    "border" = {
      "fg" = p.blue;
    };
    "tbl_cell" = {
      "fg" = p.blue;
      "reversed" = true;
    };
    "tbl_col" = {
      "bold" = true;
    };
    "title" = {
      "fg" = p.blue;
    };
  };
  "status" = {
    "perm_exec" = {
      "fg" = p.green;
    };
    "perm_read" = {
      "fg" = p.yellow;
    };
    "perm_sep" = {
      "fg" = p.overlay1;
    };
    "perm_type" = {
      "fg" = p.blue;
    };
    "perm_write" = {
      "fg" = p.red;
    };
    "progress_error" = {
      "bg" = p.red;
      "fg" = p.yellow;
    };
    "progress_label" = {
      "bold" = true;
      "fg" = p.white;
    };
    "progress_normal" = {
      "bg" = p.surface1;
      "fg" = p.green;
    };
    "sep_left" = {
      "close" = "";
      "open" = "";
    };
    "sep_right" = {
      "close" = "";
      "open" = "";
    };
  };
  "tabs" = {
    "active" = {
      "bg" = p.text;
      "bold" = true;
      "fg" = p.base;
    };
    "inactive" = {
      "bg" = p.surface1;
      "fg" = p.text;
    };
  };
  "tasks" = {
    "border" = {
      "fg" = p.blue;
    };
    "hovered" = {
      "bold" = true;
      "fg" = p.pink;
    };
    "title" = {};
  };
  "which" = {
    "cand" = {
      "fg" = p.teal;
    };
    "desc" = {
      "fg" = p.pink;
    };
    "mask" = {
      "bg" = p.surface0;
    };
    "rest" = {
      "fg" = p.overlay2;
    };
    "separator" = "  ";
    "separator_style" = {
      "fg" = p.surface2;
    };
  };
}
