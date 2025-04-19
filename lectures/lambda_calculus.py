# === Combined Script for Lambda Calculus Concepts in Python ===
# Author: Gemini Assistant
# Date: 2025-04-14
# Demonstrates: Church Booleans, IF, Logical AND, Church Numerals,
#               Functional Arithmetic (Pred, Sub), Comparisons (LEQ, EQ),
#               and IF statements based on number comparisons, all using
#               Python's lambda functions to mimic Lambda Calculus.

print("=" * 60)
print("=== Lambda Calculus Concepts in Python Demonstration ===")
print("=" * 60)

# --- Part 1: Functional Booleans (Church Encoding) ---
print("\n--- 1. Defining Functional Booleans ---")
py_TRUE = lambda x: lambda y: x
py_FALSE = lambda x: lambda y: y
print("py_TRUE = lambda x: lambda y: x  (Selects first argument)")
print("py_FALSE = lambda x: lambda y: y (Selects second argument)")

# --- Part 2: Functional Conditional (IF) ---
print("\n--- 2. Defining Functional IF ---")
# IF = λcond. λthen. λelse. cond then else
py_IF = lambda cond: lambda then_branch: lambda else_branch: cond(then_branch)(else_branch)
print("py_IF = lambda cond: lambda t: lambda e: cond(t)(e)")
print("  (Applies the boolean 'cond' to select 't' or 'e')")

# --- Part 3: Functional Logical Operators (e.g., AND) ---
print("\n--- 3. Defining Functional AND ---")
# AND = λa. λb. a b FALSE  (Equivalent to: IF a THEN b ELSE FALSE)
# Requires py_FALSE defined above.
py_AND = lambda a: lambda b: a(b)(py_FALSE)
print("py_AND = lambda a: lambda b: a(b)(py_FALSE)")

# --- Part 4: Functional Numbers (Church Numerals) ---
print("\n--- 4. Defining Church Numerals ---")
# n = λf. λx. f applied n times to x
py_ZERO = lambda f: lambda x: x
py_ONE = lambda f: lambda x: f(x)
py_TWO = lambda f: lambda x: f(f(x))
py_THREE = lambda f: lambda x: f(f(f(x)))
# ... add more numerals if needed
print("py_ZERO, py_ONE, py_TWO, py_THREE defined.")
print("  (e.g., py_TWO takes f and x, returns f(f(x)))")

# --- Part 5: Functional Arithmetic and Comparison ---
print("\n--- 5. Defining Functional Arithmetic/Comparison Logic ---")

# IS_ZERO = λn. n (λx. FALSE) TRUE
# If n=ZERO, applies (λx. FALSE) zero times to TRUE -> TRUE
# If n>ZERO, applies (λx. FALSE) >=1 times -> FALSE
py_IS_ZERO = lambda n: n(lambda x: py_FALSE)(py_TRUE) # Needs py_TRUE, py_FALSE
print("py_IS_ZERO defined.")

# PRED = λn. λf. λx. n (λg. λh. h (g f)) (λu. x) (λu. u)
# Calculates the predecessor (n-1). Definition is complex but standard.
py_PRED = lambda n: lambda f: lambda x: n(lambda g: lambda h: h(g(f)))(lambda u: x)(lambda u: u)
print("py_PRED defined.")

# SUB = λm. λn. n PRED m
# Subtracts n from m by applying PRED n times to m.
py_SUB = lambda m: lambda n: n(py_PRED)(m) # Needs py_PRED
print("py_SUB defined.")

# LEQ = λm. λn. IS_ZERO (SUB m n)
# Checks if m <= n by checking if (m - n) is ZERO.
# Note: Church numeral subtraction results in ZERO if m <= n.
py_LEQ = lambda m: lambda n: py_IS_ZERO(py_SUB(m)(n)) # Needs py_IS_ZERO, py_SUB
print("py_LEQ defined (Less Than or Equal To).")

# EQ = λm. λn. AND (LEQ m n) (LEQ n m)
# Checks if m == n by checking if (m <= n) AND (n <= m).
py_EQ = lambda m: lambda n: py_AND(py_LEQ(m)(n))(py_LEQ(n)(m)) # Needs py_AND, py_LEQ
print("py_EQ defined (Equals).")

# --- Part 6: Helper Functions for Display ---
print("\n--- 6. Defining Helper Functions ---")
def to_py_bool(functional_bool):
    """Converts functional boolean (py_TRUE/py_FALSE) to Python True/False."""
    try:
        # Apply the function to Python's True and False. It will select one.
        return functional_bool(True)(False)
    except Exception as e:
        # Handle cases where input is not a valid boolean function
        # print(f"Debug: Error in to_py_bool - {e}") # Optional debug
        return "Invalid Boolean Func"

def to_py_int(church_numeral):
    """Converts Church numeral function to Python integer."""
    try:
        # Count how many times the numeral applies the increment function starting from 0.
        return church_numeral(lambda count: count + 1)(0)
    except Exception as e:
        # Handle cases where input is not a valid numeral function
        # print(f"Debug: Error in to_py_int - {e}") # Optional debug
        return "Invalid Numeral Func"

print("Helper 'to_py_bool' defined.")
print("Helper 'to_py_int' defined.")


