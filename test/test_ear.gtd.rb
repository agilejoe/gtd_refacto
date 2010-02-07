@message = " do the foo < protocol 4 > [context]"  
expected = "protocol 4" 
assert_equal expected, EarGTD.parse_project(@message)

@message = " do the foo < protocol 4 > [context]"  
expected = "context" 
assert_equal expected, EarGTD.parse_context(@message)

@message = " do the foo < protocol 4 > [context]"    
expected = "do the foo" 
assert_equal expected, EarGTD.parse_task(@message)