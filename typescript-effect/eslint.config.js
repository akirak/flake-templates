/**
 * An ESLint configuration file for Effect-TS projects.
 *
 * SPDX-License-Identifier: Unlicense
 */

import antfu from "@antfu/eslint-config"

// TanStack Router/Start
// import pluginRouter from "@tanstack/eslint-plugin-router"

export default antfu({
  // react: true,

  formatters: true,

  // stylistic: {
  //   quotes: "double",
  //   semi: false,
  // },

  ignores: [
    // TanStack Router
    // "**/*.gen.ts",
  ],

  // Override rules for Effect-TS
  rules: {
    "array-callback-return": "off",
    // Effect uses many of them
    "no-lone-blocks": "off",
    "no-empty": "off",
    // Don't insert `new` into `extends Data.TaggedError` declarations.
    "unicorn/throw-new-error": "off",
  },
},
  // TanStack Router
  // pluginRouter.configs["flat/recommended"],

  // Override the default rules for specific files

  // {
  //   files: [
  //     "tests/**/*.ts",
  //   ],
  //   rules: {
  //     "no-console": "off",
  //   },
  // },
)
