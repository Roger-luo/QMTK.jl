"""
Some operations (like some samplers) only accepts randomized sample space

Throw this error, when the arugment does not meet this condition.
"""
struct UnRandomizedError <: Exception
    msg::String
end

UnRandomizedError() = UnRandomizedError("")
