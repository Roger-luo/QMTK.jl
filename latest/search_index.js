var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#homepage-1",
    "page": "Home",
    "title": "QMTK Documentation",
    "category": "section",
    "text": "Welcome to QMTK (Quantum Many-body Toolkit)"
},

{
    "location": "#Manual-1",
    "page": "Home",
    "title": "Manual",
    "category": "section",
    "text": "Introduction"
},

{
    "location": "#Basic-Types-1",
    "page": "Home",
    "title": "Basic Types",
    "category": "section",
    "text": "Basis"
},

{
    "location": "#Toolkits-1",
    "page": "Home",
    "title": "Toolkits",
    "category": "section",
    "text": "Physics Constants\nStatistics (samplers, statistic analysis, etc.)\nHamiltonian\nLattice (Chain Lattice, etc.)\nModel (Tensor Networks, Neural Networks, etc.)"
},

{
    "location": "man/introduction/#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "man/introduction/#man-introduction-1",
    "page": "Introduction",
    "title": "Introduction",
    "category": "section",
    "text": "The QMTK library is developed for physics system involves quantum many-body system, including condensed matter physics, quantum computing, quantum information and etc."
},

{
    "location": "man/introduction/#Motivation-1",
    "page": "Introduction",
    "title": "Motivation",
    "category": "section",
    "text": "In most numerical and theoretical works, programs related to quantum physics and quantum many-body system could have a lot similar functionality, methods, and objects. We aims to offer a collection of algorithms, object abstractions for quantum many-body system, which will ease your daily work. QMTK aims to provide physicist with a powerful toolkit in Julia language as its frontend interface. Although, Julia language is a promising language for scientific computing, we are not limited to Julia."
},

{
    "location": "man/introduction/#About-this-Project-1",
    "page": "Introduction",
    "title": "About this Project",
    "category": "section",
    "text": "This project also aims to start an active developers community, we accept any feature request related to the following topic:quantum many-body system\nquantum information (including quantum computing)\ncondensed matter physics"
},

{
    "location": "man/introduction/#Philosophy-1",
    "page": "Introduction",
    "title": "Philosophy",
    "category": "section",
    "text": "The QMTK package will try to provide a collection of objects that make use of Julia native interface, which will make your learning curve as smooth as possible.In the meantime, we will try any possible and aggressive methods to improve our performance.For the models part, we will not provide a general framework to construct quantum circuit, tensor network and neural network. All of our models are designed to be coarse-grained, which means there is only building blocks and there is no tensor (although currently we heavily rely on Julia\'s native array/tensor interface)."
},

{
    "location": "man/introduction/#How-to-contribute-1",
    "page": "Introduction",
    "title": "How to contribute",
    "category": "section",
    "text": "If you wish to have a new feature, or you wish to contribute to this project, please open an issue here to discuss the details and then start your pull request or your pull request may not be merged.Once your pull request is made, we will apoint a former contributor to review your code. The contributor will approve your pull request if there is no futher suggestions."
},

{
    "location": "man/introduction/#Why-choose-Julia?-1",
    "page": "Introduction",
    "title": "Why choose Julia?",
    "category": "section",
    "text": "Though, Julia is not perfect, there is some disadvantage for this language at the moment, but we choose this language as frontend for the following reason:Julia is fast For most many-body system related computation, performance is vital. Not only because Julia has JIT (Just-in-time) compiler. The language itself is designed to help the programmer provide as many information as they want to the compiler, which will allow us to optimize this package in the long run.Amazing Meta Programming  Julia itself provide a lisp like macro, and we are able to use the language itself to edit AST. This is extremely useful when we need to arrange the computation task according to your math expression, and we will not need to use techs like expression template in C++ to lazy evaluate some expression, in most cases, we can just use Julia\'s native generated functions, and the Lazy.jl package for more complex use. And we can use code generation to provide more efficient functions.Awesome FFI The Foreign Function Interface (FFI) of Julia is awesome, no extra glue code is needed. We can always provide highly optimized C/C++/Fortran/CUDA backend for our package. And we can even just use pyjulia to call this package in Python if you like python."
},

