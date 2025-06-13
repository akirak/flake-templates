// SPDX-License-Identifier: Unlicense
import { Options } from "@effect/cli"
import * as process from "node:process"
import * as Command from "@effect/cli/Command"
import { Console, Effect } from "effect"
import { NodeFileSystem, NodePath, NodeRuntime, NodeTerminal } from "@effect/platform-node"

const name = Options.text("name").pipe(
  Options.withAlias("n"),
)

const hello = Command.make("hello", { name }, ({ name }) =>
  Console.log(`Hello, ${name}!`),
)

const command = Command.make("my-app").pipe(Command.withSubcommands([
  hello,
]))

const cli = Command.run(command, {
  name: "my-app",
  version: "v0.0.0",
})

Effect.suspend(() => cli(process.argv)).pipe(
  Effect.provide(NodePath.layer),
  Effect.provide(NodeFileSystem.layer),
  Effect.provide(NodeTerminal.layer),
  Effect.scoped,
  NodeRuntime.runMain({ disableErrorReporting: true }),
)
