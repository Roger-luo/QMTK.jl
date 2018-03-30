"""
    AbstractSites{Label, T, N} <: AbstractArray{T, N}

Sites are arrays with certain labels
"""
abstract type AbstractSites{Label, T, N} <: AbstractArray{T, N} end

"""
get sitetype from subtypes of `AbstractSites` 
"""
function sitetype end

import Compat.Random: rand, rand!, GLOBAL_RNG
export rand!, rand

# TODO: add documents
function rand! end
function rand end
function flip! end
function randflip! end
