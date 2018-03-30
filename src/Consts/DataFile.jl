# Abstracts
export AbstractFormat, JSONFormat, YAMLFormat

# DataFile
export DataFile

# Interface
export obtain, filename, filepath, url
import Base: dirname, download, parse, show

using JSON

abstract type AbstractFormat end
abstract type JSONFormat <: AbstractFormat end
abstract type YAMLFormat <: AbstractFormat end

"""
    DataFile

Physical data files, it stores the constants.
"""
struct DataFile{Format<:AbstractFormat, ST<:AbstractString}
    url::ST
    localdir::ST
    filename::ST
end

DataFile(url::ST, dir::ST, name::ST) where ST =
    DataFile{JSONFormat, ST}(url, abspath(dir), name)

# DataFile Interface
url(file::DataFile) = file.url
dirname(file::DataFile) = file.localdir
filename(file::DataFile) = file.filename
filepath(file::DataFile) = joinpath(file.localdir, file.filename)

"""
    obtain(file)

obtain data file. Do nothing if this file already exists.
"""
function obtain(file::DataFile)
    if !ispath(filepath(file))
        info(filename(file), prefix="[Download]: ")
        download(file)
    end
end

"""
    download(file)

download data file.
"""
function download(file::DataFile)
    mkpath(dirname(file))
    download(url(file), filepath(file))
end

"""
    parse(file) -> Dict

parse data file to julia dict.
"""
function parse(file::DataFile{JSONFormat})
    raw = open(filepath(file), "r") do f
        Compat.read(f, String)
    end

    # workaround for JSON
    # Download again if JSON.parse fails
    # TODO: md5 check
    try
        JSON.parse(raw)
    catch
        download(file)
        parse(file)
    end
end

function show(io::IO, file::DataFile{F, S}) where {F, S}
    print(io, "DataFile{$F, $S}\n")
    print(io, "  url: $(url(file))\n")
    print(io, "  local: $(filepath(file))")
end
