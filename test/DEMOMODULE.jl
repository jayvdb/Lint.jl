module LintExample
using Lint
export @fancyfuncgen

macro fancyfuncgen(sym)
    s = string(sym)
    code = Expr(:function,
        :($sym()),
        quote
            println($s)
        end)
    esc(code)
end

function lint_helper(ex::Expr, ctx::LintContext)
    if ex.head == :macrocall
        if ex.args[1] == Symbol("@fancyfuncgen")
            if typeof(ex.args[2]) != Symbol
                Lint.msg(ctx, 2, "@fancyfuncgen must use a symbol argument")
            else
                push!(ctx.callstack[end].functions, ex.args[2])
            end
            return true
        end
    end
    return false
end

end
