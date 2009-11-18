def constantize(name)
  if name =~ /::/
    parts = name.split(/::/)
    submodule = Module.const_get(parts.shift)
    until parts.empty?
      submodule = submodule.const_get(parts.shift)
    end
    submodule
  else
    Module.const_get(name)
  end
end

