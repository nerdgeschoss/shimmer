import esbuild from "rollup-plugin-esbuild";
import cleaner from "rollup-plugin-cleaner";
import pkg from "./package.json";
import scss from "rollup-plugin-scss";

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
    scss({ fileName: "styles.css" }),
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
