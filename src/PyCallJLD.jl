# See https://github.com/JuliaIO/JLD.jl/blob/master/doc/jld.md#custom-serialization
module PyCallJLD

using PyCall, JLD

const dumps = PyNULL()
const loads = PyNULL()

function __init__()
    copy!(dumps, pyimport("cPickle")[:dumps])
    copy!(loads, pyimport("cPickle")[:loads])
end

immutable PyObjectSerialization
    repr::String
end

JLD.readas(pyo_ser::PyObjectSerialization) = pycall(loads, PyObject, pyo_ser.repr)
JLD.writeas(pyo::PyObject) = PyObjectSerialization(dumps(pyo))

end # module
