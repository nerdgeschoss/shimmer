import esbuild from "rollup-plugin-esbuild";
import cleaner from "rollup-plugin-cleaner";
import pkg from "./package.json";
import postcss from "rollup-plugin-postcss";
import postcssPresetEnv from "postcss-preset-env";

export default {
  input: ["./src/index.ts", "./components/index.ts"],
  external: [
    "@rails/request.js",
    "@hotwired/stimulus",
    "@popperjs/core",
    "react",
    "react-dom",
    "classnames",
  ],
  plugins: [
    cleaner({
      targets: ["./dist/"],
    }),
    esbuild({
      target: "es6",
    }),
    [
      "@babel/plugin-transform-runtime",
      {
        regenerator: true,
      },
    ],
    /*
    works for default values (no @custom-media tag on preserve: false)
    preserve: true renders both @media (min-width: 640px) and @media (min-width: --custom-media)
    */
    postcss({
      extract: "styles.css",
      plugins: [postcssPresetEnv({ preserve: true })],
      // minimize: true,
    }),
  ],
  output: {
    dir: "dist",
    plugins: [
      {
        file: pkg.main,
        format: "cjs",
      },
      {
        file: pkg.module,
        format: "es",
      },
    ],
  },
};