{
    "location": "man/basictype/#",
    "page": "Basic Types",
    "title": "Basic Types",
    "category": "page",
    "text": ""
},

{
    "location": "man/basictype/#man-basic-type-1",
    "page": "Basic Types",
    "title": "Basic Types",
    "category": "section",
    "text": ""
},

{
    "location": "man/basictype/#Basis-1",
    "page": "Basic Types",
    "title": "Basis",
    "category": "section",
    "text": "Basis is a useful object when describing a Hilbert space. In quantum physics, there are many kind of basis in different problems, including qubits, lattice site, infinity basis, etc.The basis we mention here and implemented in this package is the tagged part. If you need to use Dirac ket expression, you can simply do it by hands with dot function in Julia\'s linear algebra stdlib. We will not be able to help you to figure out which one is left ket and which one is the right at the moment. To be specific, the basis here means what is inside you ket expression.basisrangle or langle basis"
},

{
    "location": "man/basictype/#QMTK.Bit",
    "page": "Basic Types",
    "title": "QMTK.Bit",
    "category": "type",
    "text": "Bit <: AbstractBitSite\n\nBinary State, Bit. Has two state: 0, 1\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.Spin",
    "page": "Basic Types",
    "title": "QMTK.Spin",
    "category": "type",
    "text": "Spin <: AbstractBitSite\n\nBinary State, Spin. Has two state: -1, 1\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.Half",
    "page": "Basic Types",
    "title": "QMTK.Half",
    "category": "type",
    "text": "Half <: AbstractBitSite\n\nBinary State, Half. Has two state: -0.5, 0.5\n\n\n\n"
},

{
    "location": "man/basictype/#Label-1",
    "page": "Basic Types",
    "title": "Label",
    "category": "section",
    "text": "All the labels are subtype of SiteLabel, label type is used to provide information about the content in a AbstractSites instance.QMTK offers three kind of labels: Bit, Spin, Half for binary configurations.Bit\nSpin\nHalf"
},

{
    "location": "man/basictype/#QMTK.AbstractSites",
    "page": "Basic Types",
    "title": "QMTK.AbstractSites",
    "category": "type",
    "text": "AbstractSites{Label, T, N} <: AbstractArray{T, N}\n\nSites are arrays with certain labels\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.Sites",
    "page": "Basic Types",
    "title": "QMTK.Sites",
    "category": "type",
    "text": "Sites{L <: SiteLabel, T, N} <: AbstractSites{L, T, N}\n\nLattice Sites are Julia Arrays with certain Label, it is able to use array interface.\n\nTODO: type promote to normal arrays when mixed with normal arrays.\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.data",
    "page": "Basic Types",
    "title": "QMTK.data",
    "category": "function",
    "text": "data(basis)\n\nget data of the basis\n\n\n\ndata(space::AbstractSpace{T, S}) -> T\n\nget the current data of this space\n\n\n\n"
},

{
    "location": "man/basictype/#Sites-1",
    "page": "Basic Types",
    "title": "Sites",
    "category": "section",
    "text": "The abstract hierachy for site is defined as any subtype of AbstractArray with label.AbstractSitesSites is a Julia native array with certain label that tells the program which kind of site it is.SitesAnd naive example of Sites could be the Bit configuration on a Chain lattice (a 1-D Array of Bits on the memory)0quad 1quad 0quad 1quad 1quad 0You can declare it byusing QMTKSites(Bit, [0, 1, 0, 1, 1, 0])Sites is implemented to support most of Julia array interface, but since Julia do not have inherit of interface, not all operations is overloaded, please use method data, when you need to access its content in calculatoin.data"
},

{
    "location": "man/basictype/#QMTK.SubSites",
    "page": "Basic Types",
    "title": "QMTK.SubSites",
    "category": "type",
    "text": "SubSites{Label, T, Length} <: AbstractSites{Label, T, 1}\n\nSub-sites is usually derived from Sites. It contains several sites in a tuple for local operations.\n\nNOTE: SubSites should be designed faster for bitwise operations, cause this will be a temperory type for traversing through lattice.\n\n\n\n"
},

