#!/bin/bash


test_file="sample.1"

cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef PRINT_DATE
Today is $(date)
#-- @endif
EOF

show_notice "Asserting sample.1.ok ..."

sampleargs="-DPRINT_DATE"
test_begin "$test_file" "Check X" "$sampleargs"

$spp $sampleargs $builddir/sample.1
if [ "$(wc -l < $builddir/sample.1.spp)" = "2" ]; then
    test_ok
else
    test_fail
fi

cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "ABC"
EOF

test_begin "$test_file" "Check '(X)'" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (PRINT_DATE)
echo "ABC"
#-- @endif
EOF
run_local_sample_test $sampleargs sample.1


sampleargs="-DA_TRUE"
test_begin "$test_file" "Check '(X) || X'" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (PRINT_DATE) || A_TRUE
echo "ABC"
#-- @endif
EOF
run_local_sample_test $sampleargs sample.1

sampleargs="-DA_TRUE -DPRINT_DATE"
test_begin "$test_file" "Check '(((X))) && X'" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATE))) && A_TRUE
echo "ABC"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

test_begin "$test_file" "Check '((( X )))'" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((  PRINT_DATE  )))
echo "ABC"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

sampleargs="-DPRINT_DATE"
test_begin "$test_file" "Check 'X | ((( X )))'" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A_TRUE || (((  PRINT_DATE  )))
echo "ABC"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

sampleargs="-DPRINT_DATE -DA_FALSE"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A_TRUE || (((  PRINT_DATE  ))) && A_FALSE
echo "ABC"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1


sampleargs="-DPRINT_DATE"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATE  )))
echo "ABC"
#-- @elif PRINT_DATE
echo "DEF"
#-- @else
echo "XYZ"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

sampleargs="-DPRINT_DATE"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATER  )))
echo "DEF"
#-- @elif PRINT_DATE
echo "ABC"
#-- @else
echo "XYZ"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

sampleargs="-DAA -DAS"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATER  )))
echo "DEF"
#-- @elif AA && AS 
echo "ABC"
#-- @else
echo "XYZ"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

sampleargs="-DAB -DAA -DAS"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATER  )))
echo "DEF"
#-- @elif AA && AS || AB
echo "ABC"
#-- @else
echo "XYZ"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATER  )))
echo "DEF"
#-- @elif AA && (AS || AB)
echo "ABC"
#-- @else
echo "XYZ"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

sampleargs="-DAB -DAS"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATER  )))
echo "DEF"
#-- @elif AA && (AS || AB)
echo "XYZ"
#-- @else
echo "ABC"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

sampleargs="-DAB -DSS"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATER  )))
echo "DEF"
#-- @elif AA && (AS || AB)
echo "XYZ"
#-- @elif AA && (AS || AB) && SS
echo "OPQ"
#-- @else
echo "ABC"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

sampleargs="-DAB -DSS -DFF"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATER  )))
echo "DEF"
#-- @elif AA && (AS || AB)
echo "XYZ"
#-- @elif AA && (AS || AB) && SS
echo "OPQ"
#-- @else
#-- @ifdef BC
echo "CBA"
#-- @else
echo "ABC"
#-- @endif BC
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1


sampleargs="-DAB -DSS -DFF"
test_begin "$test_file" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (((PRINT_DATER  )))

#-- @elif AA && (AS || AB)
echo "XYZ"
#-- @elif AA && (AS || AB) && SS
echo "OPQ"
#-- @else
#-- @ifdef BC
echo "CBA"
#-- @else
echo "ABC"
#-- @endif BC
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

###########################

cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo 1
EOF

sampleargs="-DAB -DSS -DFF -DAD"
test_begin "$builddir/sample.1" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef FF
#-- @ifdef AD
echo 1
#-- @else
echo 2
#-- @endif AD
#-- @elif AA && (AS || AB)
echo 3
#-- @elif AA && (AS || AB) && SS
echo 4
#-- @else
#-- @ifdef BC
echo 5
#-- @else
echo 6
#-- @endif BC
#-- @endif FF
EOF
run_local_sample_test "$sampleargs" sample.1


###################################

cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo 1
echo 0
EOF

