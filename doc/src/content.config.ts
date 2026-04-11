/*
  SPDX-FileCopyrightText: 2024-2025 Akira Komamura

  SPDX-License-Identifier: MIT
*/
import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { docsSchema } from "@astrojs/starlight/schema";

export const collections = {
  docs: defineCollection({
    loader: glob({ pattern: "**/*.{md,mdx,mdoc}", base: "./src/content/docs" }),
    schema: docsSchema(),
  }),
};