{
    "location": "man/basictype/#SubSites-1",
    "page": "Basic Types",
    "title": "SubSites",
    "category": "section",
    "text": "For small sites, it usually contains only a few configuration, and when we try to use a subset of Sites, it would be a waste to create a new Sites, SubSites offer a way to do this efficiently by telling the compiler how large it is in compile time (by Tuple).SubSitesOr to be simple, you can just interpret SubSites to be a Tuple with certain SiteLabel. Use it like a native Tuple.SubSites(Bit, 1, 0)and just like tuplea, b = SubSites(Bit, 1, 0);\na\nb"
},

{
    "location": "man/basictype/#QMTK.AbstractSpace",
    "page": "Basic Types",
    "title": "QMTK.AbstractSpace",
    "category": "type",
    "text": "AbstractSpace{T, S}\n\nGeneral abstract type for space with T as its content in state S.\n\nIn fact, an instance of a space should be a type with a temporary memory to store an element of the space in type T.\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.SpaceState",
    "page": "Basic Types",
    "title": "QMTK.SpaceState",
    "category": "type",
    "text": "state of a sample space: Randomized, Initialized, etc.\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.Randomized",
    "page": "Basic Types",
    "title": "QMTK.Randomized",
    "category": "type",
    "text": "This sample space is randomized. (current sample is a initialized randomly)\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.Initialized",
    "page": "Basic Types",
    "title": "QMTK.Initialized",
    "category": "type",
    "text": "This sample space is initialized. (current sample is a certain default one)\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.RealSpace",
    "page": "Basic Types",
    "title": "QMTK.RealSpace",
    "category": "type",
    "text": "RealSpace{T, DType, S} <: AbstractSpace{T, S}\n\nA real space contains element of type DType (e.g Array or a Number), the numeric content of each element has type T (eltype(DType) = T)\n\nA naive example is the 1-D real space\n\njulia> RealSpace(min=-1, max=1)\nQMTK.RealSpace{Float64,Float64,QMTK.Randomized}(-1.0, 1.0, -0.04293376352914002)\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.SiteSpace",
    "page": "Basic Types",
    "title": "QMTK.SiteSpace",
    "category": "type",
    "text": "SiteSpace{NFlips, S} <: AbstractSpace{Sites, S}\n\nA space of sites contains all possible configurations of the sites. NFlips indicated how many site will flip according to certain rules when shake! is called.\n\nSiteSpace(label, shape; nflips)\n\nconstructs a SiteSpace with label in type SiteLabel, and shape with an optional keyword nflips (default to be 1).\n\njulia> SiteSpace(Bit, 2, 2)\nQMTK.SiteSpace{1,QMTK.Randomized}(Int8[1 1; 0 0])\n\n\n\n"
},

{
    "location": "man/basictype/#Space-1",
    "page": "Basic Types",
    "title": "Space",
    "category": "section",
    "text": "Space are math objects contains a set of objects with certain structure. In QMTK we present it as AbstractSpace.AbstractSpaceThere are currently two kinds of state for a space.SpaceState\nRandomized\nInitializedThere are two kind of space currentlyRealSpace\nSiteSpace"
},

{
    "location": "man/basictype/#QMTK.data-Tuple{QMTK.AbstractSpace}",
    "page": "Basic Types",
    "title": "QMTK.data",
    "category": "method",
    "text": "data(space::AbstractSpace{T, S}) -> T\n\nget the current data of this space\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.reset!",
    "page": "Basic Types",
    "title": "QMTK.reset!",
    "category": "function",
    "text": "reset!(space) -> space # with initilized state\n\nreset the temporary data of this space to initial position be careful that the state of the space will also be changed assign it to your variable manually.\n\nspace = reset!(space)\n\n\n\n"
},

{
    "location": "man/basictype/#Base.copy",
    "page": "Basic Types",
    "title": "Base.copy",
    "category": "function",
    "text": "copy(space) -> space\n\ncopy the space instance\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.acquire",
    "page": "Basic Types",
    "title": "QMTK.acquire",
    "category": "function",
    "text": "acquire(space) -> element\n\nget a copy of current element of the space\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.shake!",
    "page": "Basic Types",
    "title": "QMTK.shake!",
    "category": "function",
    "text": "shake!(space) -> space\n\nshake the space and move current element to a random position. the space has to be a space with Randomized state. or it will an UnRandomizedError.\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.randomize!",
    "page": "Basic Types",
    "title": "QMTK.randomize!",
    "category": "function",
    "text": "randomize!(space) -> space\n\nrandomized the space, move current element to a random position and change the state of this space to Initialized\n\n\n\n"
},

