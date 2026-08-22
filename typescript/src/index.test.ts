import { describe, expect, it } from "vitest";
import { greet } from "./index.js";

describe("greet", () => {
  it("greets the given name", () => {
    expect(greet("template")).toBe("Hello, template!");
  });
});
