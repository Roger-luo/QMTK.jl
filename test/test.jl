module Foo

abstract type AbstractFoo end

module Goo
using Foo
Foo.AbstractFoo

end

end