{
    "location": "man/basictype/#QMTK.traverse",
    "page": "Basic Types",
    "title": "QMTK.traverse",
    "category": "function",
    "text": "traverse(space) -> iterator\n\nget an iterator that traverses the whole space.\n\n\n\n"
},

{
    "location": "man/basictype/#Interface-1",
    "page": "Basic Types",
    "title": "Interface",
    "category": "section",
    "text": "A space object has the following interfacemethod description\ndata property, required\nreset! required\ncopy required\nacquire required\nshake! required\nrandomized required\ntraverse optionaldata(x::AbstractSpace)\nreset!\ncopy\nacquire\nshake!\nrandomize!\ntraverse"
},

{
    "location": "man/constants/#",
    "page": "Physics Constants",
    "title": "Physics Constants",
    "category": "page",
    "text": ""
},

{
    "location": "man/constants/#man-constants-1",
    "page": "Physics Constants",
    "title": "Physics Constants",
    "category": "section",
    "text": "using QMTK.ConstsThe physics constants module QMTK.Consts uses NIST CODATA Project\'s definitions of physics constants as default. You can access all NIST data in QMTK.Consts.DATA[\"NIST\"] by use certain names of the constant, e.ga = Consts.DATA[\"NIST\"][\"Bohr radius\"]You will receive a Consts.NISTConst type, which contains information of the constants quantity, uncertainty, unit and value, but don\'t panic we have overload this type and just use it like normal native Julia numbers, it will automatically use its value to do the operation.You can access all these property bya.quantity\na.uncertainty\na.unit\na.valueYou can bring defined Physics Constants\' name by callingjuila> using QMTK.ConstsThis will bring the following physics constatns into your current scope. Be careful, this may cause name conflict to your current variables. If you do not want to cause this conflict you can just usejulia> import QMTK.Consts"
},

{
    "location": "man/constants/#QMTK.Consts.μ0",
    "page": "Physics Constants",
    "title": "QMTK.Consts.μ0",
    "category": "constant",
    "text": "magnetic constant (vacuum permeability)\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.ε0",
    "page": "Physics Constants",
    "title": "QMTK.Consts.ε0",
    "category": "constant",
    "text": "electric constant (vacuum permittivity)\n\n\n\n"
},

{
    "location": "man/constants/#Defined-Physics-Constant-1",
    "page": "Physics Constants",
    "title": "Defined Physics Constant",
    "category": "section",
    "text": "The following physics constants whose value is defined are provided by QMTK.Consts:Consts.μ0\nConsts.ε0"
},

{
    "location": "man/constants/#QMTK.Consts.c",
    "page": "Physics Constants",
    "title": "QMTK.Consts.c",
    "category": "constant",
    "text": "speed of light in vacuum\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.c0",
    "page": "Physics Constants",
    "title": "QMTK.Consts.c0",
    "category": "constant",
    "text": "speed of light in vacuum\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.G",
    "page": "Physics Constants",
    "title": "QMTK.Consts.G",
    "category": "constant",
    "text": "Newtonian constant of gravitation\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.g",
    "page": "Physics Constants",
    "title": "QMTK.Consts.g",
    "category": "constant",
    "text": "standard acceleration of gravity\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.ħ",
    "page": "Physics Constants",
    "title": "QMTK.Consts.ħ",
    "category": "constant",
    "text": "Planck constant over 2 pi\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.h",
    "page": "Physics Constants",
    "title": "QMTK.Consts.h",
    "category": "constant",
    "text": "Planck constant\n\n\n\n"
},

{
    "location": "man/constants/#Universal-constants-1",
    "page": "Physics Constants",
    "title": "Universal constants",
    "category": "section",
    "text": "The following physics constants are provided by QMTK.Consts with data download from NIST:Consts.c\nConsts.c0\nConsts.G\nConsts.g\nConsts.ħ\nConsts.h"
},

