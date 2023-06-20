import esbuild from "rollup-plugin-esbuild";
import cleaner from "rollup-plugin-cleaner";
import pkg from "./package.json";
// import scss from "rollup-plugin-scss";
// import multi from "@rollup/plugin-multi-entry";
import postcss from "rollup-plugin-postcss";

// @TODO: getting error "You may need an additional loader to handle the result of these loaders", fix scss/css

export default {
  input: ["./src/index.ts", "./components/index.ts"],
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
    postcss({ extract: true }),
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
