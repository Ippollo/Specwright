import { z } from "zod";

// --- Domain Schema ---
export const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string().min(2),
  role: z.enum(["admin", "user"]),
  createdAt: z.date(),
});

// --- API Request Schemas ---

// POST /users
export const CreateUserSchema = z.object({
  body: z.object({
    email: z.string().email(),
    name: z.string().min(2),
    password: z.string().min(8), // PWD logic handled by service
  }),
});

// GET /users (Query params)
export const ListUsersSchema = z.object({
  query: z.object({
    page: z.coerce.number().min(1).default(1),
    limit: z.coerce.number().min(1).max(100).default(20),
    sort: z.string().optional(),
    role: z.enum(["admin", "user"]).optional(),
  }),
});

// --- Type Inference ---
export type User = z.infer<typeof UserSchema>;
export type CreateUserInput = z.infer<typeof CreateUserSchema>["body"];

// --- Validation Helper ---
export function validate(schema: z.AnyZodObject, data: unknown) {
  const result = schema.safeParse(data);
  if (!result.success) {
    // Format for standard API error envelope
    throw new Error(
      JSON.stringify({
        code: "VALIDATION_ERROR",
        message: "Invalid input",
        details: result.error.errors.map((err) => ({
          field: err.path.join("."),
          message: err.message,
        })),
      }),
    );
  }
  return result.data;
}