{
    "location": "man/constants/#QMTK.Consts.e",
    "page": "Physics Constants",
    "title": "QMTK.Consts.e",
    "category": "constant",
    "text": "atomic unit of charge\n\n\n\n"
},

{
    "location": "man/constants/#Electromagnetic-constants-1",
    "page": "Physics Constants",
    "title": "Electromagnetic constants",
    "category": "section",
    "text": "This constant will cause conflict with default constant e for mathematical constant e, you can use another binding eu for 2.718... after using QMTK.Consts instead.Consts.e"
},

{
    "location": "man/constants/#QMTK.Consts.a0",
    "page": "Physics Constants",
    "title": "QMTK.Consts.a0",
    "category": "constant",
    "text": "Bohr radius\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.α",
    "page": "Physics Constants",
    "title": "QMTK.Consts.α",
    "category": "constant",
    "text": "fine-structure constant\n\n\n\n"
},

{
    "location": "man/constants/#Atomic-and-nuclear-constants-1",
    "page": "Physics Constants",
    "title": "Atomic and nuclear constants",
    "category": "section",
    "text": "Consts.a0\nConsts.α"
},

{
    "location": "man/constants/#QMTK.Consts.k",
    "page": "Physics Constants",
    "title": "QMTK.Consts.k",
    "category": "constant",
    "text": "Boltzmann constant\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.NA",
    "page": "Physics Constants",
    "title": "QMTK.Consts.NA",
    "category": "constant",
    "text": "Avogadro constant\n\n\n\n"
},

{
    "location": "man/constants/#QMTK.Consts.atm",
    "page": "Physics Constants",
    "title": "QMTK.Consts.atm",
    "category": "constant",
    "text": "standard atmosphere\n\n\n\n"
},

{
    "location": "man/constants/#Physico-chemical-constants-1",
    "page": "Physics Constants",
    "title": "Physico-chemical constants",
    "category": "section",
    "text": "Consts.k\nConsts.NA\nConsts.atm"
},

{
    "location": "man/constants/#Pauli-matrix-1",
    "page": "Physics Constants",
    "title": "Pauli matrix",
    "category": "section",
    "text": "We provide some sugar for pauli matrix with Julia stdlib in QMTK.Consts.PauliYou can use the following command to bring sigmax, sigmay, sigmaz, sigmai (for the 2x2 identity) and σ, σ₀, σ₁, σ₂, σ₃using QMTK.Consts.Pauliwhere σ is the Pauli Groupσ[1] # sigmai\nσ[2] # sigmax\nσ[3] # sigmay\nσ[4] # sigmazand S is the PauliVector: (sigma_x sigma_y sigma_z)you can use it when you need operations likeS * S # σ₁⊗σ₁ + σ₂⊗σ₂ + σ₃⊗σ₃"
},

{
    "location": "man/lattice/#",
    "page": "Lattice",
    "title": "Lattice",
    "category": "page",
    "text": ""
},

{
    "location": "man/lattice/#QMTK.AbstractLattice",
    "page": "Lattice",
    "title": "QMTK.AbstractLattice",
    "category": "type",
    "text": "AbstractLattice{N}\n\nAbstract type for lattices. N indicated the dimension of this lattice type.\n\n\n\n"
},

{
    "location": "man/lattice/#QMTK.LatticeProperty",
    "page": "Lattice",
    "title": "QMTK.LatticeProperty",
    "category": "type",
    "text": "LatticeProperty\n\nAbstract type for lattice properties can be determined in compile time.\n\n\n\n"
},

{
    "location": "man/lattice/#QMTK.Boundary",
    "page": "Lattice",
    "title": "QMTK.Boundary",
    "category": "type",
    "text": "Boundary <: LatticeProperty\n\nAbstract type for boundary conditions.\n\n\n\n"
},

{
    "location": "man/lattice/#QMTK.Fixed",
    "page": "Lattice",
    "title": "QMTK.Fixed",
    "category": "type",
    "text": "Fixed <: Boundary\n\nFixed boundary tag.\n\n\n\n"
},

