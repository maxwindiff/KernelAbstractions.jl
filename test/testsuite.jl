module Testsuite

using ..KernelAbstractions
using ..Test

include("test.jl")
include("localmem.jl")
include("private.jl")
include("unroll.jl")
include("nditeration.jl")
include("copyto.jl")
include("print_test.jl")
include("compiler.jl")
include("reflection.jl")
include("examples.jl")
include("convert.jl")
include("specialfunctions.jl")

macro conditional_testset(name, skip_tests, expr)
    esc(quote
        @testset $name begin
            if $name ∉ $skip_tests
                $expr
            else
                @test_skip false
            end
        end
    end)
end

function testsuite(backend, backend_str, backend_mod, AT, DAT; skip_tests = Set{String}())
    @conditional_testset "Unittests" skip_tests begin
        unittest_testsuite(backend, backend_str, backend_mod, DAT)
    end

    @conditional_testset "SpecialFunctions" skip_tests begin
        specialfunctions_testsuite(backend)
    end

    @conditional_testset "Localmem" skip_tests begin
        localmem_testsuite(backend, AT)
    end

    @conditional_testset "Private" skip_tests begin
        private_testsuite(backend, AT)
    end

    @conditional_testset "Unroll" skip_tests begin
        unroll_testsuite(backend, AT)
    end

    @testset "NDIteration" begin
        nditeration_testsuite()
    end

    @conditional_testset "copyto!" skip_tests begin
        copyto_testsuite(backend)
    end

    @conditional_testset "Printing" skip_tests begin
        printing_testsuite(backend)
    end

    @conditional_testset "Compiler" skip_tests begin
        compiler_testsuite(backend, AT)
    end

    @conditional_testset "Reflection" skip_tests begin
        reflection_testsuite(backend, backend_str, AT)
    end

    @conditional_testset "Convert" skip_tests begin
        convert_testsuite(backend, AT)
    end

    @conditional_testset "Examples" skip_tests begin
        examples_testsuite(backend_str)
    end
end

end
