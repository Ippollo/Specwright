/// <reference types="jest" />
/* eslint-disable @typescript-eslint/no-unused-vars */
/**
 * Jest/Vitest Test Template
 * =========================
 * A starter template demonstrating best practices for TypeScript unit tests.
 * Copy and adapt for your project.
 *
 * Prerequisites:
 *   npm i --save-dev jest @types/jest ts-jest
 *   # or for Vitest:
 *   npm i --save-dev vitest
 *
 * Usage:
 *   jest path/to/this_file.test.ts
 *   vitest path/to/this_file.test.ts
 */

// =============================================================================
// MOCKING SETUP
// =============================================================================

// Mock external modules at the top of the file
// jest.mock("./your-module");
// import { yourFunction } from "./your-module";
// const mockYourFunction = yourFunction as jest.MockedFunction<typeof yourFunction>;

// =============================================================================
// TEST SUITE
// =============================================================================

describe("YourModule", () => {
  // -------------------------------------------------------------------------
  // SETUP & TEARDOWN
  // -------------------------------------------------------------------------

  let testData: { id: number; name: string };

  beforeAll(() => {
    // Runs once before all tests in this describe block
    // Use for expensive setup like DB connections
  });

  afterAll(() => {
    // Runs once after all tests in this describe block
    // Use for cleanup of beforeAll setup
  });

  beforeEach(() => {
    // Runs before each test
    testData = { id: 1, name: "Test Item" };
    jest.clearAllMocks(); // Reset mock call counts
  });

  afterEach(() => {
    // Runs after each test
    // Use for cleanup of beforeEach setup
  });

  // -------------------------------------------------------------------------
  // BASIC TESTS (AAA Pattern)
  // -------------------------------------------------------------------------

  describe("yourFunction", () => {
    it("should return expected result", () => {
      // Arrange
      const input = testData.name;

      // Act
      const result = input.toUpperCase();

      // Assert
      expect(result).toBe("TEST ITEM");
    });

    it("should handle empty input", () => {
      // Arrange
      const input = "";

      // Act
      const result = input.toUpperCase();

      // Assert
      expect(result).toBe("");
    });
  });

  // -------------------------------------------------------------------------
  // PARAMETRIZED TESTS
  // -------------------------------------------------------------------------

  describe("string length", () => {
    it.each([
      ["hello", 5],
      ["world", 5],
      ["", 0],
      ["jest", 4],
    ])('"%s" should have length %i', (input, expected) => {
      expect(input.length).toBe(expected);
    });
  });

  describe("addition", () => {
    it.each([
      { a: 1, b: 2, expected: 3 },
      { a: 0, b: 0, expected: 0 },
      { a: -1, b: 1, expected: 0 },
      { a: 100, b: 200, expected: 300 },
    ])("$a + $b should equal $expected", ({ a, b, expected }) => {
      expect(a + b).toBe(expected);
    });
  });

  // -------------------------------------------------------------------------
  // ASYNC TESTS
  // -------------------------------------------------------------------------

  describe("async operations", () => {
    it("should resolve with expected value", async () => {
      // Arrange
      const asyncFn = async () => Promise.resolve("success");

      // Act
      const result = await asyncFn();

      // Assert
      expect(result).toBe("success");
    });

    it("should reject with error", async () => {
      // Arrange
      const asyncFn = async () => Promise.reject(new Error("Failed"));

      // Act & Assert
      await expect(asyncFn()).rejects.toThrow("Failed");
    });
  });

  // -------------------------------------------------------------------------
  // EXCEPTION TESTING
  // -------------------------------------------------------------------------

  describe("error handling", () => {
    it("should throw on invalid input", () => {
      const throwingFn = () => {
        throw new Error("Invalid input");
      };

      expect(throwingFn).toThrow("Invalid input");
      expect(throwingFn).toThrow(Error);
    });
  });

  // -------------------------------------------------------------------------
  // MOCKING EXAMPLES
  // -------------------------------------------------------------------------

  describe("with mocked dependencies", () => {
    it("should call mocked function", () => {
      // Arrange
      const mockCallback = jest.fn().mockReturnValue(42);

      // Act
      const result = mockCallback("test");

      // Assert
      expect(mockCallback).toHaveBeenCalledWith("test");
      expect(mockCallback).toHaveBeenCalledTimes(1);
      expect(result).toBe(42);
    });

    it("should mock async function", async () => {
      // Arrange
      const mockAsyncFn = jest.fn().mockResolvedValue({ data: "test" });

      // Act
      const result = await mockAsyncFn();

      // Assert
      expect(result).toEqual({ data: "test" });
    });
  });

  // -------------------------------------------------------------------------
  // MATCHERS REFERENCE
  // -------------------------------------------------------------------------

  describe("common matchers", () => {
    it("demonstrates various matchers", () => {
      // Equality
      expect(1 + 1).toBe(2);
      expect({ a: 1 }).toEqual({ a: 1 });

      // Truthiness
      expect(true).toBeTruthy();
      expect(null).toBeNull();
      expect(undefined).toBeUndefined();

      // Numbers
      expect(10).toBeGreaterThan(5);
      expect(0.1 + 0.2).toBeCloseTo(0.3);

      // Strings
      expect("hello world").toContain("world");
      expect("hello").toMatch(/^hel/);

      // Arrays
      expect([1, 2, 3]).toContain(2);
      expect([1, 2, 3]).toHaveLength(3);

      // Objects
      expect({ a: 1, b: 2 }).toHaveProperty("a");
      expect({ a: 1 }).toMatchObject({ a: expect.any(Number) });
    });
  });
});