{
    "location": "man/lattice/#QMTK.Periodic",
    "page": "Lattice",
    "title": "QMTK.Periodic",
    "category": "type",
    "text": "Periodic <: Boundary\n\nPeriodic boundary tag.\n\n\n\n"
},

{
    "location": "man/lattice/#man-lattice-1",
    "page": "Lattice",
    "title": "Lattice",
    "category": "section",
    "text": "Lattices are very common in both condensed matter physics and statistic physics. We offer a general tiny framework for lattices here.All lattice types are subtype of AbstractLattice{N}AbstractLatticeWe also offers some property tags for lattices. All possible property types are subtype of LatticeProperty.QMTK.LatticePropertyCurrently we only offer one property: BoundaryQMTK.BoundaryThere are two kinds of boundary conditions for a latticeFixed\nPeriodic"
},

{
    "location": "man/lattice/#QMTK.BCLattice",
    "page": "Lattice",
    "title": "QMTK.BCLattice",
    "category": "type",
    "text": "BCLattice{B, N} <: AbstractLattice{N}\n\nLattice with boundary condition.\n\n\n\n"
},

{
    "location": "man/lattice/#QMTK.isperiodic",
    "page": "Lattice",
    "title": "QMTK.isperiodic",
    "category": "function",
    "text": "isperiodic(lattice) -> Bool\n\nwhether this lattice has periodic boundary.\n\n\n\n"
},

{
    "location": "man/lattice/#QMTK.shape",
    "page": "Lattice",
    "title": "QMTK.shape",
    "category": "function",
    "text": "shape(lattice) -> Tuple\n\nget the shape of a lattice\n\n\n\n"
},

{
    "location": "man/lattice/#Base.length",
    "page": "Lattice",
    "title": "Base.length",
    "category": "function",
    "text": "length(lattice) -> Int\n\nget the length (or the product of size in each dimension) of the lattice\n\n\n\n"
},

{
    "location": "man/lattice/#QMTK.sites",
    "page": "Lattice",
    "title": "QMTK.sites",
    "category": "function",
    "text": "sites(lattice)\n\nget the site iterator of the lattice.\n\n\n\n"
},

{
    "location": "man/lattice/#QMTK.bonds",
    "page": "Lattice",
    "title": "QMTK.bonds",
    "category": "function",
    "text": "bonds(lattice, k)\n\nget the kth bond\'s iterator of the lattice\n\n\n\n"
},

{
    "location": "man/lattice/#Lattice-with-Boundary-Condition-1",
    "page": "Lattice",
    "title": "Lattice with Boundary Condition",
    "category": "section",
    "text": "All lattices with a boundary condition is the subtype ofBCLatticeThe BCLattice has the following interfaceisperiodic\nshape\nlength\nsites\nbondsTo traverse all sites of a certain lattice, you can use it as an iterator.for each_site in sites(lattice)\n    println(each_site)\nendTo traverse all bonds of a certain lattice, you can use bonds, the following example traverse 2nd nearest bond on the lattice.for each_bond in bonds(lattice, 2)\n    println(each_bond)\nend"
},

{
    "location": "man/lattice/#QMTK.Chain",
    "page": "Lattice",
    "title": "QMTK.Chain",
    "category": "type",
    "text": "Chain{B} <: BCLattice{B, 1}\n\ngeneral chain lattice with boundary condition B.\n\nChain([Boundary], length)\n\nConstruct a chain lattice with boundary (optional, default to be Fixed)\n\njulia> Chain(10)\nQMTK.Chain{QMTK.Fixed}(10)\n\n\n\n\n"
},

{
    "location": "man/lattice/#Chain-Lattice-1",
    "page": "Lattice",
    "title": "Chain Lattice",
    "category": "section",
    "text": "Chain"
},

{
    "location": "man/lattice/#QMTK.Square",
    "page": "Lattice",
    "title": "QMTK.Square",
    "category": "type",
    "text": "Square{B} <: BCLattice{B, 2}\n\nGeneral square lattice with boundary condition B.\n\nSquare([Boundary], width, height)\nSquare([Boundary], shape)\n\nConstruct a square lattice\n\n\n\n"
},

{
    "location": "man/lattice/#Square-Lattice-1",
    "page": "Lattice",
    "title": "Square Lattice",
    "category": "section",
    "text": "Square"
},