sampleargs="-DAB -DSS -DFF -DAD"
test_begin "$builddir/sample.1" "" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef FF
#-- @ifdef A1
echo 01
#-- @elif A2
echo 02
#-- @elif AD
echo 1
#-- @endif A1
echo 0
#-- @elif AA && (AS || AB)
echo 3
#-- @elif AA && (AS || AB) && SS
echo 4
#-- @else
#-- @ifdef BC
echo 5
#-- @else
echo 6
#-- @endif BC
#-- @endif FF
EOF
run_local_sample_test "$sampleargs" sample.1

###############################
# New: complex boolean expression tests
###############################

# Test: A && B && C (all true)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "and-chain"
EOF

sampleargs="-DA -DB -DC"
test_begin "$test_file" "A && B && C chain" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && B && C
echo "and-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: A && B && C (one false)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs="-DA -DC"
test_begin "$test_file" "A && B && C (B missing)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && B && C
echo "and-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: A || B || C (all false)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs=""
test_begin "$test_file" "A || B || C (none defined)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A || B || C
echo "or-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: A || B || C (one true)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "or-chain"
EOF

sampleargs="-DB"
test_begin "$test_file" "A || B || C (B defined)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A || B || C
echo "or-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: (A || B) && C (grouping)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "group-prec"
EOF

sampleargs="-DB -DC"
test_begin "$test_file" "(A || B) && C (B, C defined)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (A || B) && C
echo "group-prec"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: (A || B) && C (false)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs="-DA"
test_begin "$test_file" "(A || B) && C (C missing)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (A || B) && C
echo "group-prec"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: precedence: A && B || C (A false, B true, C true)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "prec-or"
EOF

sampleargs="-DB -DC"
test_begin "$test_file" "A && B || C precedence (A && B) || C" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && B || C
echo "prec-or"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Same condition with parens: different result
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs="-DB -DC"
test_begin "$test_file" "A && (B || C) grouping (A false)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && (B || C)
echo "prec-and"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: (A || B) && (C || D)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "multi-group"
EOF

sampleargs="-DA -DC"
test_begin "$test_file" "(A || B) && (C || D)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (A || B) && (C || D)
echo "multi-group"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: ((A && B) || (C && D))
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "deep-nested"
EOF

sampleargs="-DA -DB -DC"
test_begin "$test_file" "((A && B) || (C && D))" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef ((A && B) || (C && D))
echo "deep-nested"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: underscore identifiers
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "underscore"
EOF

sampleargs="-DMY_FLAG -DOTHER_VAR"
test_begin "$test_file" "MY_FLAG && OTHER_VAR (underscore)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef MY_FLAG && OTHER_VAR
echo "underscore"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: underscore false
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs="-DMY_FLAG"
test_begin "$test_file" "MY_FLAG && OTHER_VAR (OTHER_VAR missing)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef MY_FLAG && OTHER_VAR
echo "underscore"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: @elif with (A && B) || C
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "elif-complex"
EOF

sampleargs="-DA -DC"
test_begin "$test_file" "@elif with (A && B) || C" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef X
echo "if"
#-- @elif (A && B) || C
echo "elif-complex"
#-- @else
echo "else"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: @elif false -> @else
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "else-branch"
EOF

sampleargs="-DA"
test_begin "$test_file" "@elif (A && B) || C false" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef X
echo "if"
#-- @elif (A && B) || C
echo "elif-branch"
#-- @else
echo "else-branch"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: multiple @elif complex
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "third-elif"
EOF

sampleargs="-DB -DE -DF"
test_begin "$test_file" "multiple @elif complex" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && B
echo "first-elif"
#-- @elif (C || D) && E
echo "second-elif"
#-- @elif F || G
echo "third-elif"
#-- @else
echo "else"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: A && B && C && D && E (long AND all true)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "long-and-chain"
EOF

sampleargs="-DA -DB -DC -DD -DE"
test_begin "$test_file" "A && B && C && D && E (all true)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && B && C && D && E
echo "long-and-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: long AND (one missing)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs="-DA -DB -DC -DE"
test_begin "$test_file" "A && B && C && D && E (D missing)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && B && C && D && E
echo "long-and-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: long OR (all false)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs=""
test_begin "$test_file" "A || B || C || D || E (none defined)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A || B || C || D || E
echo "long-or-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: long OR (one true at end)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "long-or-chain"
EOF

sampleargs="-DE"
test_begin "$test_file" "A || B || C || D || E (only E)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A || B || C || D || E
echo "long-or-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: A && B || C && D || E (mixed chain)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "mixed-chain"
EOF

