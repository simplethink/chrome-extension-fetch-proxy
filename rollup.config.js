import { defineConfig } from 'rollup';
import { babel } from '@rollup/plugin-babel';
import { nodeResolve } from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import terser from '@rollup/plugin-terser';
import typescript from 'rollup-plugin-typescript2';

const input = 'src/index.js';

export default defineConfig([
  // UMD build
  {
    input,
    output: {
      file: 'dist/chrome-extension-fetch-proxy.umd.js',
      format: 'umd',
      name: 'ChromeExtensionFetchProxy'
    },
    plugins: [
      nodeResolve(),
      commonjs(),
      babel({
        babelHelpers: 'bundled',
        presets: [['@babel/preset-env', { targets: { ie: '11' } }]]
      }),
      terser()
    ]
  },
  
  // CommonJS build
  {
    input,
    output: {
      file: 'dist/chrome-extension-fetch-proxy.js',
      format: 'cjs'
    },
    plugins: [
      nodeResolve(),
      commonjs(),
      babel({
        babelHelpers: 'bundled'
      })
    ]
  },
  
  // ES Module build
  {
    input,
    output: {
      file: 'dist/chrome-extension-fetch-proxy.esm.js',
      format: 'es'
    },
    plugins: [
      nodeResolve(),
      commonjs(),
      babel({
        babelHelpers: 'bundled'
      })
    ]
  },
  
  // TypeScript declarations
  {
    input,
    output: {
      dir: 'dist/types',
      format: 'es'
    },
    plugins: [
      typescript({
        useTsconfigDeclarationDir: true,
        tsconfigOverride: {
          compilerOptions: {
            declaration: true,
            emitDeclarationOnly: true,
            outDir: 'dist/types'
          }
        }
      })
    ]
  }
]);