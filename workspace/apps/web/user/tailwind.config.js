const { createGlobPatternsForDependencies } = require('@nx/react/tailwind');
const { join } = require('path');
import { nextui } from "@nextui-org/react";

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    join(
      __dirname,
      '{src,pages,components,app}/**/*!(*.stories|*.spec).{ts,tsx,html}'
    ),
    ...createGlobPatternsForDependencies(__dirname),
    "../../../node_modules/@nextui-org/theme/dist/**/*.{js,ts,jsx,tsx}"
  ],
  theme: {
    extend: {},
  },
  darkMode: "class",
  plugins: [nextui({
    themes: {
      modern: {
        extend: 'dark',
        colors: {
          background: '#0D001A',
          foreground: '#ffffff',
          primary: {
            50: '#5F3DC4',
            100: '#7552D3',
            200: '#8F71E6',
            300: '#AB90F9',
            400: '#C4A7FA',
            500: '#D9BEFA',
            600: '#EDD5FB',
            700: '#F4E4FC',
            800: '#F9F2FD',
            900: '#FDF9FE',
            DEFAULT: '#7552D3',
            foreground: '#ffffff'
          },
          focus: '#AB90F9'
        },
        layout: {
          // disabledOpacity: '0.1',
          // radius: {
          //   small: '1px',
          //   medium: '2px',
          //   large: '4px'
          // },
          // borderWidth: {
          //   small: '1px',
          //   medium: '2px',
          //   large: '3px'
          // }
        }
      }
    }
  })]
};