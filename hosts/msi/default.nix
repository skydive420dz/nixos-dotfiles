{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./maintenance.nix
    ../../system/modules
    ../../system/modules/gpu/nvidia-hybrid.nix
  ];

  programs.nix-ld.enable = true;

  nixpkgs.hostPlatform = {
    system = "x86_64-linux";
    gcc = {
      arch = "x86-64-v3";
      tune = "znver3";
    };
  };

  nixpkgs.overlays = [
    (_final: prev: {
      assimp = prev.assimp.overrideAttrs (old: {
        # x86-64-v3/FMA exposes Assimp's bit-exact float test.
        patches = (old.patches or [ ]) ++ [
          (prev.writeText "assimp-v3-float-test.patch" ''
            --- a/test/unit/AssimpAPITest_aiVector3D.cpp
            +++ b/test/unit/AssimpAPITest_aiVector3D.cpp
            @@ -172,5 +172,7 @@ TEST_F(AssimpAPITest_aiVector3D, aiTransformVecByMatrix3Test) {
                 v_c = v_cpp = random_vec3();
                 v_cpp *= m;
                 aiTransformVecByMatrix3(&v_c, &m);
            -    EXPECT_EQ(v_cpp, v_c);
            +    EXPECT_FLOAT_EQ(v_cpp.x, v_c.x);
            +    EXPECT_FLOAT_EQ(v_cpp.y, v_c.y);
            +    EXPECT_FLOAT_EQ(v_cpp.z, v_c.z);
             }
          '')
        ];
      });

      electron_43 =
        let
          unwrapped = prev.electron_43.unwrapped.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              (prev.writeText "abseil-bmi2-header.patch" ''
                --- a/third_party/abseil-cpp/absl/container/internal/raw_hash_set.h
                +++ b/third_party/abseil-cpp/absl/container/internal/raw_hash_set.h
                @@ -228,3 +228,3 @@
                -#ifdef __BMI2__
                -#include <bmi2intrin.h>
                -#endif  // __BMI2__
                +#if defined(__i386__) || defined(__x86_64__)
                +#include <immintrin.h>
                +#endif
              '')
            ];
          });
        in
        prev.electron_43.override { electron-unwrapped = unwrapped; };

      frei0r = prev.frei0r.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchpatch {
            url = "https://github.com/dyne/frei0r/commit/3713d779b46e04fb88d914a58287d8e717a70559.patch";
            hash = "sha256-Z71ETxwvOrg4cqGTvv5H8ed1jVjr5Vq7f7lVrAheaNY=";
          })
        ];
      });

      openvino = prev.openvino.overrideAttrs (
        old:
        let
          oldEnv = old.env or { };
        in
        {
          # Keep quantization rounding stable under x86-64-v3.
          env = oldEnv // {
            NIX_CFLAGS_COMPILE = "${oldEnv.NIX_CFLAGS_COMPILE or ""} -ffp-contract=off";
          };
        }
      );

      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (_pythonFinal: pythonPrev: {
          afdko = pythonPrev.afdko.overrideAttrs (
            old:
            let
              oldEnv = old.env or { };
            in
            {
              # Keep overlap-removal geometry reproducible under x86-64-v3.
              env = oldEnv // {
                NIX_CFLAGS_COMPILE = "${oldEnv.NIX_CFLAGS_COMPILE or ""} -ffp-contract=off";
              };
            }
          );

          scipy = pythonPrev.scipy.overrideAttrs (
            old:
            let
              oldEnv = old.env or { };
            in
            {
              # Backport SciPy's FMA-sensitive signal-test correction.
              patches = (old.patches or [ ]) ++ [
                (prev.fetchpatch {
                  url = "https://github.com/scipy/scipy/commit/5cd79b026a26e1d0cd0812d394f7dec4606f7900.patch";
                  hash = "sha256-RzMVdLdqcHCrGTPRH6C4qW3eORCyVQNDhGSxwjg55cg=";
                })
              ];

              # The upstream patch makes Nixpkgs' existing suppression unnecessary.
              disabledTests = builtins.filter (test: test != "test_nyquist") (old.disabledTests or [ ]);

              # Retain x86-64-v3 while avoiding solver instability from FMA contraction.
              env = oldEnv // {
                NIX_CFLAGS_COMPILE = "${oldEnv.NIX_CFLAGS_COMPILE or ""} -ffp-contract=off";
              };
            }
          );
        })
      ];
    })
  ];

  hardware.keyboard.qmk.enable = true;

  zramSwap.enable = true;
}
