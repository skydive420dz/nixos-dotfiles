{ palette }:

let
  p = palette;
in
{
  "app" = {
    "overall" = {
      "bg" = p.background;
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
        "fg" = p.neutral;
        "mime" = "application/*zip";
      }
      {
        "fg" = p.neutral;
        "mime" = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
      }
      {
        "fg" = p.green;
        "mime" = "application/{pdf,doc,rtf}";
      }
      {
        "fg" = p.surfaceStrong;
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
      "fg" = p.subtle;
    };
    "footer" = {
      "bg" = p.surfaceStrong;
      "fg" = p.foreground;
    };
    "hovered" = {
      "bg" = p.surfaceRaised;
      "bold" = true;
    };
    "on" = {
      "fg" = p.teal;
    };
    "run" = {
      "fg" = p.neutral;
    };
  };
  "icon" = {
    "exts" = [
      {
        "fg" = p.foreground;
        "name" = "otf";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "import";
        "text" = "";
      }
      {
        "fg" = p.neutral;
        "name" = "krz";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "adb";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "ttf";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "webpack";
        "text" = "󰜫";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "dart";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "vsh";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "doc";
        "text" = "󰈬";
      }
      {
        "fg" = p.green;
        "name" = "zsh";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "ex";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "hx";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "fodt";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "mojo";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "templ";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "nix";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "cshtml";
        "text" = "󱦗";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "fish";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "ply";
        "text" = "󰆧";
      }
      {
        "fg" = p.green;
        "name" = "sldprt";
        "text" = "󰻫";
      }
      {
        "fg" = p.surface;
        "name" = "gemspec";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "mjs";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "csh";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "cmake";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.surfaceStrong;
        "name" = "less";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
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
        "fg" = p.baseLow;
        "name" = "dll";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "odf";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "sqlite3";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "Dockerfile";
        "text" = "󰡨";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "ksh";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "rmd";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "wv";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "xml";
        "text" = "󰗀";
      }
      {
        "fg" = p.foreground;
        "name" = "markdown";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "qml";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "3gp";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "pxi";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "flac";
        "text" = "";
      }
      {
        "fg" = p.neutral;
        "name" = "gpr";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "huff";
        "text" = "󰡘";
      }
      {
        "fg" = p.yellow;
        "name" = "json";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "gv";
        "text" = "󱁉";
      }
      {
        "fg" = p.muted;
        "name" = "bmp";
        "text" = "";
      }
      {
        "fg" = p.subtle;
        "name" = "lock";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "sha384";
        "text" = "󰕥";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "cobol";
        "text" = "⚙";
      }
      {
        "fg" = p.surfaceRaised;
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
        "fg" = p.accentDim;
        "name" = "qm";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "ebuild";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.warm;
        "name" = "rar";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "gradle";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "gnumakefile";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "applescript";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "elm";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "ebook";
        "text" = "";
      }
      {
        "fg" = p.neutral;
        "name" = "kra";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "tf";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
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
        "fg" = p.foreground;
        "name" = "kicad_pcb";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "cfg";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "ape";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "org";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "yml";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "swift";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "eln";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "sol";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "awk";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "7z";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "apl";
        "text" = "⍝";
      }
      {
        "fg" = p.warm;
        "name" = "epp";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "app";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "dot";
        "text" = "󱁉";
      }
      {
        "fg" = p.neutral;
        "name" = "kpp";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "eot";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "hpp";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "spec.tsx";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "hurl";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
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
        "fg" = p.muted;
        "name" = "yaml";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.warm;
        "name" = "signature";
        "text" = "λ";
      }
      {
        "fg" = p.muted;
        "name" = "3mf";
        "text" = "󰆧";
      }
      {
        "fg" = p.muted;
        "name" = "jpg";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "xpi";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcmat";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "pot";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "bin";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "xlsx";
        "text" = "󰈛";
      }
      {
        "fg" = p.accentDim;
        "name" = "aac";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "kicad_sym";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "xcstrings";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "lff";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "xcf";
        "text" = "";
      }
      {
        "fg" = p.dim;
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
        "fg" = p.surfaceRaised;
        "name" = "xaml";
        "text" = "󰙳";
      }
      {
        "fg" = p.muted;
        "name" = "md5";
        "text" = "󰕥";
      }
      {
        "fg" = p.accentDim;
        "name" = "xm";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "sln";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "jl";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.accentDim;
        "name" = "wvc";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "wrz";
        "text" = "󰆧";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "csproj";
        "text" = "󰪮";
      }
      {
        "fg" = p.muted;
        "name" = "wrl";
        "text" = "󰆧";
      }
      {
        "fg" = p.accentDim;
        "name" = "wma";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "woff2";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "woff";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "tscn";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "webmanifest";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "webm";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcbak";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "log";
        "text" = "󰌱";
      }
      {
        "fg" = p.accentDim;
        "name" = "wav";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "wasm";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "styl";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "gif";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "resi";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "aiff";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "sha256";
        "text" = "󰕥";
      }
      {
        "fg" = p.green;
        "name" = "igs";
        "text" = "󰻫";
      }
      {
        "fg" = p.dim;
        "name" = "vsix";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "vim";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "diff";
        "text" = "";
      }
      {
        "fg" = p.danger;
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
        "fg" = p.warm;
        "name" = "🔥";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "hrl";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "fsi";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "mm";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.warm;
        "name" = "gz";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "cpp";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "ui";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "txt";
        "text" = "󰈙";
      }
      {
        "fg" = p.accentDim;
        "name" = "spec.ts";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "ccm";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "typoscript";
        "text" = "";
      }
      {
        "fg" = p.accent;
        "name" = "typ";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "txz";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "test.ts";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "tsx";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "mk";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "webp";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "opus";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "bicep";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "ts";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "tres";
        "text" = "";
      }
      {
        "fg" = p.teal;
        "name" = "torrent";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "cxx";
        "text" = "";
      }
      {
        "fg" = p.danger;
        "name" = "iso";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "ixx";
        "text" = "";
      }
      {
        "fg" = p.muted;
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
        "fg" = p.muted;
        "name" = "ini";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "m3u8";
        "text" = "󰲹";
      }
      {
        "fg" = p.danger;
        "name" = "image";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "tfvars";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "tex";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "cbl";
        "text" = "⚙";
      }
      {
        "fg" = p.foreground;
        "name" = "flc";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "elc";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "test.tsx";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "twig";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "sql";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "test.jsx";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "htm";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "gcode";
        "text" = "󰐫";
      }
      {
        "fg" = p.yellow;
        "name" = "test.js";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "ino";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "tcl";
        "text" = "󰛓";
      }
      {
        "fg" = p.accentDim;
        "name" = "cljs";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "tsconfig";
        "text" = "";
      }
      {
        "fg" = p.danger;
        "name" = "img";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "t";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcstd1";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "out";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "jsx";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "bash";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "edn";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "rss";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "flf";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "cache";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "sbt";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "cppm";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "svelte";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "mo";
        "text" = "∞";
      }
      {
        "fg" = p.green;
        "name" = "sv";
        "text" = "󰍛";
      }
      {
        "fg" = p.foreground;
        "name" = "ko";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "suo";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "sldasm";
        "text" = "󰻫";
      }
      {
        "fg" = p.surface;
        "name" = "icalendar";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "go";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "sublime";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "stl";
        "text" = "󰆧";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.surfaceRaised;
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
        "fg" = p.accentDim;
        "name" = "po";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "scala";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "exs";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "odp";
        "text" = "";
      }
      {
        "fg" = p.foreground;
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
        "fg" = p.accentDim;
        "name" = "aif";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "strings";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "cp";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "fsscript";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "mli";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "bak";
        "text" = "󰁯";
      }
      {
        "fg" = p.yellow;
        "name" = "ssa";
        "text" = "󰨖";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "toml";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "makefile";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "php";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "zst";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "spec.jsx";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "kbx";
        "text" = "󰯄";
      }
      {
        "fg" = p.muted;
        "name" = "fbx";
        "text" = "󰆧";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.foreground;
        "name" = "so";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "desktop";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "sml";
        "text" = "λ";
      }
      {
        "fg" = p.green;
        "name" = "slvs";
        "text" = "󰻫";
      }
      {
        "fg" = p.warm;
        "name" = "pp";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "ps1";
        "text" = "󰨊";
      }
      {
        "fg" = p.dim;
        "name" = "dropbox";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "kicad_mod";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "bat";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.warm;
        "name" = "xul";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "ige";
        "text" = "󰻫";
      }
      {
        "fg" = p.warm;
        "name" = "glb";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "ppt";
        "text" = "󰈧";
      }
      {
        "fg" = p.muted;
        "name" = "sha512";
        "text" = "󰕥";
      }
      {
        "fg" = p.surface;
        "name" = "ics";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "mdx";
        "text" = "";
      }
      {
        "fg" = p.muted;
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
        "fg" = p.muted;
        "name" = "godot";
        "text" = "";
      }
      {
        "fg" = p.surface;
        "name" = "ifb";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "cson";
        "text" = "";
      }
      {
        "fg" = p.baseLow;
        "name" = "lib";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "luac";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "heex";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "scm";
        "text" = "󰘧";
      }
      {
        "fg" = p.muted;
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
        "fg" = p.dim;
        "name" = "kts";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "svh";
        "text" = "󰍛";
      }
      {
        "fg" = p.accentDim;
        "name" = "mts";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "nfo";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "pck";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "rproj";
        "text" = "󰗆";
      }
      {
        "fg" = p.warm;
        "name" = "rlib";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
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
        "fg" = p.foreground;
        "name" = "haml";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "d.ts";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "razor";
        "text" = "󱦘";
      }
      {
        "fg" = p.surface;
        "name" = "rake";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "patch";
        "text" = "";
      }
      {
        "fg" = p.muted;
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
        "fg" = p.accentDim;
        "name" = "psb";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "nu";
        "text" = ">";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.muted;
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
        "fg" = p.surfaceStrong;
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
        "fg" = p.warm;
        "name" = "git";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
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
        "fg" = p.muted;
        "name" = "psm1";
        "text" = "󰨊";
      }
      {
        "fg" = p.foreground;
        "name" = "dconf";
        "text" = "";
      }
      {
        "fg" = p.surface;
        "name" = "config.ru";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "prisma";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "conf";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "clj";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "o";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "mp4";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "cc";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "kicad_prl";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "bz3";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "asc";
        "text" = "󰦝";
      }
      {
        "fg" = p.muted;
        "name" = "png";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "android";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "pm";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "h";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "pls";
        "text" = "󰲹";
      }
      {
        "fg" = p.warm;
        "name" = "ipynb";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "pl";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "ads";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "sqlite";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "pdf";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "pcm";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "ico";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "a";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "R";
        "text" = "󰟔";
      }
      {
        "fg" = p.dim;
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
        "fg" = p.muted;
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
        "fg" = p.dim;
        "name" = "bqn";
        "text" = "⎉";
      }
      {
        "fg" = p.accentDim;
        "name" = "cts";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcparam";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "rs";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
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
        "fg" = p.muted;
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
        "fg" = p.muted;
        "name" = "eex";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "tbc";
        "text" = "󰛓";
      }
      {
        "fg" = p.red;
        "name" = "astro";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "sha224";
        "text" = "󰕥";
      }
      {
        "fg" = p.warm;
        "name" = "xcplayground";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "el";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "m4v";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "m4a";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "cs";
        "text" = "󰌛";
      }
      {
        "fg" = p.muted;
        "name" = "hs";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "tgz";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
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
        "fg" = p.warm;
        "name" = "cast";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "qrc";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "lua";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "lhs";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "md";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "leex";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "ai";
        "text" = "";
      }
      {
        "fg" = p.subtle;
        "name" = "lck";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "kt";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "bicepparam";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "hex";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.foreground;
        "name" = "kicad_dru";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fctl";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "f#";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "odt";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "conda";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "vala";
        "text" = "";
      }
      {
        "fg" = p.surface;
        "name" = "erb";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "mp3";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "bz2";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "coffee";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "cr";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "f90";
        "text" = "󱈚";
      }
      {
        "fg" = p.dim;
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
        "fg" = p.muted;
        "name" = "hh";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "sig";
        "text" = "λ";
      }
      {
        "fg" = p.warm;
        "name" = "html";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "iges";
        "text" = "󰻫";
      }
      {
        "fg" = p.foreground;
        "name" = "kicad_wks";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "hbs";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "fcstd";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "gresource";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "sub";
        "text" = "󰨖";
      }
      {
        "fg" = p.surface;
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
        "fg" = p.muted;
        "name" = "gd";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "fsx";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "mkv";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "py";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "kicad_sch";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "epub";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "env";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "magnet";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
        "name" = "elf";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "fodg";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "svg";
        "text" = "󰜡";
      }
      {
        "fg" = p.green;
        "name" = "dwg";
        "text" = "󰻫";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "docx";
        "text" = "󰈬";
      }
      {
        "fg" = p.yellow;
        "name" = "pro";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "db";
        "text" = "";
      }
      {
        "fg" = p.surface;
        "name" = "rb";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "r";
        "text" = "󰟔";
      }
      {
        "fg" = p.red;
        "name" = "scss";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "cow";
        "text" = "󰆚";
      }
      {
        "fg" = p.neutral;
        "name" = "gleam";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "v";
        "text" = "󰍛";
      }
      {
        "fg" = p.foreground;
        "name" = "kicad_pro";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "liquid";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "zip";
        "text" = "";
      }
    ];
    "files" = [
      {
        "fg" = p.neutral;
        "name" = "kritadisplayrc";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = ".gtkrc-2.0";
        "text" = "";
      }
      {
        "fg" = p.surface;
        "name" = "bspwmrc";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "webpack";
        "text" = "󰜫";
      }
      {
        "fg" = p.accentDim;
        "name" = "tsconfig.json";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".vimrc";
        "text" = "";
      }
      {
        "fg" = p.surface;
        "name" = "gemfile$";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "xmobarrc";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "avif";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "fp-info-cache";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".zshrc";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "robots.txt";
        "text" = "󰚩";
      }
      {
        "fg" = p.blue;
        "name" = "dockerfile";
        "text" = "󰡨";
      }
      {
        "fg" = p.warm;
        "name" = ".git-blame-ignore-revs";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".nvmrc";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "hyprpaper.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierignore";
        "text" = "";
      }
      {
        "fg" = p.surface;
        "name" = "rakefile";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "code_of_conduct";
        "text" = "";
      }
      {
        "fg" = p.foreground;
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
        "fg" = p.foreground;
        "name" = "readme";
        "text" = "󰂺";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "settings.gradle";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "gruntfile.coffee";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
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
        "fg" = p.accentDim;
        "name" = "rmd";
        "text" = "";
      }
      {
        "fg" = p.dim;
        "name" = "vagrantfile$";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.warm;
        "name" = "build.zig.zon";
        "text" = "";
      }
      {
        "fg" = p.surfaceStrong;
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
        "fg" = p.warm;
        "name" = ".mailmap";
        "text" = "󰊢";
      }
      {
        "fg" = p.green;
        "name" = ".codespellrc";
        "text" = "󰓆";
      }
      {
        "fg" = p.warm;
        "name" = "svelte.config.js";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "eslint.config.ts";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "config";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = ".gitlab-ci.yml";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = ".gitconfig";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "_gvimrc";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = ".xinitrc";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "checkhealth";
        "text" = "󰓙";
      }
      {
        "fg" = p.surface;
        "name" = "sxhkdrc";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".bashrc";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "tailwind.config.mjs";
        "text" = "󱏿";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.surface;
        "name" = ".nanorc";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "commit_editmsg";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".luaurc";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "fp-lib-table";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = ".editorconfig";
        "text" = "";
      }
      {
        "fg" = p.muted;
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
        "fg" = p.muted;
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
        "fg" = p.accentDim;
        "name" = "go.mod";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "lxqt.conf";
        "text" = "";
      }
      {
        "fg" = p.surface;
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
        "fg" = p.dim;
        "name" = ".settings.json";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "tailwind.config.js";
        "text" = "󱏿";
      }
      {
        "fg" = p.muted;
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
        "fg" = p.warm;
        "name" = "xsettingsd.conf";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "nuxt.config.js";
        "text" = "󱄆";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "eslint.config.cjs";
        "text" = "";
      }
      {
        "fg" = p.foreground;
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
        "fg" = p.warm;
        "name" = ".pre-commit-config.yaml";
        "text" = "󰛢";
      }
      {
        "fg" = p.foreground;
        "name" = "i3blocks.conf";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "xorg.conf";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = ".zshenv";
        "text" = "";
      }
      {
        "fg" = p.warm;
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
        "fg" = p.accentDim;
        "name" = "tailwind.config.ts";
        "text" = "󱏿";
      }
      {
        "fg" = p.subtle;
        "name" = "security.md";
        "text" = "󰒃";
      }
      {
        "fg" = p.subtle;
        "name" = "security";
        "text" = "󰒃";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = ".eslintrc";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "gradle.properties";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "code_of_conduct.md";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "PrusaSlicerGcodeViewer.ini";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "PrusaSlicer.ini";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "procfile";
        "text" = "";
      }
      {
        "fg" = p.background;
        "name" = "mpv.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = ".prettierrc.json5";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "i3status.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "prettier.config.mjs";
        "text" = "";
      }
      {
        "fg" = p.muted;
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
        "fg" = p.surfaceRaised;
        "name" = "eslint.config.mjs";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "gruntfile.js";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "bun.lockb";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = ".gitattributes";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "gruntfile.ts";
        "text" = "";
      }
      {
        "fg" = p.surface;
        "name" = "pom.xml";
        "text" = "";
      }
      {
        "fg" = p.yellow;
        "name" = "favicon.ico";
        "text" = "";
      }
      {
        "fg" = p.surface;
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
        "fg" = p.muted;
        "name" = "mix.lock";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = "makefile";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "gulpfile.js";
        "text" = "";
      }
      {
        "fg" = p.subtle;
        "name" = "lxde-rc.xml";
        "text" = "";
      }
      {
        "fg" = p.neutral;
        "name" = "kritarc";
        "text" = "";
      }
      {
        "fg" = p.foreground;
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
        "fg" = p.muted;
        "name" = "i18n.config.ts";
        "text" = "󰗊";
      }
      {
        "fg" = p.teal;
        "name" = "commitlint.config.js";
        "text" = "󰜘";
      }
      {
        "fg" = p.warm;
        "name" = ".gitmodules";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "gradle-wrapper.properties";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "hypridle.conf";
        "text" = "";
      }
      {
        "fg" = p.foreground;
        "name" = "vercel.json";
        "text" = "▲";
      }
      {
        "fg" = p.accentDim;
        "name" = "hyprlock.conf";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "go.sum";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "kdenlive-layoutsrc";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "gruntfile.babel.js";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "compose.yml";
        "text" = "󰡨";
      }
      {
        "fg" = p.muted;
        "name" = "i18n.config.js";
        "text" = "󰗊";
      }
      {
        "fg" = p.foreground;
        "name" = "readme.md";
        "text" = "󰂺";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "gradlew";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "go.work";
        "text" = "";
      }
      {
        "fg" = p.red;
        "name" = "gulpfile.ts";
        "text" = "";
      }
      {
        "fg" = p.muted;
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
        "fg" = p.surfaceRaised;
        "name" = "eslint.config.js";
        "text" = "";
      }
      {
        "fg" = p.accentDim;
        "name" = "hyprland.conf";
        "text" = "";
      }
      {
        "fg" = p.blue;
        "name" = "docker-compose.yml";
        "text" = "󰡨";
      }
      {
        "fg" = p.surfaceRaised;
        "name" = "groovy";
        "text" = "";
      }
      {
        "fg" = p.green;
        "name" = "QtProject.conf";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = "platformio.ini";
        "text" = "";
      }
      {
        "fg" = p.surfaceRaised;
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
        "fg" = p.warm;
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
        "fg" = p.warm;
        "name" = ".Xresources";
        "text" = "";
      }
      {
        "fg" = p.warm;
        "name" = ".gitignore";
        "text" = "";
      }
      {
        "fg" = p.muted;
        "name" = ".justfile";
        "text" = "";
      }
    ];
  };
  "indicator" = {
    "current" = {
      "bg" = p.blue;
      "fg" = p.background;
    };
    "parent" = {
      "bg" = p.foreground;
      "fg" = p.background;
    };
    "preview" = {
      "bg" = p.foreground;
      "fg" = p.background;
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
      "fg" = p.muted;
    };
    "border_symbol" = "│";
    "count_copied" = {
      "bg" = p.green;
      "fg" = p.background;
    };
    "count_cut" = {
      "bg" = p.red;
      "fg" = p.background;
    };
    "count_selected" = {
      "bg" = p.blue;
      "fg" = p.background;
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
      "fg" = p.neutral;
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
      "bg" = p.surface;
      "fg" = p.blue;
    };
    "normal_main" = {
      "bg" = p.blue;
      "bold" = true;
      "fg" = p.background;
    };
    "select_alt" = {
      "bg" = p.surface;
      "fg" = p.green;
    };
    "select_main" = {
      "bg" = p.green;
      "bold" = true;
      "fg" = p.background;
    };
    "unset_alt" = {
      "bg" = p.surface;
      "fg" = p.danger;
    };
    "unset_main" = {
      "bg" = p.danger;
      "bold" = true;
      "fg" = p.background;
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
      "fg" = p.neutral;
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
      "fg" = p.muted;
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
      "fg" = p.foreground;
    };
    "progress_normal" = {
      "bg" = p.surfaceStrong;
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
      "bg" = p.foreground;
      "bold" = true;
      "fg" = p.background;
    };
    "inactive" = {
      "bg" = p.surfaceStrong;
      "fg" = p.foreground;
    };
  };
  "tasks" = {
    "border" = {
      "fg" = p.blue;
    };
    "hovered" = {
      "bold" = true;
      "fg" = p.neutral;
    };
    "title" = {};
  };
  "which" = {
    "cand" = {
      "fg" = p.teal;
    };
    "desc" = {
      "fg" = p.neutral;
    };
    "mask" = {
      "bg" = p.surface;
    };
    "rest" = {
      "fg" = p.subtle;
    };
    "separator" = "  ";
    "separator_style" = {
      "fg" = p.surfaceRaised;
    };
  };
}
