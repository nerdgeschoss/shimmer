import esbuild from "rollup-plugin-esbuild";
import cleaner from "rollup-plugin-cleaner";
import pkg from "./package.json";

export default {
  input: "./src/index.ts",
  external: ["@rails/request.js", "@hotwired/stimulus", "@popperjs/core"],
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
