class String
  def constantize
    if self =~ /::/
      parts = self.split(/::/)
      submodule = Module.const_get(parts.shift)
      until parts.empty?
        submodule = submodule.const_get(parts.shift)
      end
      submodule
    else
      Module.const_get(self)
    end
  end
end