{
    "location": "man/hamiltonian/#",
    "page": "Hamiltonian",
    "title": "Hamiltonian",
    "category": "page",
    "text": ""
},

{
    "location": "man/hamiltonian/#QMTK.Region",
    "page": "Hamiltonian",
    "title": "QMTK.Region",
    "category": "type",
    "text": "Region{ID} <: AbstractRegion\n\ndenotes the IDth Region.\n\n\n\n"
},

{
    "location": "man/hamiltonian/#QMTK.Nearest",
    "page": "Hamiltonian",
    "title": "QMTK.Nearest",
    "category": "type",
    "text": "shorthand for Region{1}\n\n\n\n"
},

{
    "location": "man/hamiltonian/#QMTK.NextNearest",
    "page": "Hamiltonian",
    "title": "QMTK.NextNearest",
    "category": "type",
    "text": "shorthand for Region{2}\n\n\n\n"
},

{
    "location": "man/hamiltonian/#man-hamiltonian-1",
    "page": "Hamiltonian",
    "title": "Hamiltonian",
    "category": "section",
    "text": "Hamiltonian of many-body system usually has the form of so called k-local Hamiltonian, which means each local hamiltonian only involves k bodies (bits).for example, the Hamiltonian of Traverse Field Ising ModelH = sum_i sigma_x^i + sum_ijsigma_z^isigma_z^jMore generally, a local Hamiltonian has the formH = sum_l_1l_2dotsl_m_1 in region(1) H_l_1 l_2 dots l_m_1 + sum_l_1 l_2 dots l_m_2 in region(2) H_l_1 l_2 dots l_m_2 + dots + sum_l_1 l_2 dots l_m_k in region(k) H_l_1 l_2 dots l_m_kwhere l_i denotes the ith body/site/bit/... of the system, region(k) denotes the kth region of the system, m_k denotes the number of body/site/bit/... involves in this region (e.g for nearest neighbor m_k is 2).Thus the form of hamiltonian can be define in a program without knowing the exact form of lattice/geometry.we offer a macro @ham to accomplish this, e.gWe can define a J1J2 hamiltonian on arbitrary lattice byusing QMTK\nusing QMTK.Consts.Paulih = @ham sum(:nearest, S * S) + sum(:nextnearest, S * S)The region is described by the type RegionRegion\nNearest\nNextNearestwe provide two shorthands for regions in @ham macro, one is :nearest denotes Region{1} and :nextnearest denotes Region{2}.TODO:allow use Region{N} in @ham\nallow to parse Region{0} to traverse sites"
},

{
    "location": "man/hamiltonian/#Access-the-Hamiltonian-1",
    "page": "Hamiltonian",
    "title": "Access the Hamiltonian",
    "category": "section",
    "text": "Only when the lattice is defined, the matrix form of a certain Hamiltonian is determined. Then we could access it.We offer two ways to access the matrix form of a Hamiltonian.The recommended way is to use iterators, all the instance of hamiltonian is callable with input of lattice and left-hands basis (site/bit/...).lattice = Chain(Fixed, 4)\nlhs = Sites(Bit, 4)\nfor (val, rhs) in h(lattice, lhs)\n    println(val, \", \",rhs)\nendIt will return an iterator that traverse all non-zeros values of left-hands basis.If you just want to use its matrix form rather than access part of its value, you can directly use matmat(h, lattice)"
},

{
    "location": "man/statistics/#",
    "page": "Statistics",
    "title": "Statistics",
    "category": "page",
    "text": ""
},

{
    "location": "man/statistics/#man-statistics-1",
    "page": "Statistics",
    "title": "Statistics",
    "category": "section",
    "text": ""
},

{
    "location": "man/statistics/#Sampler-1",
    "page": "Statistics",
    "title": "Sampler",
    "category": "section",
    "text": ""
},

{
    "location": "man/model/#",
    "page": "Model",
    "title": "Model",
    "category": "page",
    "text": ""
},

{
    "location": "man/model/#man-model-1",
    "page": "Model",
    "title": "Model",
    "category": "section",
    "text": ""
},

]}
