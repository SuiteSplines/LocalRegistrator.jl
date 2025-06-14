@testset "Test user confirm prompt" begin
    redirect_stdout(devnull) do
        @test confirm(; input_function=() -> "y") == true
        @test confirm(; input_function=() -> "n") == false
        @test confirm(; input_function=() -> "Y") == true
        @test confirm(; input_function=() -> "N") == false
        @test confirm(; input_function=() -> "yes") == true
        @test confirm(; input_function=() -> "no") == false
        @test confirm(; input_function=() -> "Yes") == true
        @test confirm(; input_function=() -> "No") == false
        @test confirm(; input_function=() -> "foo") == false
    end
end