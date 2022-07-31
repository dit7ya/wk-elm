import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import UnoCSS from "unocss/vite";
import { presetUno } from "@unocss/preset-uno";
import presetIcons from "@unocss/preset-icons";

export default defineConfig({
  // prevent vite from obscuring rust errors
  clearScreen: false,
  // Tauri expects a fixed port, fail if that port is not available
  server: {
    strictPort: true,
  },
  // to make use of `TAURI_PLATFORM`, `TAURI_ARCH`, `TAURI_FAMILY`,
  // `TAURI_PLATFORM_VERSION`, `TAURI_PLATFORM_TYPE` and `TAURI_DEBUG`
  // env variables
  envPrefix: ["VITE_", "TAURI_"],
  build: {
    // Tauri supports es2021
    target: ["es2021", "chrome100", "safari13"],
    // don't minify for debug builds
    minify: !process.env.TAURI_DEBUG ? "esbuild" : false,
    // produce sourcemaps for debug builds
    sourcemap: !!process.env.TAURI_DEBUG,
  },
  plugins: [
    elmPlugin(),
    UnoCSS({
      include: [/\.elm$/],
      shortcuts: [
        {
          logo: "i-logos-elm w-6em h-6em transform transition-800 hover:rotate-360",
        },
      ],
      presets: [presetUno(), presetIcons()],
    }),
  ],
});
