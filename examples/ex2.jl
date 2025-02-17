# https://optimization.mccormick.northwestern.edu/index.php/Disjunctive_inequalities
using JuMP
using DisjunctiveProgramming

m = Model()
@variable(m, -5 ≤ x[1:2] ≤ 10)
@disjunction(
    m,
    begin
        con1[i=1:2], 0 ≤ x[i] ≤ [3,4][i]
    end,
    begin
        con2[i=1:2], [5,4][i] ≤ x[i] ≤ [9,6][i]
    end,
    reformulation = :big_m,
    name = :y
)
print(m)

# ┌ Warning: [con1[1] : x[1] in [0.0, 3.0], con1[2] : x[2] in [0.0, 4.0]] uses the `MOI.Interval` set. Each instance of the interval set has been split into two constraints, one for each bound.
# ┌ Warning: [con2[1] : x[1] in [5.0, 9.0], con2[2] : x[2] in [4.0, 6.0]] uses the `MOI.Interval` set. Each instance of the interval set has been split into two constraints, one for each bound.
# Feasibility
# Subject to
#  XOR(disj_y) : y[1] + y[2] == 1.0         <- XOR constraint
#  con1[1,lb] : -x[1] + 5 y[1] <= 5.0      <- left-side of con1[1]
#  con1[1,ub] : x[1] + 7 y[1] <= 10.0      <- right-side of con1[1]
#  con1[2,lb] : -x[2] + 5 y[1] <= 5.0      <- left-side of con1[2]
#  con1[2,ub] : x[2] + 6 y[1] <= 10.0      <- right-side of con1[2]
#  con2[1,lb] : -x[1] + 10 y[2] <= 5.0     <- left-side of con2[1]
#  con2[1,ub] : x[1] + y[2] <= 10.0        <- right-side of con2[1]
#  con2[2,lb] : -x[2] + 9 y[2] <= 5.0      <- left-side of con2[2]
#  con2[2,ub] : x[2] + 4 y[2] <= 10.0      <- right-side of con2[2]
#  x[1] >= -5.0                             <- varaible bounds
#  x[2] >= -5.0                             <- variable bounds
#  x[1] <= 10.0                             <- variable bounds
#  x[2] <= 10.0                             <- variable bounds
#  y[1] >= 0.0                              <- lower bound on binary
#  y[2] >= 0.0                              <- lower bound on binary
#  y[1] <= 1.0                              <- upper bound on binary
#  y[2] <= 1.0                              <- upper bound on binary
#  y[1] binary                              <- indicator variable (1st disjunct) is binary
#  y[2] binary                              <- indicator variable (2nd disjunct) is binary