import JSON
import Base: dirname, download, parse

########
# Utils
########

abstract type AbstractFormat end
abstract type JSONFormat <: AbstractFormat end
abstract type YAMLFormat <: AbstractFormat end

struct DataFile{Format<:AbstractFormat, ST<:AbstractString}
    url::ST
    localdir::ST
    filename::ST
end

DataFile(url::ST, dir::ST, name::ST) where {ST <: AbstractString} =
    DataFile{JSONFormat, ST}(url, dir, name)

url(file::DataFile) = file.url
dirname(file::DataFile) = file.localdir
filename(file::DataFile) = file.filename
filepath(file::DataFile) = joinpath(file.localdir, file.filename)

function obtain(file::DataFile)
    if !ispath(filepath(file))
        println("[Download]: $(filename(file))")
        download(file)
    end
end

function download(file::DataFile)
    mkpath(dirname(file))
    download(url(file), filepath(file))
end

function parse(file::DataFile{JSONFormat})
    raw = open(filepath(file), "r") do f
        readstring(f)
    end

    return JSON.parse(raw)
end

DATAFILES = Dict{String, DataFile}()