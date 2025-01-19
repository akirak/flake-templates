/*
  SPDX-FileCopyrightText: 2024-2025 Akira Komamura

  SPDX-License-Identifier: MIT
*/
import { defineCollection } from "astro:content";
import { docsSchema } from "@astrojs/starlight/schema";

export const collections = {
  docs: defineCollection({ schema: docsSchema() }),
};