sampleargs="-DA -DB -DE"
test_begin "$test_file" "A && B || C && D || E" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && B || C && D || E
echo "mixed-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: mixed chain (all false)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs=""
test_begin "$test_file" "A && B || C && D || E (none)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && B || C && D || E
echo "mixed-chain"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: ((A && B) && (C || D)) && E
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "deep-group-and"
EOF

sampleargs="-DA -DB -DC -DE"
test_begin "$test_file" "((A && B) && (C || D)) && E" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef ((A && B) && (C || D)) && E
echo "deep-group-and"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: deep group (false - neither C nor D)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs="-DA -DB -DE"
test_begin "$test_file" "((A && B) && (C || D)) && E (no C, no D)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef ((A && B) && (C || D)) && E
echo "deep-group-and"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: @elif with (((A && B))) deep parens
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "deep-paren-elif"
EOF

sampleargs="-DA -DB"
test_begin "$test_file" "@elif (((A && B)))" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef ZZZ
echo "if"
#-- @elif (((A && B)))
echo "deep-paren-elif"
#-- @else
echo "else"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: nested @ifdef inside @ifdef
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "outer-true"
echo "inner-true"
EOF

sampleargs="-DOUTER -DINNER"
test_begin "$test_file" "nested @ifdef both true" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef OUTER
echo "outer-true"
#-- @ifdef INNER
echo "inner-true"
#-- @endif INNER
#-- @endif OUTER
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: nested outer true inner false (with @else)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "outer-true"
echo "inner-false"
EOF

sampleargs="-DOUTER"
test_begin "$test_file" "nested outer true inner false" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef OUTER
echo "outer-true"
#-- @ifdef INNER
echo "inner-true"
#-- @else
echo "inner-false"
#-- @endif INNER
#-- @endif OUTER
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: triple level nesting
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "level1"
echo "level2"
echo "level3"
EOF

sampleargs="-DL1 -DL2 -DL3"
test_begin "$test_file" "triple nested @ifdef" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef L1
echo "level1"
#-- @ifdef L2
echo "level2"
#-- @ifdef L3
echo "level3"
#-- @endif L3
#-- @endif L2
#-- @endif L1
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: single char identifiers
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "single-char"
EOF

sampleargs="-DX -DY"
test_begin "$test_file" "X && Y" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef X && Y
echo "single-char"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: deep parens single identifier
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "deep-paren-single"
EOF

sampleargs="-DX"
test_begin "$test_file" "((((((X))))))" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef ((((((X))))))
echo "deep-paren-single"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: (A || B || C) && (D || E || F)
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "big-group-and"
EOF

sampleargs="-DA -DD"
test_begin "$test_file" "(A || B || C) && (D || E || F)" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (A || B || C) && (D || E || F)
echo "big-group-and"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: (A || B || C) && (D || E || F) false
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs="-DA"
test_begin "$test_file" "(A || B || C) && (D || E || F) only A" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef (A || B || C) && (D || E || F)
echo "big-group-and"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: A && (B || (C && D))
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "nested-group"
EOF

sampleargs="-DA -DB -DC -DD"
test_begin "$test_file" "A && (B || (C && D)) all true" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && (B || (C && D))
echo "nested-group"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: A && (B || (C && D)) B false, C,D true
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "nested-group"
EOF

sampleargs="-DA -DC -DD"
test_begin "$test_file" "A && (B || (C && D)) B false" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && (B || (C && D))
echo "nested-group"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: A && (B || (C && D)) false
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
EOF

sampleargs="-DA -DC"
test_begin "$test_file" "A && (B || (C && D)) false" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A && (B || (C && D))
echo "nested-group"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1

# Test: @ifdef inside @elif branch
cat > $builddir/sample.1.ok <<EOF
#!/bin/bash
echo "elif-nest"
EOF

sampleargs="-DX -DY"
test_begin "$test_file" "@ifdef inside @elif" "$sampleargs"
cat > $builddir/sample.1 <<EOF
#!/bin/bash
#-- @ifdef A
echo "a"
#-- @elif X
#-- @ifdef Y
echo "elif-nest"
#-- @else
echo "elif-else"
#-- @endif Y
#-- @else
echo "else"
#-- @endif
EOF
run_local_sample_test "$sampleargs" sample.1