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
    "text": "The QMTK library is developed for physics system involves quantum many-body system, including condensed matter physics, quantum computing, quantum information and etc.In most numerical and theoretical works, programs related to quantum physics and quantum many-body system could have a lot similar functionality, methods, and objects. We aims to offer a collection of algorithms, object abstractions for quantum many-body system, which will ease your daily work. QMTK aims to provide physicist with a powerful toolkit in Julia language as its frontend interface. Although, Julia language is a promising language for scientific computing, we are not limited to Julia.This project also aims to start an active developers community, we accept any feature request related to the following topic:quantum many-body system\nquantum information (including quantum computing)\ncondensed matter physicsIf you wish to have a new feature, or you wish to contribute to this project, please open an issue here to discuss the details and then start your pull request or your pull request may not be merged."
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
    "text": "Basis is a useful object when describing a Hilbert space. In quantum physics, there are many kind of basis in different problems, including qubits, lattice site, infinity basis, etc.The basis we mention here and implemented in this package is the tagged part. If you need to use Dirac ket operations, you can simply do it by hands with dot function in Julia\'s linear algebra stdlib. To be specific, the basis here means what is inside you ket expression.basisrangle or langle basis"
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
    "text": "QMTK offers three kind of labels: Bit, Spin, Half for binary configurations.Bit\nSpin\nHalf"
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
    "text": "data(basis)\n\nget data of the basis\n\n\n\n"
},

{
    "location": "man/basictype/#Sites-1",
    "page": "Basic Types",
    "title": "Sites",
    "category": "section",
    "text": "The abstract hierachy for site is defined as any subtype of AbstractArray with label.AbstractSitesSites is a Julia native array with certain label that tells the program which kind of site it is.SitesSites is implemented to support most of Julia array interface, but since Julia do not have inherit of interface, not all operations is overloaded, please use method data, when you need to access its content in calculatoin.data"
},

{
    "location": "man/basictype/#SubSites-1",
    "page": "Basic Types",
    "title": "SubSites",
    "category": "section",
    "text": "For small sites, it usually contains only a few configuration, and when we try to use a subset of Sites, it would be a waste to create a new Sites, SubSites offer a way to do this efficiently by telling the compiler how large it is in compile time (by Tuple).Or to be simple, you can just interpret SubSites to be a Tuple with certain SiteLabel."
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
    "text": "The physics constants module QMTK.Consts uses NIST CODATA Project\'s definitions of physics constants.You can bring defined Physics Constants\' name by callingjuila> using QMTK.ConstsThis will bring the following physics constatns"
},

{
    "location": "man/lattice/#",
    "page": "Lattice",
    "title": "Lattice",
    "category": "page",
    "text": ""
},

{
    "location": "man/lattice/#man-lattice-1",
    "page": "Lattice",
    "title": "Lattice",
    "category": "section",
    "text": ""
},

{
    "location": "man/hamiltonian/#",
    "page": "Hamiltonian",
    "title": "Hamiltonian",
    "category": "page",
    "text": ""
},

{
    "location": "man/hamiltonian/#man-hamiltonian-1",
    "page": "Hamiltonian",
    "title": "Hamiltonian",
    "category": "section",
    "text": ""
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
