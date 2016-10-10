require 'torch'
require 'nn'
require 'nnname'

--------------------------------
----- save and load model
--------------------------------

-- save the module by clone it, remove states, and remove gradients to reduce file size
function nn.Module:save(filepath)
    local clone = self:clone()
    clone:clearState()
    clone:float()
    if cudnn then
        cudnn.convert(clone, nn)
    end
    clone:apply(function(module)
            module.gradWeight = nil
            module.gradBias = nil
        end)
    torch.save(filepath, clone)
    return self
end

-- load model and reset weight
function nn.loadModel(filepath)
    local model = torch.load(filepath)
    model:apply(function(module)
            if module.weight and module.gradWeight == nil then
                module.gradWeight = module.weight.new(module.weight:size()):zero()
            end
            if module.bias and module.gradBias == nil then
                module.gradBias = module.bias.new(module.bias:size()):zero()
            end
        end)
    return model
end

--------------------------------
----- dealing with NaN
--------------------------------

function torch.replaceNaN(src, v)
    v = v or 0
    assert(type(v) == 'number', 'the third argument of replaceNaN is not a number')
    local result = src:clone()
    result[result:ne(result)] = v
    return result
end

function torch.Tensor:replaceNaN(v)
    v = v or 0
    assert(type(v) == 'number', 'the third argument of replaceNaN is not a number')
    self[self:ne(self)] = v
    return self
end

function addNaNdecorator(m)
    return nn.NaN(m)
end

--------------------------------
----- get Process ID
-------------------------------
function getPID()
    local f = torch.DiskFile('/proc/self/stat', 'r')
    local pid = f:readInt()
    f:close()
    return pid
end