# ========================================
print("\n\n" + "=" * 25 + " DEMONSTRATIONS " + "=" * 24)
# ========================================

# --- Demo A: Direct Boolean Calls ---
print("\n--- Demo A: Direct Boolean Function Calls ---")
val1 = "Apple"
val2 = "Banana"
print(f"Calling py_TRUE('{val1}')('{val2}')")
result_a1 = py_TRUE(val1)(val2)
print(f"  Output => '{result_a1}' (Selected first value)")

print(f"Calling py_FALSE('{val1}')('{val2}')")
result_a2 = py_FALSE(val1)(val2)
print(f"  Output => '{result_a2}' (Selected second value)")
print("-" * 60)

# --- Demo B: Basic IF with Functional Booleans ---
print("\n--- Demo B: Basic IF with Functional Booleans ---")
outcome_T = "Action taken for TRUE condition"
outcome_F = "Action taken for FALSE condition"
print(f"IF TRUE THEN '{outcome_T}' ELSE '{outcome_F}'")
result_b1 = py_IF(py_TRUE)(outcome_T)(outcome_F)
print(f"  Result => '{result_b1}'")

print(f"IF FALSE THEN '{outcome_T}' ELSE '{outcome_F}'")
result_b2 = py_IF(py_FALSE)(outcome_T)(outcome_F)
print(f"  Result => '{result_b2}'")
print("-" * 60)

# --- Demo C: Logical AND Operator ---
print("\n--- Demo C: Logical AND Operator (using py_AND) ---")
print("Testing py_AND (showing interpreted Python bool results):")
print(f"  py_TRUE AND py_TRUE  => {to_py_bool(py_AND(py_TRUE)(py_TRUE))}")   # Expected: True
print(f"  py_TRUE AND py_FALSE => {to_py_bool(py_AND(py_TRUE)(py_FALSE))}")  # Expected: False
print(f"  py_FALSE AND py_TRUE => {to_py_bool(py_AND(py_FALSE)(py_TRUE))}")  # Expected: False
print(f"  py_FALSE AND py_FALSE=> {to_py_bool(py_AND(py_FALSE)(py_FALSE))}") # Expected: False
print("-" * 60)

# --- Demo D: Number Representation and Basic Arithmetic ---
print("\n--- Demo D: Number Representation & Basic Arithmetic ---")
print(f"py_ZERO represents: {to_py_int(py_ZERO)}")     # Expected: 0
print(f"py_ONE represents: {to_py_int(py_ONE)}")       # Expected: 1
print(f"py_TWO represents: {to_py_int(py_TWO)}")       # Expected: 2
print(f"py_THREE represents: {to_py_int(py_THREE)}")   # Expected: 3

# Test Predecessor
pred_of_three = py_PRED(py_THREE)
print(f"PRED(THREE) represents: {to_py_int(pred_of_three)}") # Expected: 2

# Test Subtraction
sub_3_minus_1 = py_SUB(py_THREE)(py_ONE) # 3 - 1
print(f"SUB(THREE)(ONE) represents: {to_py_int(sub_3_minus_1)}") # Expected: 2

# Test Subtraction resulting in Zero (Church Subtraction Clamp)
sub_1_minus_3 = py_SUB(py_ONE)(py_THREE) # 1 - 3
print(f"SUB(ONE)(THREE) represents: {to_py_int(sub_1_minus_3)}") # Expected: 0
print("-" * 60)

# --- Demo E: IF statement Comparing Numbers using py_EQ ---
print("\n--- Demo E: IF Statement Comparing Functional Numbers ---")
# Define number instances to compare
num_2 = py_TWO
num_3 = py_THREE
another_num_2 = py_TWO # A different instance representing the same value

print(f"Comparing numbers A={to_py_int(num_2)}, B={to_py_int(num_3)}, C={to_py_int(another_num_2)}")

# Define outcomes for the conditional branches
outcome_equal = "Compared numbers are EQUAL."
outcome_not_equal = "Compared numbers are NOT EQUAL."

# Compare A and B (2 vs 3)
print(f"\nTest 1: IF (A == B)")
# Step 1: Perform the functional equality check
comparison_AB = py_EQ(num_2)(num_3) # Should result in py_FALSE
print(f"  - Comparison py_EQ(A)(B) yields functional boolean representing: {to_py_bool(comparison_AB)}")
# Step 2: Use the result in the functional IF statement
final_outcome_AB = py_IF(comparison_AB)(outcome_equal)(outcome_not_equal)
print(f"  - Final IF result: '{final_outcome_AB}'") # Should be outcome_not_equal

# Compare A and C (2 vs 2)
print(f"\nTest 2: IF (A == C)")
# Step 1: Perform the functional equality check
comparison_AC = py_EQ(num_2)(another_num_2) # Should result in py_TRUE
print(f"  - Comparison py_EQ(A)(C) yields functional boolean representing: {to_py_bool(comparison_AC)}")
# Step 2: Use the result in the functional IF statement
final_outcome_AC = py_IF(comparison_AC)(outcome_equal)(outcome_not_equal)
print(f"  - Final IF result: '{final_outcome_AC}'") # Should be outcome_equal
print("-" * 60)

print("\n" + "=" * 24 + " End of Demonstrations " + "=" * 23)
print("=" * 60)
