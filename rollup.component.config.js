import esbuild from "rollup-plugin-esbuild";
import pkg from "./package.json";
import postcss from "rollup-plugin-postcss";
import postcssPresetEnv from "postcss-preset-env";

export default {
  input: "./src/components/stack.tsx",
  external: ["react", "react-dom", "classnames"],
  plugins: [
    esbuild({
      target: "es6",
    }),
    [
      "@babel/plugin-transform-runtime",
      {
        regenerator: true,
      },
    ],
    postcss({
      extract: true,
      plugins: [postcssPresetEnv({ preserve: true })],
    }),
  ],
  output: {
    dir: "dist/components",
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
